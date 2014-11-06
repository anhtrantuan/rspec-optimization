require 'benchmark'

Benchmark.bm(20) do |b|
 b.report('Set Rails environment') { ENV['RAILS_ENV'] ||= 'test' }
 b.report('Load spec helper')      { require 'spec_helper' }
 b.report('Load environment')      { require File.expand_path('config/environment') }
 b.report('Load RSpec for Rails')  { require 'rspec/rails' }
 b.report('Maintain test schema')  { ActiveRecord::Migration.maintain_test_schema! }
  b.report('Configure RSpec') do
    RSpec.configure do |config|
      config.use_transactional_fixtures = false

      config.infer_spec_type_from_file_location!

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
