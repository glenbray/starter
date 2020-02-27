## Starter Template

Generate new rails projects with the following preconfigured

- devise
- tailwindcss
- guard livereload
- rspec
- service worker

#### How to run

- install [overmind](https://github.com/DarthSim/overmind)
- rails new <app_name> -m https://raw.githubusercontent.com/glenbray/starter/master/template.rb
- `cd <app_name>`
- `rails db:create db:migrate`
- `overmind start`
