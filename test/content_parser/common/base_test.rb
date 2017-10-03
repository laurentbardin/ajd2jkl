require 'test_helper'

class ContentParserCommonBaseTest < Minitest::Test
    def test_that_it_is_multiline
        @names = %w[
            Deprecated
            Description
            ErrorExample
            Error
            HeaderExample
            ParamExample
            Param
            SuccessExample
            Success
        ].freeze
        @names.each do |e|
            object = Object::const_get("::Ajd2jkl::ContentParser::CommonContent::#{e}").new ''
            assert object.is_multiline?
            refute_raises Exception do
                object.end_multiline
            end
        end
    end

    def test_that_it_is_not_multiline
        @names = %w[
            Group
            Header
            Permission
            Private
            SampleRequest
            Use
            Version
        ].freeze
        @names.each do |e|
            object = Object::const_get("::Ajd2jkl::ContentParser::CommonContent::#{e}").new ''
            assert !object.is_multiline?
            err = assert_raises ::Exception do
                object.end_multiline
            end
            assert err.message.start_with? 'undefined method `end_multiline'
        end
    end
end
