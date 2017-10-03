module Ajd2jkl
    module ContentParser
        module CommonContent
            # Abstract Common api(Error|Success|Param) parser
            # multiline: true
            # @api(Error|Success|Param) [[(group)] [{type}] field [description]
            class AbstractParametrable < AbstractCommonMultiline
                attr_reader :group, :type, :field, :description

                def optional?
                    raise "Undefined field" unless @field
                    !!(/^\[\s*\]$/ =~ @field)
                end

                def end_multiline
                    Ajd2jkl.verbose_say(" Found #{self.class.name.split('::').last} `#{@field}`#{@type ? ' of type '+@type : ''}#{@group ? " in group `#{@group}`" : ''}")
                end

                protected

                def init
                    super
                    @type = @group = @field = nil
                end
            end
        end
    end
end
