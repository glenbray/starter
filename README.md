## Starter Template

Generate new rails projects with the following preconfigured

- devise
- tailwindcss
- guard livereload
- rspec or minitest
- service worker

### How to run

##### With .railsrc config configured

```
# ~/.railsrc

--template=/path-to-project/starter/template.rb
--database=postgresql
--skip-active-storage
--skip-test
--webpacker=stimulus
```
`rails new <app_name>`

##### Without .railsrc configuration
- clone
- `DISABLE_SPRING=t rails new <app_name> -m starter/template.rb`
- `cd <app_name>`
- `rails db:create db:migrate`
- `overmind start`
