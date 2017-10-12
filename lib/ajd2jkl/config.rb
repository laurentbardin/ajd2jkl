require 'psych'
require 'json'

module Ajd2jkl
    # class Config
    class Config
        def initialize(file = nil)
            @file = file
        end

        def extract
            return {} unless @file
            @file = File.expand_path @file
            case File.extname @file
            when '.json' then JSON.parse File.read(@file)
            when '.yml' then Psych.load_file(@file).to_hash
            else
                {}
            end
        end
    end
end
