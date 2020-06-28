def add_gems
  gem "devise"
  gem "active_link_to"
  gem "pagy"
  gem "pundit"
  gem "draper"
  gem "skylight"
  gem "simple_form"
  gem "sidekiq"
  gem "redis", ">= 4.0", require: ["redis", "redis/connection/hiredis"]
  gem "hiredis"
  gem "omniauth-google-oauth2"
  gem "aws-sdk-s3"
  gem "view_component"
  gem "anycable-rails", "~> 1.0.0.rc2"
  gem "stimulus_reflex", "~> 3.2"

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
    gem "capybara"
    gem "selenium-webdriver"
    gem "webdrivers"
    gem "webmock"
    gem "rack_session_access"
    gem "database_cleaner-active_record"
  end

  gem_group :development do
    gem "better_errors"
    gem "binding_of_caller"
    gem "rails-erd"
    gem "guard"
    gem "guard-livereload"
    gem "rack-livereload"
    gem "skunk"
    gem "solargraph"
  end
end

def source_paths
  [__dir__]
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 5000 }",
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
  run <<~YARN
    yarn add tailwindcss \
      tailwindcss-stimulus-components \
      @tailwindcss/custom-forms \
      @fullhuman/postcss-purgecss \
      @fortawesome/fontawesome-free \
      @fortawesome/fontawesome-svg-core \
      @fortawesome/free-brands-svg-icons \
      @fortawesome/free-regular-svg-icons \
      @fortawesome/free-solid-svg-icons \
      noty \
      stimulus_reflex
  YARN

  run "yarn add prettier webpack-bundle-analyzer -D"
end

def add_tailwind
  run "mkdir -p app/javascript/stylesheets"
  append_to_file("app/javascript/packs/application.js", 'import "stylesheets/application"')
  inject_into_file("./postcss.config.js",
    "var tailwindcss = require('tailwindcss');\n", before: "module.exports")
  inject_into_file("./postcss.config.js", "\n    tailwindcss('./app/javascript/stylesheets/tailwind.config.js'),", after: "plugins: [")
  copy_file "postcss.config.js", force: true
end

def copy_templates
  directory "app", force: true
  directory "config", force: true
end

def add_live_reload
  run "bundle exec guard init"
  run "bundle exec guard init livereload"

  append_to_file "config/environments/development.rb", after: "Rails.application.configure do" do
    <<-HEREDOC
      config.session_store :cache_store
      config.action_cable.url = "ws://localhost:3334/cable"
      config.middleware.insert_before ActionDispatch::DebugExceptions, Rack::LiveReload
    HEREDOC
  end
end

def add_view_component
  append_to_file "config/application.rb", after: '# require "rails/test_unit/railtie"' do
    <<-HEREDOC
      \nrequire "view_component/engine"
    HEREDOC
  end
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

def add_stimulus_reflex
  generate "stimulus_reflex:install"
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
  install_js_deps
  copy_templates
  add_tailwind
  add_live_reload
  add_view_component
  add_simple_form
  add_draper
  add_rspec
  add_routes

  copy_file "Procfile.dev"
  copy_file ".env"

  run_standardrb
end
