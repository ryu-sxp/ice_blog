class SpamCommentsController < ApplicationController
  before_action :set_spam_comment, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  # GET /spam_comments
  # GET /spam_comments.json
  def index
    @spam_comments = SpamComment.all
  end

  # GET /spam_comments/1
  # GET /spam_comments/1.json
  def show
  end

  # GET /spam_comments/new
  def new
    @spam_comment = SpamComment.new
  end

  # GET /spam_comments/1/edit
  def edit
  end

  # POST /spam_comments
  # POST /spam_comments.json
  def create
    @spam_comment = SpamComment.new(spam_comment_params)

    respond_to do |format|
      if @spam_comment.save
        format.html { redirect_to @spam_comment, notice: 'Spam comment was successfully created.' }
        format.json { render :show, status: :created, location: @spam_comment }
      else
        format.html { render :new }
        format.json { render json: @spam_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spam_comments/1
  # PATCH/PUT /spam_comments/1.json
  def update
    respond_to do |format|
      if @spam_comment.update(spam_comment_params)
        format.html { redirect_to @spam_comment, notice: 'Spam comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @spam_comment }
      else
        format.html { render :edit }
        format.json { render json: @spam_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spam_comments/1
  # DELETE /spam_comments/1.json
  def destroy
    @spam_comment.destroy
    respond_to do |format|
      format.html { redirect_to spam_comments_url, notice: 'Spam comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spam_comment
      @spam_comment = SpamComment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spam_comment_params
      params.require(:spam_comment).permit(:name, :email, :website, :content, :blog_spam_result, :blog_spam_reason, :blog_spam_blocker, :blog_spam_version, :ip, :useragent)
    end
end
