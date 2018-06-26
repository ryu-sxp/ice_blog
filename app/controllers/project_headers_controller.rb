class ProjectHeadersController < ApplicationController
  before_action :set_project_header, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  # GET /project_headers
  # GET /project_headers.json
  def index
    @project_headers = ProjectHeader.all
  end

  # GET /project_headers/1
  # GET /project_headers/1.json
  def show
  end

  # GET /project_headers/new
  def new
    @project_header = ProjectHeader.new
  end

  # GET /project_headers/1/edit
  def edit
  end

  # POST /project_headers
  # POST /project_headers.json
  def create
    @project_header = ProjectHeader.new(project_header_params)

    respond_to do |format|
      if @project_header.save
        format.html { redirect_to @project_header, notice: 'Project header was successfully created.' }
        format.json { render :show, status: :created, location: @project_header }
      else
        format.html { render :new }
        format.json { render json: @project_header.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_headers/1
  # PATCH/PUT /project_headers/1.json
  def update
    respond_to do |format|
      if @project_header.update(project_header_params)
        format.html { redirect_to @project_header, notice: 'Project header was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_header }
      else
        format.html { render :edit }
        format.json { render json: @project_header.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_headers/1
  # DELETE /project_headers/1.json
  def destroy
    @project_header.destroy
    respond_to do |format|
      format.html { redirect_to project_headers_url, notice: 'Project header was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_header
      @project_header = ProjectHeader.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_header_params
      params.require(:project_header).permit(:name)
    end
end
