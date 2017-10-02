require 'pathname'

module Ajd2jkl
    module ContentParser
        class Parser
            def initialize(options)
                @verbose = options.verbose
                @defines = {}
            end

            def parse_defines(defines)
                say('Parses defines...')
                parse_define = lambda { |d|
                    begin
                        defined = Define.parse d, @verbose
                        @defines[defined.name] = defined
                    rescue => e
                        Ajd2jkl.say_error e.message
                        print e.backtrace.join("\n")
                        exit 1
                    end
                }

                if @verbose
                    defines.each_with_index { |definition, idx| parse_define.call definition }
                else
                    Commander::UI.progress defines do |definition|
                        parse_define.call definition
                    end
                end
            end

            def parse_entries(entries)
                say('Parses api entries...')
                parse_entry = lambda { |d|
                    begin
                        entry = Entry.parse d, @verbose
                        @defines[entry.name] = entry
                    rescue => e
                        Ajd2jkl.say_error e.message
                        print e.backtrace.join("\n")
                        exit 1
                    end
                }

                if @verbose
                    entries.each_with_index { |ent, idx| parse_entry.call ent }
                else
                    Commander::UI.progress entries do |ent|
                        parse_entry.call ent
                    end
                end
            end
        end
    end
end
require 'ajd2jkl/content_parser/abstract_parser'
require 'ajd2jkl/content_parser/define'
require 'ajd2jkl/content_parser/entry'
