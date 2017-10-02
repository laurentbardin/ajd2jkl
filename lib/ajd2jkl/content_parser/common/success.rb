module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiSuccess parser
            # multiline: true
            # @apiSuccess [(group)] [{type}] [field=defaultValue] [description]
            class Success < AbstractCommonMultiline
                attr_reader :group, :type, :field, :description

                # test regexp http://rubular.com/r/X4ArTZYSgI
                @@parser = %r{
                    ^\s*
                    (\((?<group>\w[-\w\s_]*)\)\s)?\s*
                    (
                        \{(?<type>(
                                [a-zA-Z]\w*
                                (\[\])?
                                (=["'\w-_]*)?
                                |
                                \[[A-Za-z][-_\s\w]+\]\([^\s\)]*\)
                        ))\}\s
                    )?\s*
                    (?<field>
                        \[?
                            [-\w_\.]+
                        \]?
                    )
                    \s*
                    (?<description>\S.*)?
                    $
                }x

                def analyze
                    Ajd2jkl.verbose_say('Analyze Common/Success... ')
                    match = @@parser.match(@raw)
                    raise "Parsing apiSuccess don't have `field` part (RE: #{@@parser}) raw => #{@raw}" unless match && match[:field]
                    @group = 'Success 200'
                    @group = match[:group] unless match[:group].nil? || match[:group].strip == ''
                    @type = match[:type] unless match[:type].nil? || match[:type].strip == ''
                    @field = match[:field]
                    @description = match[:description] unless match[:description].nil?
                    @raw = nil
                end

                def end_multiline
                    Ajd2jkl.verbose_say(" Found Success `#{@field}`#{@type ? ' of type '+@type : ''} in group `#{@group}`")
                end
            end
        end
    end
end
