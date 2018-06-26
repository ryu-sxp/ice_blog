class IpBlacklistsController < ApplicationController
  layout 'ajax', :only => [:create]
  before_action :set_ip_blacklist, only: [:show, :edit, :update, :destroy]
  before_action :set_theme, only: [:create]
  before_action :get_current_user, only: [:create]
  before_action :admin_user

  # GET /ip_blacklists
  # GET /ip_blacklists.json
  def index
    @ip_blacklists = IpBlacklist.all
  end

  # GET /ip_blacklists/1
  # GET /ip_blacklists/1.json
  def show
  end

  # GET /ip_blacklists/new
  def new
    @ip_blacklist = IpBlacklist.new
  end

  # GET /ip_blacklists/1/edit
  def edit
  end

  # POST /ip_blacklists
  # POST /ip_blacklists.json
  def create
    @ip_blacklist = IpBlacklist.new(ip_blacklist_params)
    @comment_id = params[:ip_blacklist][:comment_id]
    @ip_blacklist.duration = @ip_blacklist.duration*3600

    respond_to do |format|
      if @ip_blacklist.save
        expires_at = @ip_blacklist.created_at.to_i + @ip_blacklist.duration
        to_next_hour = expires_at - (expires_at % 3600);
        expires_at = to_next_hour + 3600;
        @ip_blacklist.update(expires_at: expires_at)
        @status = true
        format.html { redirect_to @ip_blacklist, notice: 'Ip blacklist was successfully created.' }
        format.json { render :show, status: :created, location: @ip_blacklist }
        format.js {
          render "main/#{@theme}/ip_ban"
        }
      else
        @status = false
        format.html { render :new }
        format.json { render json: @ip_blacklist.errors, status: :unprocessable_entity }
        format.js {
          render "main/#{@theme}/ip_ban"
        }
      end
    end
  end

  # PATCH/PUT /ip_blacklists/1
  # PATCH/PUT /ip_blacklists/1.json
  def update
    respond_to do |format|
      if @ip_blacklist.update(ip_blacklist_params)
        format.html { redirect_to @ip_blacklist, notice: 'Ip blacklist was successfully updated.' }
        format.json { render :show, status: :ok, location: @ip_blacklist }
      else
        format.html { render :edit }
        format.json { render json: @ip_blacklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ip_blacklists/1
  # DELETE /ip_blacklists/1.json
  def destroy
    @ip_blacklist.destroy
    respond_to do |format|
      format.html { redirect_to ip_blacklists_url, notice: 'Ip blacklist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ip_blacklist
      @ip_blacklist = IpBlacklist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ip_blacklist_params
      params.require(:ip_blacklist).permit(:ip, :duration, :reason)
    end
end
