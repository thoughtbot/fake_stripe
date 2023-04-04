require 'capybara_discoball'
require 'capybara/cuprite'

FakeSiteRunner =
  Capybara::Discoball::Runner.new(FakeSite::App) do |server|
    FakeSite::App.url = server.url
  end

Capybara.register_driver :apparition do |app|
  Capybara::Cuprite::Driver.new(
    app,
    headless: false,
    js_errors: false,
    browser_options: {"no-sandbox": nil},
    slowmo: ENV.fetch("SLOWMO", 0),
    inspector: true
  )
end

