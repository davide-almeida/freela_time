RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
    
    # FactoryBot Lint
    config.before(:suite) do
        FactoryBot.lint
    end
end