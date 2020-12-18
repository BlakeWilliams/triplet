require "test_helper"

class TripletTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Triplet::VERSION
  end
end
