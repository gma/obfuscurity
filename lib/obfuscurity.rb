require 'obfuscurity/version'

module Obfuscurity
  class Error < RuntimeError; end

  class Baffler
    def initialize(params = {})
      @seed = params.fetch(:seed, 839712541)
      @max_bits = params.fetch(:max_bits, 30)
      check_size_of_number_space(@seed)
    end

    def obfuscate(number)
      check_size_of_number_space(number)
      seed_bits = number_to_bits(@seed)
      xor_bits = (0 ... seed_bits.size).map { |i| number[i] ^ seed_bits[i] }
      bits_to_number(xor_bits)
    end

    def clarify(number)
      bits = number_to_bits(number ^ @seed)
      bits_to_number(bits.reverse)
    end

    private
      def number_to_bits(number)
        [].tap do |bits|
          (@max_bits - 1).downto(0) { |i| bits << number[i] }
        end
      end

      def bits_to_number(bits)
        bits.inject(0) { |result, bit| (result << 1) | bit }
      end

      def check_size_of_number_space(number)
        root = number ** (1.0 / @max_bits)
        if root > 2
          raise Error.new("#{number} requires more than #{@max_bits} bits")
        end
      end
  end
end
