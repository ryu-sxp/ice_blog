# README
IceBlog
==
Yet another blog engine built on top of Rails.

Features
--
* file uploads
* microposts, blog posts and project pages (that can be used like a simple cms)
* sticky messages
* blog posts, projects and sticky messages are written in [markdown][1] with an extended syntax for including media files
* comments
* mail reminders for unpublished content
* lets you post to a [mastodon][2] instance
* largely built with themability in mind

Setup
--
This app has been tested against ruby 2.3.5.

It requires mysql/mariadb and imagemagick on the server.

The process expects the following environment variables:

* DATABASE_NAME
* DATABASE_USER
* DATABASE_HOST
* DATABASE_PSWD
* DATABASE_HOST
* SECRET_KEY_BASE
* TRIP_SALT
* MSTDN_URL
* MSTDN_USERNAME
* MSTDN_ACCESS_TOKEN

Mail settings are configured in `config/environments/production.rb`. Refer to the [Action Mailer guide][3] for details. Also set the from address in `app/mailers/application_mailer.rb`

Various variables can be set in `config/initializers/app_config.rb`.

Once everything is setup, run

    rails db:create
    rails db:migrate
    rails assets:precomile
    rails console

        User.Create(name: '', email: '', password: '', admin: true, activated: true)

    bundle exec whenever --update-crontab

with the needed environment variables set. The console command is required to set an admin user.

Usage
--

Visit root/login to login as the created user.

Settings (or admin user data)
* Name
* Email
* Forum URL: an optional value. Supported by default theme, if set another menu button shows up with a link to the specified url
* Theme: name of the default theme
* Skin: name of the default skin. If these aren't set the defaults are the first theme and skin in the config arrays
* Blog post toot visibility: public, private, unlisted, direct
* Avatar
* Site Icon: an item to be shown next to the site name
* Site Banner: a banner to be displayed between title and menu
* "Post to mastodo?": whether posting microposts and publishing blog posts create statuses on mastodon
* "Allow comments?": whether people can post comments
* "Use blogspam.net checking?": use the blogspam API y/n
* About: short bio, shows up in the user profile
* Bio draft: long bio, only shows up in the dedicated profile page. uses markdown
* Site name: The name that's displayed in the top left
* Site slogan: string that's displayed right next to the title
* Meta keywords: keywords for the HTML meta tag
* Meta desc: description for the HTML meta tag

markdown is also supported by all projects, blog posts and sticky messages. To insert a piece of media put the following syntax between paragraphs:

`MEDIA:img_full:{id}:"{caption}"`
`MEDIA:img:{id}:"{caption}":{max_width}`
`MEDIA:video:{id}:"{caption}"`
`MEDIA:audio:{id}:"{caption}"`
`MEDIA:yt:{id}:"{caption}"`

The ids refer to the ids of various files you can upload. Caption is the text to appear below a media item. The last example is for embedding youtube videos - in which case the id refers to the id part of the video's url. Some examples:

`MEDIA:video:45:""`
`MEDIA:img_full:2:"Nice picture."`
`MEDIA:img:2|14|5:"pic1|pic2|pic3":400px`
`MEDIA:img:5|22|2:"||":60%`

img is the only type to support multiple items. The number of pipes in the id section and the caption section needs to be the same. max-width is optional and defaults to `100%`.

License
--
IceBlog is released under the [MIT license][4].


[1]: https://daringfireball.net/projects/markdown/ "markdown"
[2]: https://mastodon.social "mastodon"
[3]: http://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration "Action Mailer guide"
[4]: https://opensource.org/licenses/MIT "MIT license"
