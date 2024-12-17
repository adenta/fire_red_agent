require 'async'
require 'async/barrier'
require 'net/http'
require 'uri'

module Sky
  class MemoryReader
    SERVER_ADDRESS = 'localhost'
    SERVER_PORT = 9043
    BATCH_SIZE = 50

    def self.read_bytes(address, length)
      memory_data = Array.new(length)
      Async do
        barrier = Async::Barrier.new

        (0...length).step(BATCH_SIZE) do |i|
          barrier.async do
            batch_address = address + i
            batch_length = [BATCH_SIZE, length - i].min
            batch_data = read_bytes_packet(batch_address, batch_length)

            batch_data.each_with_index do |byte, j|
              memory_data[i + j] = byte
            end
          end
        end

        barrier.wait
      end

      memory_data
    end

    def self.read_binary_bytes(address, length)
      memory_data = read_bytes(address, length)
      memory_data.map { |byte| byte.to_i(16).chr }.join
    end

    def self.read_bytes_packet(address, length)
      addresses = (address...(address + length)).map { |addr| "addr=#{addr.to_s(16)}" }
      uri = URI("http://#{SERVER_ADDRESS}:#{SERVER_PORT}/read_byte?#{addresses.join('&')}")

      response = Net::HTTP.get_response(uri)
      raise "Request failed: #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      # The response should be a hex string (e.g. "AABBCC..."), parse it into 2-char hex bytes.
      raw_hex = response.body.gsub("\u0000", '').upcase
      raw_hex.chars.each_slice(2).map(&:join)
    end
  end
end
