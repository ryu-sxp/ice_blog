class MicropostsController < ApplicationController
  before_action :set_micropost, only: [:show, :edit, :update, :destroy,
                                       :push_to_mstdn]
  before_action :admin_user

  # GET /microposts
  # GET /microposts.json
  def index
    @microposts = Micropost.all
  end

  # GET /microposts/1
  # GET /microposts/1.json
  def show
  end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
    client = IceBlog::get_mastodon_client
    muser = client.user_get
    unless muser.error?
      @micropost.visibility = muser.source['privacy']
    else
      @micropost.visibility = "public"
    end
  end

  # GET /microposts/1/edit
  def edit
  end

  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = Micropost.new(micropost_params)
    @micropost.user_id = @current_user.id

    if @micropost.save
      if send_toot == 2
        #PendingToot.create(
        #  source_model: "micropost",
        #  source_id: @micropost.id)
        redirect_to @micropost,
          notice: "Micropost was successfully created, but"+
          " the API push failed. #{@mstdn_msg}"
      else
        redirect_to @micropost, notice: 'Micropost was successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /microposts/1
  # PATCH/PUT /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to @micropost, notice: 'Micropost was successfully updated.' }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to microposts_url, notice: 'Micropost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def push_to_mstdn
    status = send_toot
    case status
    when 0
      redirect_to microposts_url, notice:
        "API push worked fine. (you should still check just in case)"
    when 1
      redirect_to microposts_url,
        notice: "Your settings don't allow posting to mstdn "+
                  "or the post already has a toot id."
    when 2
      redirect_to microposts_url, notice: "API push failed. #{@mstdn_msg}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def micropost_params
      params.require(:micropost).permit(:published_date, :content, :published,
                                        :image, :image_cache, :remove_image,
                                        {image_dimensions: []}, :toot_id,
                                        :sensitive, :spoiler_text, :video,
                                        :remove_video, :video_cache,
                                        :visibility, :relevant_media)
    end

    def send_toot
      if @micropost.toot_id.nil? && @current_user.tweet_posts?
        client = IceBlog::get_mastodon_client
        options = Hash.new
        if (@micropost.image.present? || @micropost.video.present?) && 
            @micropost.media_id.nil?

          if @micropost.image.present?
            file = open("public"+@micropost.image_url.to_s)
          end
          if @micropost.video.present?
            file = open("public"+@micropost.video_url.to_s)
          end
          media = client.media_put(file)
          file.close
          if media.error?
            @mstdn_msg = media.msg
            return 2
          else
            @micropost.update(media_id: media.id)
          end
        end
        # if media upload was successful/not needed
        if @micropost.media_id.present?
          options[:'media_ids[]'] = @micropost.media_id
        end
        options[:visibility] = @micropost.visibility
        options[:sensitive] = @micropost.sensitive
        options[:spoiler_text] = @micropost.spoiler_text
        toot = client.status_put(@micropost.content, options)
        unless toot.error?
          @micropost.update(toot_id: toot.id)
          return 0
        else
          @mstdn_msg = toot.msg
          return 2
        end
      else
        return 1
      end
    end

end
