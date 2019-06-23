class StickyMessagesController < ApplicationController
  before_action :set_sticky_message, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  # GET /sticky_messages
  # GET /sticky_messages.json
  def index
    @sticky_messages = StickyMessage.all
  end

  # GET /sticky_messages/1
  # GET /sticky_messages/1.json
  def show
  end

  # GET /sticky_messages/new
  def new
    @sticky_message = StickyMessage.new
  end

  # GET /sticky_messages/1/edit
  def edit
  end

  # POST /sticky_messages
  # POST /sticky_messages.json
  def create
    @sticky_message = StickyMessage.new(sticky_message_params)
    @sticky_message.content = markup(@sticky_message.draft)
    @sticky_message.user_id = @current_user.id

    respond_to do |format|
      if @sticky_message.save
        format.html { redirect_to @sticky_message, notice: 'Sticky message was successfully created.' }
        format.json { render :show, status: :created, location: @sticky_message }
      else
        format.html { render :new }
        format.json { render json: @sticky_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sticky_messages/1
  # PATCH/PUT /sticky_messages/1.json
  def update
    @sticky_message.draft       = params[:sticky_message][:draft]
    @sticky_message.published   = params[:sticky_message][:published]
    @sticky_message.important   = params[:sticky_message][:important]
    @sticky_message.content     = markup(params[:sticky_message][:draft])
    respond_to do |format|
      if @sticky_message.save
        format.html { redirect_to @sticky_message, notice: 'Sticky message was successfully updated.' }
        format.json { render :show, status: :ok, location: @sticky_message }
      else
        format.html { render :edit }
        format.json { render json: @sticky_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sticky_messages/1
  # DELETE /sticky_messages/1.json
  def destroy
    @sticky_message.destroy
    respond_to do |format|
      format.html { redirect_to sticky_messages_url, notice: 'Sticky message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sticky_message
      @sticky_message = StickyMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sticky_message_params
      params.require(:sticky_message).permit(:draft, :published, :important)
    end
end
