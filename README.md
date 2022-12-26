## Starter Template

Generate new rails projects with the following preconfigured

- devise
- tailwindcss
- hotwire livereload
- rspec or minitest
- service worker
- sidekiq

### How to run

##### With the following .railsrc config configured

```
# ~/.railsrc

--template=/path-to-project/starter/template.rb
--database=postgresql
--css=tailwind
--skip-test
--skip-active-storage
--skip-jbuilder
--skip-active-storage
--skip-action-text
--skip-action-mailbox
```

`rails new <app_name>`

##### Without .railsrc configuration
- clone
- `DISABLE_SPRING=t rails new <app_name> -m starter/template.rb`
- `cd <app_name>`
- `overmind start`

