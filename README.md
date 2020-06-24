## Starter Template

Generate new rails projects with the following preconfigured

- devise
- tailwindcss
- guard livereload
- rspec or minitest
- service worker

#### How to run

- install [overmind](https://github.com/DarthSim/overmind)
- clone
- `DISABLE_SPRING=t rails new <app_name> -m starter/template.rb`
- `cd <app_name>`
- `rails db:create db:migrate`
- `overmind start`
