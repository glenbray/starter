def add_gems
  gem "devise"
  gem "active_link_to"
  gem "pagy"
  gem "pundit"
  gem "draper"
  gem "simple_form"
  gem "sidekiq"
  gem "omniauth-google-oauth2"
  gem "aws-sdk-s3"
  gem "view_component"

  gem "sidekiq-cron"
  gem "sentry-rails"
  gem "sentry-sidekiq"

  gem_group :development, :test do
    gem "rspec-rails"
    gem "pry-rails"
    gem "pry-byebug"
    gem "factory_bot_rails"
    gem "standard"
    gem "dotenv-rails"
    gem "faker"
    gem "simplecov", require: false
  end

  gem_group :test do
    gem "webmock"
    gem "rack_session_access"
    gem "database_cleaner-active_record"
  end

  gem_group :development do
    gem "better_errors"
    gem "binding_of_caller"
    gem "rails-erd"
    gem "guard"
    gem "hotwire-livereload"
    gem "skunk"
    gem "solargraph"
    gem "letter_opener"
  end
end

def source_paths
  [__dir__]
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
    env: "development"

  # Create Devise User
  generate :devise, "User", "username", "name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by { |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end

  gsub_file "config/routes.rb", "devise_for :users", ""

  route 'devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}'

  omniauth = <<~OMNIAUTH

    config.omniauth :google_oauth2,
      ENV["GOOGLE_CLIENT_ID"],
      ENV["GOOGLE_CLIENT_SECRET"],
      access_type: "online"
  OMNIAUTH

  inject_into_file(
    "config/initializers/devise.rb",
    omniauth,
    after: "# config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'"
  )
end

def install_js_deps
  # run <<~YARN
  #   yarn add tailwindcss-stimulus-components \
  #     noty \
  #     @fullhuman/postcss-purgecss \
  #     @tailwindcss/forms \
  #     @tailwindcss/typography \
  #     @tailwindcss/aspect-ratio
  # YARN
end

def add_tailwind
  run "tailwindcss:install"
  # run "mkdir -p app/javascript/stylesheets"
  # # append_to_file("app/javascript/packs/application.js", 'import "stylesheets/application"')
  # inject_into_file("./postcss.config.js",
  #   "var tailwindcss = require('tailwindcss');\n", before: "module.exports")
  # inject_into_file("./postcss.config.js", "\n    tailwindcss('./app/javascript/stylesheets/tailwind.config.js'),", after: "plugins: [")
  # copy_file "postcss.config.js", force: true
end

def add_fortawesome
  run "./bin/importmap pin @fortawesome/fontawesome-free @fortawesome/fontawesome-svg-core @fortawesome/free-brands-svg-icons @fortawesome/free-regular-svg-icons @fortawesome/free-solid-svg-icons"

  code = <<~JS
    import {far} from "@fortawesome/free-regular-svg-icons"
    import {fas} from "@fortawesome/free-solid-svg-icons"
    import {fab} from "@fortawesome/free-brands-svg-icons"
    import {library} from "@fortawesome/fontawesome-svg-core"
    import "@fortawesome/fontawesome-free"
    library.add(far, fas, fab)
  JS

  append_to_file("app/javascript/application.js", code)
end

def copy_templates
  directory "app", force: true
  directory "config", force: true
end

def add_live_reload
  rails_command "livereload:install"
end

def add_rspec
  generate "rspec:install"
  copy_file "spec/rails_helper.rb", force: true
end

def add_draper
  generate "draper:install"
end

def add_routes
  route 'get "/service-worker.js" => "service_worker#service_worker"'
  route 'get "/manifest.json" => "service_worker#manifest"'
end

def add_simple_form
  generate "simple_form:install"
end

def run_standardrb
  run "bundle exec standardrb --fix"
end

source_paths

add_gems

after_bundle do
  run_standardrb

  git :init
  git add: "."
  git commit: %( -m 'Initial commit' )

  add_users
  # install_js_deps
  copy_templates
  add_live_reload
  add_simple_form
  add_draper
  add_rspec
  add_routes

  copy_file "Procfile.dev", force: true
  copy_file ".solargraph.yml", force: true
  copy_file ".rubocop.yml", force: true
  template ".env.erb", ".env"

  copy_file "config/database.yml", force: true

  rails_command "db:drop db:create db:migrate" if yes?("Run database migrations? (y/n)")

  git add: "."

  git commit: %( -m 'Apply template' )
end
