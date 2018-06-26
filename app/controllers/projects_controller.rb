class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :publish,
                                     :overwrite_content]
  before_action :admin_user

  # GET /projects # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @header  = ProjectHeader.new
    if @project.draft.nil?
      @project.draft = "---\nheader: Default\n---"
    end
  end

  # GET /projects/1/edit
  def edit
    @header  = ProjectHeader.find_by(id: @project.project_header_id)
  end

  # POST /projects
  # POST /projects.json
  def create
    @project   = Project.new(project_params)
    @header    = ProjectHeader.new
    header_ok  = false
    project_ok = false
    if @project.save
      data = YAML.load(@project.draft)
      data.symbolize_keys!
      # process header
      unless @header = ProjectHeader.find_by(name: data[:header])
        @header = ProjectHeader.create(name: data[:header])
        unless @header.errors.any?
          header_new = true
          header_ok = true
        else
          header_new = false
          header_ok = false
        end
      else
        header_ok = true
      end
      # process project
      content = @project.draft.split("---\r\n")
      if content[2]
        content_markup = markup(content[2])
        @project.update(project_header_id: @header.id, content: content_markup,
                        published: false)
        project_ok =  !@project.errors.any?
      else
        @project.errors.add :draft, "no content submitted"
      end
    end
    if header_ok && project_ok

      redirect_to @project,
        notice: 'Project was successfully created.'
    else
      if header_new
        @header.delete
      end
      @project.delete
      render :new 
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @header    = ProjectHeader.new
    @project.previous_header_id = @project.project_header_id
    header_ok  = false
    project_ok = false
    @project.update(project_params)
    unless @project.errors.any?
      data = YAML.load(@project.draft)
      data.symbolize_keys!
      # process header
      unless @header = ProjectHeader.find_by(name: data[:header])
        @header = ProjectHeader.create(name: data[:header])
        unless @header.errors.any?
          header_new = true
          header_ok = true
        else
          header_new = false
          header_ok = false
        end
      else
        header_ok = true
      end
      # process project
      content = @project.draft.split("---\r\n")
      if content[2]
        content_markup = markup(content[2])
        @project.update(project_header_id: @header.id,)
        if @project.content != content_markup ||
           @project.content_update.present?

          @project.update(content_update: content_markup)
        end
        project_ok =  !@project.errors.any?
      else
        @project.errors.add :draft, "no content submitted"
      end
    end
    if header_ok && project_ok

      @project.clean_header_update

      redirect_to @project,
        notice: 'Project was successfully updated.'
    else
      if header_new
        @header.delete
      end
      render :edit
    end
  end

  def publish
    @project.update(published: true)
    redirect_to @project, notice: 'Project was successfully published'
  end
  
  def hide
    @project.update(published: false)
    redirect_to @project, notice: 'Project was successfully hidden'
  end

  def overwrite_content
    @project.content = @project.content_update
    @project.content_update = nil
    if @project.save
      redirect_to @project, notice: 'Content was replaced with updated value'
    else
      redirect_to @project, notice: 'Something went wrong'
    end
  end


  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :draft,
                                      :icon, :icon_cashe, :remove_icon)
    end
end
