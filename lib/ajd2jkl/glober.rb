require 'pathname'
require 'commander/user_interaction'

module Ajd2jkl
    # class Glober
    class Glober
        attr_reader :entries, :defines

        @verbose = false
        @dry_run = false

        def initialize(options)
            @dry_run = true if options.dry_run
            @verbose = true if options.verbose
            @defines = []
            @entries = []
            @inspected = 0
            @current_file = nil
        end

        def inspected(phpfile)
            @current_file = phpfile
            Ajd2jkl.verbose_say("Inspect #{@current_file}...") if @verbose
            @inspected += 1
        end

        def gob(data)
            return unless data
            @entries += data[:entry] if data.key? :entry
            @defines += data[:define] if data.key? :define
            @current_file = nil
        end

        def info
            say("\nInspected files: #{@inspected}")

            say("\tDefines: #{@defines.count}")
            @defines.each { |klass| Ajd2jkl.verbose_say("\t\t#{klass.name}") } if @verbose

            print "\tAPI Entries: #{@entries.count}\n"
            @entries.each { |klass| Ajd2jkl.verbose_say("\t\t#{klass.name}") } if @verbose

            print "\nHappy?\n"
        end
    end
end
