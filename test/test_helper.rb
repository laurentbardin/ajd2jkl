$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ajd2jkl'

require 'minitest/autorun'

module MiniTest
    module Assertions
        def refute_raises *exp
            msg = "#{exp.pop}.\n" if String === exp.last

            begin
                yield
            rescue MiniTest::Skip => e
                return e if exp.include? MiniTest::Skip
                raise e
            rescue Exception => e
                exp = exp.first if exp.size == 1
                flunk "unexpected exception raised: #{e}"
            end

        end
    end
    module Expectations
        infect_an_assertion :refute_raises, :wont_raise
    end
end

def get_success(line)
    s = Ajd2jkl::ContentParser::CommonContent::Success.new line
    s.analyze
    s
end
