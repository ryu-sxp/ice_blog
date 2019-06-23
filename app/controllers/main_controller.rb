class MainController < ApplicationController
  layout :theme_layout
  before_action :get_admin_data
  before_action :set_theme
  before_action :set_skin
  before_action :get_current_user
  before_action :get_top_menu_data
  before_action :get_stickies
  before_action :store_location, only: [:timeline, :media, :micropost,
                                        :category, :profile, :blog,
                                        :article, :project, :projects,
                                        :legal]

  # GET / or /tml/p/1
  def timeline
    # the index page that displays a timeline of all posts and microposts
    @comment = Comment.new
    @meta[:title] = @data[:site_name]
    @meta[:keywords] = @data[:meta_keywords]

    if @current_user && @current_user.admin?
      @feed = Feed.paginate(page: params[:page]).order('published_date DESC')
    else
      @feed = Feed.where(published: true).paginate(page: params[:page]).
        order('published_date DESC')
    end
    render "main/#{@theme}/timeline"
  end

  #def error
  #  status_code = params[:code]
  #  render "main/#{@theme}/error", layout: "#{@theme}_minimal"
  #end

  # GET /media
  def media
    @meta[:title] = "media - " + @data[:site_name]
    @meta[:keywords] = @data[:meta_keywords]
    @meta[:desc] = @data[:meta_desc]
    @media = Micropost.
      where("image IS NOT NULL OR video IS NOT NULL").
      where(relevant_media: true).paginate(page: params[:page])
    render "main/#{@theme}/media"
  end

  # GET /mcrpst/1
  def micropost
    # the index page that displays a timeline of all posts and microposts
    @comment = Comment.new
    @meta[:title] = "show micropost - " + @data[:site_name]
    @meta[:keywords] = @data[:meta_keywords]
    @meta[:desc] = @data[:meta_desc]
    if params[:source] == 'micropost'
      @micropost = Micropost.find(params[:id])
    elsif params[:source] == 'blogpost'
      @micropost = BlogPost.find(params[:id])
    else
      @micropost = nil
    end
    render "main/#{@theme}/micropost", layout: "#{@theme}_minimal"
  end

  # GET /ctg/1/t/xyz/p/1 (category)
  def category
    # page that displays all blog posts of a certain category 
    # with tag param limit to posts of cat with tag
    @comment = Comment.new
    @meta[:keywords] = @data[:meta_keywords]
    @meta[:desc] = @data[:meta_desc]
    @category = BlogCategory.find(params[:id]).name
    @meta[:title] = "Blog category: #{@category} - " + @data[:site_name]
    @tag = nil
    if params.key?('tag') 
      @tag = params[:tag]
      if @current_user && @current_user.admin?
        @tags = Tag.joins(:blog_post).
          where(blog_posts: {blog_category_id: params[:id]})
        @microposts = Tag.joins(:blog_post).
          where(name: params[:tag],
                blog_posts: {blog_category_id: params[:id]}).
          paginate(page: params[:page]).order('published_date DESC')
      else
        @tags = Tag.joins(:blog_post).
          where(blog_posts: {blog_category_id: params[:id], published: true})
        @microposts = Tag.joins(:blog_post).
          where(name: params[:tag],
                blog_posts: {published: true, blog_category_id: params[:id]}).
          paginate(page: params[:page]).order('published_date DESC')
      end
    else
      # get the bare category
      if @current_user && @current_user.admin?
        @tags = Tag.joins(:blog_post).
          where(blog_posts: {blog_category_id: params[:id]})
        @microposts = BlogPost.where(blog_category_id: params[:id]).
          paginate(page: params[:page]).order('published_date DESC')


      else
        @tags = Tag.joins(:blog_post).
          where(blog_posts: {blog_category_id: params[:id], published: true})
        @microposts = BlogPost.where(published: true,
                                     blog_category_id: params[:id]).paginate(
                                       :page => params[:page]).
          order('published_date DESC')
      end
    end
    render "main/#{@theme}/blog_category"
  end

  # GET /prf/1 (profile)
  def profile
    @profile_of = User.find(params[:id])
    @meta[:title] = "#{@profile_of.name}'s profie - " + @data[:site_name]
    @meta[:keywords] = @data[:meta_keywords]
    @meta[:desc] = @data[:meta_desc]
    render "main/#{@theme}/profile", layout: "#{@theme}_minimal"
  end
  
  # GET /blg (blog_view)
  def blog
    # page that lists all blog categories
    # and all blog posts
    @comment = Comment.new
    @meta[:title] = "Blog - " + @data[:site_name]
    @meta[:keywords] = @data[:meta_keywords]
    @meta[:desc] = @data[:meta_desc]
    if @current_user && @current_user.admin?
      @categories = BlogCategory.all.order('name ASC')
      @microposts = BlogPost.paginate(page: params[:page]).order('published_date DESC')
    else
      @categories = BlogCategory.all.order('name ASC').reject do |r|
        BlogPost.where(blog_category_id: r.id, published: true).count == 0
      end
      @microposts = BlogPost.where(:published => true).paginate(:page => params[:page]).
        order('published_date DESC')
    end
    render "main/#{@theme}/blog"
  end
  
  # GET /blg/1 (article)
  def article
    # page that displays a blog post
    @comment = Comment.new
    @post = BlogPost.find(params[:id])
    @meta[:title] = "Blog: #{@post.title} - " + @data[:site_name]
    @meta[:keywords] = @data[:meta_keywords]
    @meta[:desc] = @data[:meta_desc]
    unless @post.published?
      redirect_to root unless (@current_user && @current_user.admin?)
    end
    render "main/#{@theme}/blog_post", layout: "#{@theme}_minimal"
  end

  # GET /prj/1 (page)
  def project
    # page that displays a project
    @project = Project.find(params[:id])
    @meta[:title] = "Project: #{@project.name} - " + @data[:site_name]
    @meta[:keywords] = @data[:meta_keywords]
    @meta[:desc] = @data[:meta_desc]
    unless @project.published?
      redirect_to root unless (@current_user && @current_user.admin?)
    end
    render "main/#{@theme}/project", layout: "#{@theme}_minimal"
  end
  
  # GET /prjs (pages)
  def projects
    # page that displays all projects
    @meta[:title] = "Projects - " + @data[:site_name]
    @meta[:keywords] = @data[:meta_keywords]
    @meta[:desc] = @data[:meta_desc]
    @projects = Array.new
    if @current_user && @current_user.admin?
      @sections = ProjectHeader.all.order('name ASC')
      @sections.each do |sec|
        @projects[sec.id] = Project.where(project_header_id: sec.id).
          order('name ASC')
      end
    else
      @sections = ProjectHeader.all.order('name ASC').reject do |r|
        Project.where(project_header_id: r.id, published: true).count == 0
      end
    end
    render "main/#{@theme}/projects"
  end

  def disclaimer
    respond_to do |format|
      format.js {
        render "main/#{@theme}/disclaimer", layout: 'ajax'
      }
    end
  end

  def legal
    @meta[:title] = "Legal - " + @data[:site_name]
    @meta[:keywords] = @data[:meta_keywords]
    @meta[:desc] = @data[:meta_desc]
    render "main/#{@theme}/legal", layout: "#{@theme}_minimal"
  end

  def modal_text
    @text = params[:string]
    respond_to do |format|
      format.js {
        render "main/#{@theme}/modal_text", layout: 'ajax'
      }
    end
  end

  # GET /blogfeed 
  def feed
    @posts = BlogPost.where(published: true).
      order('published_date DESC').limit(20)

    respond_to do |format|
      format.rss { render "main/feed", layout: false }
    end
  end

  private

    def theme_layout
      @theme
    end

    def get_admin_data
      unless admin = User.first
        raise "No user found. Check the readme for further instructions."
      end
      raise "First user has to be flagged as admin." if !admin.admin?
      @comment_flag = admin.comment_flag
      @data = Hash.new
      @data[:admin_name] = admin.name
      @data[:admin_email] = admin.email
      @data[:default_theme] = admin.theme
      @data[:default_skin] = admin.skin
      @data[:admin_icon_url] = admin.avatar_url
      @data[:about] = admin.about
      @data[:forum_url] = admin.forum_url
      @data[:sml] = admin.social_media_links
      @data[:site_name] = admin.site_name
      @data[:site_slogan] = admin.site_slogan
      @data[:site_icon_url] = admin.site_icon_url
      @data[:site_banner_url] = admin.site_banner_url
      @data[:meta_keywords] = admin.meta_keywords
      @data[:meta_desc] = admin.meta_desc
      if stat = Statistic.first
        @data[:requests_c] = stat.requests_c
        @data[:visits_c] = stat.visits_c
      else
        @data[:requests_c] = 2;
        @data[:visits_c] = 2;
      end
    end

    def get_top_menu_data
      @nav_projects = Array.new
      project_headers = ProjectHeader.all.order('name ASC')
      if project_headers
        project_headers.each do |header|
          if @current_user && @current_user.admin?
            projects = Project.where(project_header_id: header.id).order(
              'name ASC')
          else
            projects = Project.where(published: true,
                                     project_header_id: header.id).order(
                                       'name ASC')
          end
          if projects
            @nav_projects.push({name: header.name, collection: projects})
          end
        end
      else
        @nav_projects = nil
      end

      @nav_cats = BlogCategory.all.order('name ASC')
    end

    def get_stickies
      if @current_user && @current_user.admin?
        @stickies = StickyMessage.all.order('created_at DESC')
      else
        @stickies = StickyMessage.where(published: true).
          order('created_at DESC')
      end
    end

end
