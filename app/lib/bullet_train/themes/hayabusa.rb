module BulletTrain
  module Themes
    module Hayabusa
      class Theme < BulletTrain::Themes::Light::Theme
        def directory_order
          ["hayabusa"] + super
        end
      end
    end
  end
end
