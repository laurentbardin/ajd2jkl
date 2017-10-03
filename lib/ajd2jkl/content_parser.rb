require 'pathname'

module Ajd2jkl
    module ContentParser
        class Parser
            def initialize(options)
                @verbose = options.verbose
                @defines = {}
                @entries = {}
            end

            def parse_defines(defines)
                say('Parses defines...')
                parse_define = lambda { |d|
                    begin
                        defined = Define.parse d, @verbose
                        if @defines.key? defined.name
                            raise "2 definitions have the same identifier: `#{defined.name}`. First is located" \
                                  " #{@defines[defined.name].from_file}##{@defines[defined.name].from_line}" \
                                  " and the second #{defined.from_file}##{defined.from_line}"
                        end
                        @defines[defined.name] = defined
                    rescue => e
                        Ajd2jkl.say_error e.message
                        print e.backtrace.join("\n")
                        exit 1
                    end
                }
                parse_entities defines, parse_define
                check_uses 'Check Defines uses and cyclical dependencies...', @defines
            end

            def parse_entries(entries)
                say('Parses api entries...')
                parse_entry = lambda { |d|
                    begin
                        entry = Entry.parse d, @verbose
                        @entries[entry.name] = entry
                    rescue => e
                        Ajd2jkl.say_error e.message
                        print e.backtrace.join("\n")
                        exit 1
                    end
                }
                parse_entities entries, parse_entry
                check_uses 'Check Entries uses...', @entries
            end

            protected

            def parse_entities(arr, cb)
                if @verbose
                    arr.each_with_index { |ent, idx| cb.call ent }
                else
                    Commander::UI.progress arr do |ent|
                        cb.call ent
                    end
                end
            end

            def check_uses(verbsay, entities)
                if @verbose
                    Ajd2jkl.verbose_say(verbsay + ' ')
                    entities.each_value { |value| check_use value }
                    Ajd2jkl.verbose_say('OK!')
                else
                    Ajd2jkl.say(verbsay)
                    Commander::UI.progress entities do |_key, value|
                        check_use value
                    end
                end
            end

            def check_use(entity, called_by = [])
                return unless entity.uses?
                entity.uses.each do |u|
                    Ajd2jkl.say_error("\nA use is called for an undefined entry #{u.name_of_defined} in #{value.from_file}##{value.from_line}") && exit(1) unless @defines.key? u.name_of_defined
                    Ajd2jkl.say_error("\nCyclical dependencies detected: #{called_by.join(' -> ')} -> #{entity.name} -> #{u.name_of_defined}") && exit(1) if called_by.include? u.name_of_defined
                    check_use @defines[u.name_of_defined], called_by + [entity.name]
                end
            end
        end
    end
end
require 'ajd2jkl/content_parser/abstract_parser'
require 'ajd2jkl/content_parser/define'
require 'ajd2jkl/content_parser/entry'
