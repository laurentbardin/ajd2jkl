module Ajd2jkl
    module ContentFinder
        # Content of type global define @apiDefine
        class Define < AbstractContentFinder
            def self.parser
                /^\s*\*\s+@apiDefine\s*(?<api_def_name>[\w]*)/
            end

            def check_file_name(_ncontent, match = nil)
                return if @name
                @name = match[:api_def_name] unless match.nil?
            end
        end
    end
end
