require 'test/unit'
require 'nutrasuite'

require_relative '../lib/obfuscurity'

class BafflerTest < MiniTest::Unit::TestCase
  a 'Baffler' do
    it 'should generate unique (repeatable) number from integer' do
      # Wondering why the results are 302841629 and 571277085? See this
      # thread on Stack Overflow:
      #
      # http://stackoverflow.com/questions/1179439/best-way-to-generate-order-numbers-for-an-online-store

      2.times do
        assert_equal 302841629, Obfuscurity::Baffler.new.obfuscate(1)
      end
      assert_equal 571277085, Obfuscurity::Baffler.new.obfuscate(2)
    end

    it 'should convert an obfuscated number back into the original integer' do
      baffler = Obfuscurity::Baffler.new

      assert_equal 1, baffler.clarify(302841629)
      assert_equal 2, baffler.clarify(571277085)

      10.times do |i|
        n = baffler.obfuscate(i)
        assert_equal i, baffler.clarify(n)
      end
    end

    it 'allow you to control the size of the number space' do
      baffler = Obfuscurity::Baffler.new(max_bits: 16, seed: 1)
      assert_equal 21505, baffler.obfuscate(42)
    end

    it "should ensure that seed doesn't exceed available bits" do
      max_bits = 30
      too_big = (2 ** max_bits) + 1
      assert_raises(Obfuscurity::Error) do
        Obfuscurity::Baffler.new(max_bits: max_bits, seed: too_big)
      end
    end

    it "should ensure that obscured numbers don't exceed available bits" do
      baffler = Obfuscurity::Baffler.new
      assert_raises(Obfuscurity::Error) do
        baffler.obfuscate((2 ** 30) + 1)
      end
    end
  end
end
