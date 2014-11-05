require 'active_record'
require 'database_cleaner'
require 'factory_girl'
require 'faker'
require 'pg_search'
require 'shoulda/matchers'
Dir[File.expand_path('app/models/*.rb')].each{ |f| require f }
FactoryGirl.find_definitions

ActiveRecord::Base.establish_connection(adapter: :postgresql, database: :rspec_optimization_test)
ActiveRecord::Migrator.up('db/migrate')

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
