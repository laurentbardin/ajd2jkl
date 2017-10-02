module Ajd2jkl
    module ContentParser
        class Entry < AbstractParser
            attr_reader :path, :method

            protected
            @@apiparser = %r{
                ^
                    \s*\*\s*@api\s
                    \{(?<method>(get|GET|put|PUT|post|POST|delete|DELETE|patch|PATCH|head|HEAD|options|OPTIONS|trace|TRACE|connect|CONNECT))\}\s+
                    (?<path>\S*)\s*
                    (?<title>\S.*)?
                $
            }x
            def parse_first_line(line)
                # first line it's the @api {method} path [title]
                match = @@apiparser.match line
                raise "Parsing api don't have `path` part (RE: #{@@parser}) raw => #{@raw}" unless match && match[:path]
                raise "Parsing api don't have `method` part (RE: #{@@parser}) raw => #{@raw}" unless match && match[:method]
                @path = match[:path]
                @method = match[:method]
                @title = match[:title]
                Ajd2jkl.verbose_say "Entry has path #{@path} with method #{@method}"
            end
        end
    end
end
