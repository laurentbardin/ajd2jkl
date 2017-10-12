module Ajd2jkl
    module ContentParser
        # parser for Define annotation
        class Define < AbstractParser
            protected

            def parse_first_line(line)
                # first line it's the @apiDefine name [title]
                return unless /^\s*\*\s*@apiDefine #{name}\s*(<?title>\w[\w ]*)$/ =~ line
                @title = title
                Ajd2jkl.verbose_say "Define has title #{@title}"
            end
        end
    end
end
