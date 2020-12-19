require "test_helper"

class TripletTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Triplet::VERSION
  end

  def test_triplet_template
    result = Triplet.template do
      h1 { "hello world" }
    end

    assert_equal "<h1>hello world</h1>", result
  end
end
