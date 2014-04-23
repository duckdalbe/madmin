class Settings
  include Squire::Base
  squire do
    source File.join(Rails.root, 'config', 'settings.yml')
    namespace Rails.env
  end
end
