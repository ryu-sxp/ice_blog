class CommentsController < ApplicationController
  layout 'ajax', :only => [:request_comments, :create]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_theme, only: [:request_comments, :request_form,
                                   :create, :destroy]
  before_action :get_comment_flag, only: [:request_comments,
                                          :request_form, :create]
  before_action :get_current_user, only: [:request_comments, :create]
  before_action :admin_user, except: [:request_comments, :request_form,
                                      :create]
  invisible_captcha only: [:create], timestamp_threshold: 1


  # GET /cms/micropost/1
  def request_comments
    @cid = params[:id]
    @cmodel = params[:model]
    @comments = Comment.where(source_model: @cmodel, source_id: @cid).order(
      "created_at DESC")
    @ip_blacklist = IpBlacklist.new

    render "main/#{@theme}/comments"
  end

  # GET /cms/form/source_model/1/source_id/1
  def request_form
    @comment = Comment.new
    @source_model =  params[:source_model]
    @source_id    =  params[:source_id]
    @reply_id     =  params[:reply_id]
    respond_to do |format|
      format.js {
        render "main/#{@theme}/show_comment_form", layout: 'ajax'
      }
    end
  end

  #####################################################
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.ip = request.ip
    @comment.useragent = request.user_agent
    if @current_user && @current_user.admin?
      @comment.moderator_id = @current_user.id
    end


    respond_to do |format|
      if @comment.save
        @spam_status = blogspam_check
        unless @spam_status == 0
          @comment.destroy
        else
          User.find(1).send_comment_mail(@comment)
        end

        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
        format.js {
          @post_status = 'ok'
          render "main/#{@theme}/update_comment_form"
        }
      else
        @comment.name = @comment.name_backup
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js {
          @post_status = 'fail'
          render "main/#{@theme}/update_comment_form"
        }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    SpamComment.create(
      name:              @comment.name,
      email:             @comment.email,
      website:           @comment.website,
      content:           @comment.content,
      ip:                @comment.ip,
      useragent:         @comment.useragent
    )
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
      format.js {
        render "main/#{@theme}/delete_comment"
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:name, :trip, :email, :website,
                                      :source_model, :source_id, :content)
    end

    def get_comment_flag
      user = User.find(1)
      @comment_flag = user.comment_flag
    end

    def blogspam_check
      # returns status code
      # 0 = no problem, passes
      # 1 = spam detected
      # 2 = request failed
      if User.find(1).blog_spam_flag
        # blog spam checking enabled
        uri = URI.parse("http://test.blogspam.net:9999")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new('/',
                                      'Content-Type' => 'application/json')
        form_data = {
          comment: @comment.content,
          ip:      @comment.ip,
          agent:   @comment.useragent,
          email:   @comment.email,
          link:    @comment.website,
          name:    @comment.name,
          options: "fail=true,min-words=10",
          site:    IceBlog.url,
          version: "2.0"
        }
        request.body = form_data.to_json
        response = http.request(request)
        # response is a json hash
        # -> save error and reason to db table
        # add error to self if blogspam returns error or spam
        if response.code == '200'
          res = JSON.parse(response.body)
          if res['result'] == 'OK'
            #  no problems
            return 0
          else
            # blogspam responded with error or spam
            if res.key?('reason')
              bs_reason = res['reason']
            else
              bs_reason = nil
            end
            if res.key?('blocker')
              bs_blocker = res['blocker']
            else
              bs_blocker = nil
            end
            if res.key?('version')
              bs_version = res['version']
            else
              bs_version = nil
            end
            SpamComment.create(
              name:              @comment.name,
              email:             @comment.email,
              website:           @comment.website,
              content:           @comment.content,
              blog_spam_result:  res['result'],
              blog_spam_reason:  bs_reason,
              blog_spam_blocker: bs_blocker,
              blog_spam_version: bs_version,
              ip:                @comment.ip,
              useragent:         @comment.useragent
            )
            return 1
          end
        else
          # request failed
          return 2
        end
      else
        return 0
      end
    end
end
