def add_gems
  gem "devise"
  gem "active_link_to"
  gem "pagy"
  gem "pundit"
  gem "draper"
  gem "skylight"
  gem "omniauth-google-oauth2"

  gem_group :development, :test do
    gem "rspec-rails" if install_rspec?
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
  end

  gem_group :development do
    gem "better_errors"
    gem "binding_of_caller"
    gem "rails-erd"
    gem "guard"
    gem "guard-livereload"
    gem "rack-livereload"
    gem "skunk"
  end
end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 5000 }",
              env: 'development'

  # Create Devise User
  generate :devise, "User", "username", "name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end

  gsub_file 'config/routes.rb', 'devise_for :users', ''

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
      @fortawesome/free-solid-svg-icons
  YARN

  run "yarn add prettier webpack-bundle-analyzer -D"
end

def add_tailwind
  run "mkdir -p app/javascript/stylesheets"
  append_to_file("app/javascript/packs/application.js", 'import "stylesheets/application"')
  inject_into_file("./postcss.config.js",
  "var tailwindcss = require('tailwindcss');\n",  before: "module.exports")
  inject_into_file("./postcss.config.js", "\n    tailwindcss('./app/javascript/stylesheets/tailwind.config.js'),", after: "plugins: [")
  copy_file "postcss.config.js", force: true
end

def copy_templates
  directory "app", force: true
end

def add_live_reload
  run "bundle exec guard init"
  run "bundle exec guard init livereload"

  append_to_file 'config/environments/development.rb', after: 'Rails.application.configure do' do
    <<-HEREDOC
      config.middleware.insert_before ActionDispatch::DebugExceptions, Rack::LiveReload
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

def run_standardrb
  run "bundle exec standardrb --fix"
end

source_paths

def install_rspec?
  @install_rpsec ||= yes?("Did you want to use rspec?")
end

add_gems

after_bundle do
  run_standardrb

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }

  add_users
  install_js_deps
  copy_templates
  add_tailwind
  add_live_reload
  add_draper
  add_rspec if install_rspec?
  add_routes

  copy_file "Procfile.dev"
  copy_file ".env"

  run_standardrb
end
