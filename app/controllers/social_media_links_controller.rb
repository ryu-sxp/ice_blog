class SocialMediaLinksController < ApplicationController
  before_action :set_social_media_link, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  # GET /social_media_links
  # GET /social_media_links.json
  def index
    @social_media_links = SocialMediaLink.all
  end

  # GET /social_media_links/1
  # GET /social_media_links/1.json
  def show
  end

  # GET /social_media_links/new
  def new
    @social_media_link = SocialMediaLink.new
  end

  # GET /social_media_links/1/edit
  def edit
  end

  # POST /social_media_links
  # POST /social_media_links.json
  def create
    @social_media_link = SocialMediaLink.new(social_media_link_params)

    respond_to do |format|
      if @social_media_link.save
        format.html { redirect_to @social_media_link, notice: 'Social media link was successfully created.' }
        format.json { render :show, status: :created, location: @social_media_link }
      else
        format.html { render :new }
        format.json { render json: @social_media_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /social_media_links/1
  # PATCH/PUT /social_media_links/1.json
  def update
    respond_to do |format|
      if @social_media_link.update(social_media_link_params)
        format.html { redirect_to @social_media_link, notice: 'Social media link was successfully updated.' }
        format.json { render :show, status: :ok, location: @social_media_link }
      else
        format.html { render :edit }
        format.json { render json: @social_media_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /social_media_links/1
  # DELETE /social_media_links/1.json
  def destroy
    @social_media_link.destroy
    respond_to do |format|
      format.html { redirect_to social_media_links_url, notice: 'Social media link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_social_media_link
      @social_media_link = SocialMediaLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def social_media_link_params
      params.require(:social_media_link).permit(:name, :url, :text, :user_id)
    end
end
