require 'ajd2jkl/version'
require 'ajd2jkl/glober'
require 'ajd2jkl/file_parser'
require 'ajd2jkl/content_parser'

# main module
module Ajd2jkl
    @verbose = false
    def self.verbose=(v)
        @verbose = v
    end

    class Base
        def initialize(options)
            Ajd2jkl.verbose = options.verbose
            @options = options
        end

        def launch(src_dir)
            say("Parse directories : #{src_dir.join(' ')}")
            phpfiles = File.join("{#{src_dir.join(',')}}", '**', 'routes.php')

            gob = Glober.new(@options)
            Dir.glob(phpfiles).each do |phpfile|
                gob.inspected phpfile
                gob.gob ::Ajd2jkl::FileParser.scan phpfile
            end

            gob.info

            cp = ::Ajd2jkl::ContentParser::Parser.new(@options)
            cp.parse_defines gob.defines
            cp.parse_entries gob.entries
        end
    end

    def self.erase_line
        Commander::UI.erase_line
    end

    def self.verbose_say(str)
        Commander::UI.color(str, :yellow) if @verbose
    end

    def self.say_error(str)
        Commander::UI.say_error(str)
    end
end

module Commander
    # Extends Commender UI Module
    module UI
        def self.erase_line
            $terminal.instance_variable_get('@output').print "\r\e[K"
        end

        # Extends Commender UI ProgressBar class
        class ProgressBar
            # override show method to don't erase progress bar when finished
            def show
                return if finished?
                erase_line
                if completed?
                    say UI.replace_tokens(@format, generate_tokens) << ' '
                    say @complete_message if @complete_message.is_a? String
                else
                    say UI.replace_tokens(@format, generate_tokens) << ' '
                end
            end
        end
    end
end
