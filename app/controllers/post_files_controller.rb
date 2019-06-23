class PostFilesController < ApplicationController
  before_action :set_post_file, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  # GET /post_files
  # GET /post_files.json
  def index
    @post_files = PostFile.all
  end

  # GET /post_files/1
  # GET /post_files/1.json
  def show
  end

  # GET /post_files/new
  def new
    @post_file = PostFile.new
  end

  # GET /post_files/1/edit
  def edit
  end

  # POST /post_files
  # POST /post_files.json
  def create
    @post_file = PostFile.new(post_file_params)

    respond_to do |format|
      if @post_file.save
        format.html { redirect_to @post_file, notice: 'Post file was successfully created.' }
        format.json { render :show, status: :created, location: @post_file }
      else
        format.html { render :new }
        format.json { render json: @post_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /post_files/1
  # PATCH/PUT /post_files/1.json
  def update
    respond_to do |format|
      if @post_file.update(post_file_params)
        format.html { redirect_to @post_file, notice: 'Post file was successfully updated.' }
        format.json { render :show, status: :ok, location: @post_file }
      else
        format.html { render :edit }
        format.json { render json: @post_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /post_files/1
  # DELETE /post_files/1.json
  def destroy
    @post_file.destroy
    respond_to do |format|
      format.html { redirect_to post_files_url, notice: 'Post file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post_file
      @post_file = PostFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_file_params
      params.require(:post_file).permit(:name, :item, :type, :image_dimensions,
                                        :remove_item, :item_cache)
    end
end
