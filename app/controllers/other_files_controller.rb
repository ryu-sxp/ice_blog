class OtherFilesController < ApplicationController
  before_action :set_other_file, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  # GET /other_files
  # GET /other_files.json
  def index
    @other_files = OtherFile.all
  end

  # GET /other_files/1
  # GET /other_files/1.json
  def show
  end

  # GET /other_files/new
  def new
    @other_file = OtherFile.new
  end

  # GET /other_files/1/edit
  def edit
  end

  # POST /other_files
  # POST /other_files.json
  def create
    @other_file = OtherFile.new(other_file_params)

    respond_to do |format|
      if @other_file.save
        format.html { redirect_to @other_file, notice: 'Other file was successfully created.' }
        format.json { render :show, status: :created, location: @other_file }
      else
        format.html { render :new }
        format.json { render json: @other_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /other_files/1
  # PATCH/PUT /other_files/1.json
  def update
    respond_to do |format|
      if @other_file.update(other_file_params)
        format.html { redirect_to @other_file, notice: 'Other file was successfully updated.' }
        format.json { render :show, status: :ok, location: @other_file }
      else
        format.html { render :edit }
        format.json { render json: @other_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /other_files/1
  # DELETE /other_files/1.json
  def destroy
    @other_file.destroy
    respond_to do |format|
      format.html { redirect_to other_files_url, notice: 'Other file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_other_file
      @other_file = OtherFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def other_file_params
      params.require(:other_file).permit(:name, :item, :remove_item,
                                         :item_cache)
    end
end
