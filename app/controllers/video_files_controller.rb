class VideoFilesController < ApplicationController
  before_action :set_video_file, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  # GET /video_files
  # GET /video_files.json
  def index
    @video_files = VideoFile.all
  end

  # GET /video_files/1
  # GET /video_files/1.json
  def show
  end

  # GET /video_files/new
  def new
    @video_file = VideoFile.new
  end

  # GET /video_files/1/edit
  def edit
  end

  # POST /video_files
  # POST /video_files.json
  def create
    @video_file = VideoFile.new(video_file_params)

    respond_to do |format|
      if @video_file.save
        format.html { redirect_to @video_file, notice: 'Video file was successfully created.' }
        format.json { render :show, status: :created, location: @video_file }
      else
        format.html { render :new }
        format.json { render json: @video_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /video_files/1
  # PATCH/PUT /video_files/1.json
  def update
    respond_to do |format|
      if @video_file.update(video_file_params)
        format.html { redirect_to @video_file, notice: 'Video file was successfully updated.' }
        format.json { render :show, status: :ok, location: @video_file }
      else
        format.html { render :edit }
        format.json { render json: @video_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /video_files/1
  # DELETE /video_files/1.json
  def destroy
    @video_file.destroy
    respond_to do |format|
      format.html { redirect_to video_files_url, notice: 'Video file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_file
      @video_file = VideoFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_file_params
      params.require(:video_file).permit(:name, :item, :type, :remove_item,
                                         :item_cache)
    end
end
