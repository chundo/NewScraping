require 'capybara'


require 'csv'
  require 'capybara'
  require 'capybara/poltergeist'
  
 
    
    f = Capybara.default_driver = :poltergeist
    Capybara.register_driver :poltergeist do |app|
      options = { js_errors: false }
     Capybara::Poltergeist::Driver.new(app, options)
  end
 
   
 


  
       puts f.visit 'http://google.com/search?q=foo'
     
       

