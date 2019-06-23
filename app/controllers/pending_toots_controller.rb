class PendingTootsController < ApplicationController
  before_action :set_pending_toot, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  # GET /pending_toots
  # GET /pending_toots.json
  def index
    @pending_toots = PendingToot.all
  end

  # GET /pending_toots/1
  # GET /pending_toots/1.json
  def show
  end

  # GET /pending_toots/new
  def new
    @pending_toot = PendingToot.new
  end

  # GET /pending_toots/1/edit
  def edit
  end

  # POST /pending_toots
  # POST /pending_toots.json
  def create
    @pending_toot = PendingToot.new(pending_toot_params)

    respond_to do |format|
      if @pending_toot.save
        format.html { redirect_to @pending_toot, notice: 'Pending toot was successfully created.' }
        format.json { render :show, status: :created, location: @pending_toot }
      else
        format.html { render :new }
        format.json { render json: @pending_toot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pending_toots/1
  # PATCH/PUT /pending_toots/1.json
  def update
    respond_to do |format|
      if @pending_toot.update(pending_toot_params)
        format.html { redirect_to @pending_toot, notice: 'Pending toot was successfully updated.' }
        format.json { render :show, status: :ok, location: @pending_toot }
      else
        format.html { render :edit }
        format.json { render json: @pending_toot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pending_toots/1
  # DELETE /pending_toots/1.json
  def destroy
    @pending_toot.destroy
    respond_to do |format|
      format.html { redirect_to pending_toots_url, notice: 'Pending toot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pending_toot
      @pending_toot = PendingToot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pending_toot_params
      params.require(:pending_toot).permit(:message, :source_model, :source_id, :media_id, :requires_file)
    end
end
