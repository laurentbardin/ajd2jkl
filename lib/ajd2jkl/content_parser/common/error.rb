module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiError parser
            # multiline: true
            # @apiError [(group)] [{type}] field [description]
            class Error < AbstractCommonMultiline
                attr_reader :group, :type, :field, :description

                # test regexp http://rubular.com/r/UwvIDkAa8b
                @@parser = %r{
                    ^
                        (\((?<group>\w[\w\s]*)\)\s+)?
                        ({(?<type>(
                            [a-zA-Z]\w*|
                            |
                            \[[A-Za-z][-_\s\w]+\]\([^\s\)]*\)
                        ))}\s+)?
                        (?<field>[\w]*)\s*
                        (?<description>\S.*)?
                    $
                }x

                def analyze
                    Ajd2jkl.verbose_say('Analyze Common/Error... ')
                    match = @@parser.match(@raw)
                    raise "Parsing apiError don't have `field` part (RE: #{@@parser}) raw => #{@raw}" unless match && match[:field]
                    @group = match[:group] unless match[:group].nil? || match[:group].strip == ''
                    @type = match[:type] unless match[:type].nil? || match[:type].strip == ''
                    @field = match[:field]
                    @description = match[:description] unless match[:description].nil?
                    @raw = nil
                end

                def end_multiline
                    Ajd2jkl.verbose_say(" Found Error #{@field}#{@type ? ' of type '+@type : ''}#{@group ? " in group `#{@group}`" : ''}")
                end
            end
        end
    end
end
