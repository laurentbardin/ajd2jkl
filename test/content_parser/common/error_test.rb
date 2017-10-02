require 'test_helper'

class CommonParserErrorTest < Minitest::Test
    def test_that_it_is_multiline
        e = Ajd2jkl::ContentParser::CommonContent::Error.new ''
        assert e.is_multiline?
    end
end
