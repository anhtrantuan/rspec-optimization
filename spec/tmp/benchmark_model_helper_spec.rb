require 'benchmark'

Benchmark.bm(30) do |b|
  b.report('Load ActiveRecord')            { require 'active_record' }
  b.report('Load Database Cleaner')        { require 'database_cleaner' }
  b.report('Load FactoryGirl')             { require 'factory_girl' }
  b.report('Load Faker')                   { require 'faker' }
  b.report('Load PgSearch')                { require 'pg_search' }
  b.report('Load Shoulda Matchers')        { require 'shoulda/matchers' }
  b.report('Load Rails models')            { Dir[File.expand_path('app/models/*.rb')].each{ |f| require f } }
  b.report('Load FactoryGirl definitions') { FactoryGirl.find_definitions }
  b.report('Connect to database') do
    ActiveRecord::Base.establish_connection(adapter: :postgresql, database: :rspec_optimization_test)
  end
  b.report('Migrate database') { ActiveRecord::Migrator.up('db/migrate') }
  b.report('Configure RSpec') do
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
  end
end
