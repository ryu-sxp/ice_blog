class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper

  before_action :write_request
  before_action :set_globals

  def layout_switch
    if params.key?(:theme) && params.key?(:skin)
      unless params[:theme].match(/\A[a-z]{1,255}\z/) &&
        params[:skin].match(/\A[a-z]{1,255}\z/)

        not_found
      end

      if (IceBlog.config(:themes)).include? params[:theme]
        @theme = params[:theme]
      else
        @theme = (IceBlog.config(:themes))[0]
      end

      if (IceBlog.config(:skins))[:"#{@theme}"].include? params[:skin]
        @skin = params[:skin]
      else
        @skin = (IceBlog.config(:skins))[:"#{@theme}"][0]
      end

      cookies.permanent[:theme] = @theme
      cookies.permanent[:skin] = @skin


      redirect_back_or root_path
    else
      not_found
    end
  end

  private

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

    def get_current_user
      current_user
    end

    def write_request
      flag_state = (get_current_user && get_current_user.admin?) || false
      Request.create(referer: request.referer, useragent: request.user_agent,
                     request: request.url+request.query_string,
                     new_visitor: new_visitor?, is_bot: request.bot?,
                     counter_flag: flag_state)
    end

    def markup(string)
      if string.is_a?(String)
        new_string = ""
        regexp = /
          \A
          MEDIA:(?<filetype>img|img_full|video|yt|audio):
          (?<id>[a-zA-Z0-9|]+):"(?<caption>.*)":?(?<width>[0-9px%]*)
          /x
        string.each_line do |str|
          m = regexp.match(str)
          if m
            # file tag found
            # replace with corresponding html :)
            # m[0] whole tag
            @caption = m[:caption]
            new_html = ""
            case m[:filetype]
            when 'img'
              if m[:id].count('|') == @caption.count('|')
                @images = ImageFile.find(m[:id].split('|'))
                unless m[:width].empty?
                  @max_width = m[:width]
                else
                  @max_width = '100%'
                end
                html = render_to_string "main/_image", layout: false
              else
                html = "failed to render media"
              end
            when 'img_full'
              @image = ImageFile.find(m[:id])
              html = render_to_string "main/_image_full", layout: false
            when 'video'
              @video = VideoFile.find(m[:id])
              html = render_to_string "main/_video", layout: false
            when 'audio'
              @audio = AudioFile.find(m[:id])
              html = render_to_string "main/_audio", layout: false
            when 'yt'
              @yt_id = m[:id]
              html = render_to_string "main/_youtube", layout: false
            else
              html = "failed to render media"
            end
            html.each_line do |substr|
              if substr.lstrip
                new_html << substr.lstrip
              else
                new_html << substr
              end
            end
            str.sub! m[0], new_html.chomp!
          end
          new_string << str
        end

        markdown = Redcarpet::Markdown.new(RougeHTML,
                                           autolink: true)
        return markdown.render(new_string)
      else
        return nil
      end
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = msg(:danger_login_required)
        redirect_to login_url
      end
    end

    def guest
      if logged_in?
        flash[:info] = msg(:info_logout_required)
        redirect_to root_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      not_found unless current_user?(@user) || current_user.is_admin?
    end

    def admin_user
      not_found unless (current_user && current_user.admin?)
    end

    def set_globals
      @theme = nil
      @current_user = nil
      @meta = Hash.new
    end

    def set_theme
      if Rails.env == "production"
        if cookies[:theme]
          @theme = cookies[:theme]
        else
          if @data[:default_theme].empty?
            @theme = (IceBlog.config(:themes))[0]
          else
            @theme = @data[:default_theme]
          end
          cookies.permanent[:theme] = @theme
        end
      else
        if cookies[:theme]
          @theme = cookies[:theme]
        else
          if @data[:default_theme].nil?
            @theme = (IceBlog.config(:themes))[0]
          else
            @theme = @data[:default_theme]
          end
          cookies.permanent[:theme] = @theme
        end
      end
    end

    def set_skin
      if Rails.env == "production"
        if cookies[:skin]
          @skin = cookies[:skin]
        else
          if @data[:default_skin].empty?
            @skin = (IceBlog.config(:skins))[:"#{@theme}"][0]
          else
            @skin = @data[:default_skin]
          end
          cookies.permanent[:skin] = @skin
        end
      else
        if cookies[:skin]
          @skin = cookies[:skin]
        else
          if @data[:default_skin].nil?
            @skin = (IceBlog.config(:skins))[:"#{@theme}"][0]
          else
            @skin = @data[:default_skin]
          end
          cookies.permanent[:skin] = @skin
        end
      end
    end
      
end
