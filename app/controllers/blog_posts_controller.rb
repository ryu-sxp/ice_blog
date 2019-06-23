class BlogPostsController < ApplicationController
  before_action :set_blog_post, only: [:show, :edit, :update, :destroy, 
                                       :hide, :publish, :overwrite_content,
                                       :push_to_mstdn]
  before_action :admin_user

  # GET /blog_posts
  # GET /blog_posts.json
  def index
    @blog_posts = BlogPost.all
  end

  # GET /blog_posts/1
  # GET /blog_posts/1.json
  def show
  end

  # GET /blog_posts/new
  def new
    @blog_post = BlogPost.new
    @cat       = BlogCategory.new
    if @blog_post.draft.nil?
      @blog_post.draft = 
        "---\ntitle: Default\ndate: "+
        "\ncategory: Default\ntags:\n-\n-\n"+
        "preview: Default...\ntoot: New Blog Post!!!\n---"
    end
  end

  # GET /blog_posts/1/edit
  def edit
    @cat = BlogCategory.find_by(id: @blog_post.blog_category_id)
  end

  # POST /blog_posts
  # POST /blog_posts.json
  def create
    create_draft
  end

  # PATCH/PUT /blog_posts/1
  # PATCH/PUT /blog_posts/1.json
  def update
    update_draft
  end
  
  # GET /blog_post/upload/draft_form
  def draft_upload_form
  end
  
  # POST /blog_post/upload/draft
  def draft_upload
    if params.has_key? :draft_file
      file = params[:draft_file]
      if file.content_type == 'text/markdown'
        draft = Hash.new
        draft[:draft_name]    = file.original_filename
        draft[:draft_content] = file.read
        if @blog_post = BlogPost.find_by(name: draft[:draft_name])
          update_draft(draft)
        else
          create_draft(draft)
        end
      else
        flash.now[:danger] = 'invalid file type (requires text/markdown (.md))'
        render 'draft_upload_form'
      end
    else
      flash.now[:danger] = 'no file was uploaded!'
      render 'draft_upload_form'
    end
  end

  # DELETE /blog_posts/1
  # DELETE /blog_posts/1.json
  def destroy
    @blog_post.destroy
    respond_to do |format|
      format.html { redirect_to blog_posts_url, notice: 'Blog post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish
    if @blog_post.published_date_pending?
      @blog_post.published_date = Time.zone.now
    end
    @blog_post.published = true
    @blog_post.save
    msg = @blog_post.toot+"\n\n"+article_url(@blog_post, { protocol: 'https' })
    if send_toot(msg) == 2
      #PendingToot.create(
      #  message: msg,
      #  source_model: "blog_post",
      #  source_id: @blog_post.id)
      redirect_to blog_posts_url,
        notice:
          "Blog post was successfully published, but the API push failed:"+
          " #{@mstdn_msg}"
    else
      redirect_to blog_posts_url,
        notice: 'Blog post was successfully published!'
    end
  end

  def hide
    @blog_post.published = false
    @blog_post.save
    redirect_to blog_posts_url, notice: 'Blog post was successfully hidden!'
  end

  def overwrite_content
    @blog_post.content = @blog_post.content_update
    @blog_post.content_update = nil
    if @blog_post.save
      redirect_to @blog_post, notice: 'Content was replaced with updated value'
    else
      redirect_to @blog_post, notice: 'Something went wrong'
    end
  end

  def push_to_mstdn
    msg = @blog_post.toot+"\n\n"+article_url(@blog_post, { protocol: 'https' })
    status = send_toot(msg)
    case status
    when 0
      redirect_to blog_posts_url, notice:
        "API push worked fine. (you should still check just in case)"
    when 1
      redirect_to blog_posts_url,
        notice: "Your settings don't allow posting to mstdn "+
                  "or the post already has a toot id."
    when 2
      redirect_to blog_posts_url, notice: "API push failed. #{@mstdn_msg}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_post
      @blog_post = BlogPost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_post_params
      params.require(:blog_post).permit(:name, :draft, :icon,
                                        :icon_cache, :remove_icon)
    end

    def get_content(str)
      #return nil if str.nil?
      content = str.split("---\r\n")
      content = content[2]
      # file uploads don't insert the carriage return
      if content.nil?
        content = str.split("---\n")
        content = content[2]
      end
      content
    end

    def create_draft(options = {})
      if options.empty? == false
        file_source = true
        @blog_post = BlogPost.new(name: options[:draft_name],
                                  draft: options[:draft_content])
      else
        file_source = false
        @blog_post = BlogPost.new(blog_post_params)
      end

      @cat = BlogCategory.new
      cat_ok = false
      post_ok = false
      @blog_post.user_id = @current_user.id
      if @blog_post.save
        data = YAML.load(@blog_post.draft)
        data.symbolize_keys!
        # process category
        unless @cat = BlogCategory.find_by(name: data[:category])
          @cat = BlogCategory.create(name: data[:category])
          unless @cat.errors.any?
            cat_new = true
            cat_ok = true
          else
            cat_new = false
            cat_ok = false
          end
        else
          cat_ok = true
        end
        # process post
        content = get_content(@blog_post.draft)
        unless content.nil?
          content_markup = markup(content)
          @blog_post.update(title: data[:title],
                            blog_category_id: @cat.id,
                            user_id: @current_user.id,
                            published_date: data[:date],
                            preview: data[:preview],
                            toot: data[:toot],
                            published: false,
                            content: content_markup)
          post_ok = !@blog_post.errors.any?
        else
          @blog_post.errors.add :draft, "no content submitted"
        end
      end
      if post_ok
        # process tags
        data[:tags].each do |tag|
          unless tag.nil? || tag.empty?
            @blog_post.tags.create(name: tag)
          end
        end
      end
      if cat_ok && post_ok
        unless file_source
          @blog_post.update(name: "#{Time.zone.now.to_i}_#{data[:title]}")
        end
        if data[:date].nil?
          @blog_post.update(published_date: Time.zone.now,
                            published_date_pending: true)
        end
        redirect_to @blog_post,
          notice: 'Blog post was successfully created.'
      else
        if cat_new
          @cat.delete
        end
        @blog_post.delete
        render :new
      end
    end

    def update_draft(options = {})
      if options.empty? == false
        file_source = true
        @blog_post = BlogPost.find_by(name: options[:draft_name])
      else
        file_source = false
      end
      @cat = BlogCategory.new
      @blog_post.previous_category_id = @blog_post.blog_category_id
      cat_ok = false
      post_ok = false
      if file_source
        @blog_post.update(draft: options[:draft_content])
      else
        @blog_post.update(blog_post_params)
      end
      unless @blog_post.errors.any?
        data = YAML.load(@blog_post.draft)
        data.symbolize_keys!
        # process category
        unless @cat = BlogCategory.find_by(name: data[:category])
          @cat = BlogCategory.create(name: data[:category])
          unless @cat.errors.any?
            cat_new = true
            cat_ok = true
          else
            cat_new = false
            cat_ok = false
          end
        else
          cat_ok = true
        end
        # process post
        content = get_content(@blog_post.draft)
        unless content.nil?
          content_markup = markup(content)
          @blog_post.tags.delete_all
          data[:tags].each do |tag|
            unless tag.nil? || tag.empty?
              @blog_post.tags.create(name: tag)
            end
          end
          @blog_post.update(blog_category_id: @cat.id,
                            title: data[:title],
                            preview: data[:preview])
          if (@blog_post.content != content_markup) ||
              @blog_post.content_update.present?

            @blog_post.update(content_update: content_markup)
          end
          post_ok = !@blog_post.errors.any?
        else
          @blog_post.errors.add :draft, "no content submitted"
        end
      end
      if cat_ok && post_ok

        @blog_post.clean_category_update

        redirect_to @blog_post,
          notice: 'Blog post was successfully updated.'
      else
        if cat_new
          @cat.delete
        end
        render :edit
      end
    end

    def send_toot(msg)
      # returns status code
      # 0 = api push successfull
      # 1 = don't have internal permission to attempt the push
      # 2 = api failed
      if @blog_post.toot_id.nil? && @current_user.tweet_posts?
        client = IceBlog::get_mastodon_client
        options = {visibility: @current_user.blog_post_toot_visibility}
        toot = client.status_put(msg, options)
        unless toot.error?
          @blog_post.update(toot_id: toot.id)
          return 0
        else
          @mstdn_msg = toot.msg
          return 2
        end
      end
      return 1
    end

end
