
require 'fileutils'
require 'ajd2jkl/generator/jekyll_config'
require 'ajd2jkl/generator/jekyll_layout'
require 'ajd2jkl/generator/jekyll_nav'

module Ajd2jkl
    module Generator
        # class Generator::Base
        class Base
            def initialize(options, config, content_parser)
                @options = options
                @config = config
                @content_parser = content_parser

                output_dir
            end

            def output_dir
                @output_final = File.expand_path(@options.output || './docs')
                FileUtils.mkpath @output_final unless Dir.exist? @output_final
                @output = "#{File.expand_path File.dirname @output_final}/.tmp_#{File.basename(@output_final).tr('.', '_')}"
                FileUtils.mkpath @output unless Dir.exist? @output
                Ajd2jkl.say "Generate documentation in #{@output_final}"
            end

            def gen
                jekyllize
                gen_defines
                gen_group
                images

                jekyll_build
                # clean
            end

            protected

            def jekyllize
                Ajd2jkl.verbose_say 'Launch jekyll create...'
                `bundle exec jekyll new #{@output} --force`
                Ajd2jkl.say_error 'Error during jekyll creation' && exit(1) unless $?.exitstatus.zero?
                File.open("#{@output}/_config.yml", "w") {|f| f << Jekyll.get_config(@config, @output, @output_final) }
                FileUtils.mkpath "#{@output}/_layouts/"
                FileUtils.mkpath "#{@output}/_includes/"
                FileUtils.mkpath "#{@output}/_api/"
                File.open("#{@output}/_layouts/home.html", "w") {|f| f << Jekyll.layout }
                File.open("#{@output}/_includes/nav.html", "w") {|f| f << Jekyll.navbar_include }
                extra_docs
                gemfile
            end

            def gen_defines
            end

            def gen_group
                nav_group = []
                @content_parser.groups.each_pair do |grpname, entries|
                    p "#{grpname} => #{Generator.underscore(grpname)}"
                    nav_group.push name: grpname, burl: Generator.underscore(grpname), level: 1
                    grpdir = @output + '/_posts/' + Generator.underscore(grpname)
                    FileUtils.mkpath grpdir unless Dir.exist? grpdir
                    entries.each do |ent|
                        nav_group.push name: ent.title, burl: "#{Generator.underscore(grpname)}##{ent.name}", level: 2
                    end
                end
                FileUtils.mkpath "#{@output}/_data/"
                File.open("#{@output}/_data/sidebar.yml", "w") {|f| f << Jekyll.navbar(@config, nav_group) }
            end

            def jekyll_build
                Ajd2jkl.verbose_say 'Launch jekyll build...'
                IO.pipe do |read_pipe, write_pipe|
                    fork do
                        `cd #{@output} && bundle exec jekyll build`
                    end
                    write_pipe.close
                    while line = read_pipe.gets
                        puts "Jekyll: #{line}"
                    end
                end
                Ajd2jkl.say_error 'Error during jekyll creation' && exit(1) unless $?.exitstatus.zero?
            end

            def gemfile
                # `echo "gem 'jekyll-theme-hydejack', '~> 6.0'" >> #{@output}/Gemfile`
                `cd #{@output} && bundle install`
            end

            def extra_docs
                if @config.key?('header') || @config.key?('footer')
                    FileUtils.mkpath "#{@output}/_documentations/"
                    base_dir = File.expand_path File.dirname @options.config
                    FileUtils.cp "#{base_dir}/#{@config['header']['filename']}", "#{@output}/_documentations/#{File.basename @config['header']['filename']}" if @config.key?('header') && @config['header'].key?('filename')
                    FileUtils.cp "#{base_dir}/#{@config['footer']['filename']}", "#{@output}/_documentations/#{File.basename @config['footer']['filename']}" if @config.key?('footer') && @config['footer'].key?('filename')
                end
            end

            def images
                FileUtils.copy_entry File.expand_path(@options.imgs), "#{@output}/images", false, false, true if @options.imgs
            end

            def clean
                FileUtils.remove_dir @output
            end
        end

        def self.underscore(camel_cased_word)
            return camel_cased_word unless /[-A-Z ]|::/.match(camel_cased_word)
            word = camel_cased_word.to_s.gsub('::'.freeze, '/'.freeze)
            word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)()(?=\b|[^a-z])/) { "#{$1 && '_'.freeze }#{$2.downcase}" }
            word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
            word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
            word.tr!('-'.freeze, '_'.freeze)
            word.downcase!
            word
        end
    end
end
