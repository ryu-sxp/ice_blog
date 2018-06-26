Rails.application.routes.draw do
  resources :pending_toots
  resources :sticky_messages
  resources :other_files
  resources :video_files
  resources :audio_files
  resources :image_files
  resources :post_files
  resources :spam_comments
  get 'password_resets/new'

  get 'password_resets/edit'

  # For details on the DSL available within this file, see
  # http://guides.rubyonrails.org/routing.html
  

  # public views
  root   'main#timeline'
  get '/tml(/p/:page)', to: 'main#timeline', as: 'timeline'
  get '/mcrpst/:source/:id', to: 'main#micropost', as: 'micropost_view'
  get '/ctg/:id(/t/:tag)(/p/:page)', to: 'main#category', as: 'category'
  get '/blg(/p/:page)', to: 'main#blog', as: 'blog_view'
  get '/blg/:id', to: 'main#article', as: 'article'
  get '/prj/:id', to: 'main#project', as: 'page'
  get '/prjs', to: 'main#projects', as: 'pages'
  get '/media(/p/:page)', to: 'main#media', as: 'media'
  get '/prf/:id', to: 'main#profile', as: 'profile'
  get '/cms/:model/:id', to: 'comments#request_comments'
  get '/cms/form/:source_model/:source_id', to: 'comments#request_form',
    as: 'comment_form'
  get '/disclaimer(.:format)', to: 'main#disclaimer', as: 'disclaimer'
  get '/modal_text(.:format)', to: 'main#modal_text', as: 'modal_text'
  get '/blogfeed(.:format)', to: 'main#feed', as: 'rss_feed'
  get '/legal', to: 'main#legal', as: 'legal'
  get '/layout_switch', to: 'application#layout_switch', as: 'layout_switch'














  get    "/admin", to: 'admin_panel#index', as: 'admin'

  # account creation
  get 'sessions/new'
  get 'users/new'


  get    '/signup', to: 'users#new'
  #post   '/signup', to: 'users#create'

  get    '/login',  to: 'sessions#new', as: 'login_form'
  post   '/login',  to: 'sessions#create', as: 'login'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  get      '/users/:id/edit_password', to: 'users#edit_password'
  patch    '/users/:id/edit_password', to: 'users#update_password'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  #namespace :admin do
  #  resources :requests
  #end
  resources :requests
  resources :comments
  resources :microposts
  resources :tags
  resources :blog_posts
  resources :blog_categories, only: [:index, :show]
  resources :projects
  resources :project_headers, only: [:index, :show]
  resources :social_media_links
  resources :ip_blacklists

  # special resource actions
  patch '/blog_posts/:id/hide', to: 'blog_posts#hide', as: 'hide_blog_post'
  patch '/blog_posts/:id/overwrite',
    to: 'blog_posts#overwrite_content', as: 'overwrite_blog_post'
  patch '/blog_posts/:id/publish',
    to: 'blog_posts#publish', as: 'publish_blog_post'

  patch '/projects/:id/hide', to: 'projects#hide', as: 'hide_project'
  patch '/projects/:id/overwrite', to: 'projects#overwrite_content',
    as: 'overwrite_project'
  patch '/projects/:id/publish',
    to: 'projects#publish', as: 'publish_project'

  get '/blog_posts/upload/draft_form',
    to: 'blog_posts#draft_upload_form', as: 'upload_form_blog_post'
  post '/blog_posts/upload/draft', to: 'blog_posts#draft_upload',
    as: 'upload_blog_post'

  patch '/blog_posts/:id/push_to_mstdn', to: 'blog_posts#push_to_mstdn',
    as: 'push_blog_post_to_mstdn'

  patch '/microposts/:id/push_to_mstdn', to: 'microposts#push_to_mstdn',
    as: 'push_micropost_to_mstdn'


  # error pages
  # get '404', :to => "main#error"
  
end
