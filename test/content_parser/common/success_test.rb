require 'test_helper'

class CommonParserErrorTest < Minitest::Test

    def test_that_line_must_valid_check
        s = get_success "{Array} users An array of small objects containing the ID and the login name of each [User](#api-object-user). If not channel filter passed in url, then The small user object contains a channels field too, with list\n"
        assert_equal 'users', s.field
        assert_equal 'Array', s.type
        assert_equal 'Success 200', s.group
        assert_equal false, s.optional?
        assert_equal 'An array of small objects containing the ID and the login name of each [User](#api-object-user). If not channel filter passed in url, then The small user object contains a channels field too, with list', s.description

        s.append_line "of registred channel for this user in this beta test program.\n"
        assert_equal "An array of small objects containing the ID and the login name of each [User](#api-object-user). If not channel filter passed in url, then The small user object contains a channels field too, with list\nof registred channel for this user in this beta test program.\n", s.description
    end
end
