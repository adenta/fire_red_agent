require 'async'
require 'async/barrier'
require 'socket'

module Retroarch
  class MemoryReader
    BATCH_SIZE = 50

    def self.read_bytes(address, length)
      memory_data = Array.new(length)
      Async do |task|
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

    def self.read_bytes_packet(address, length)
      message = "READ_CORE_MEMORY #{address.to_s(16)} #{length}"
      udp_socket = UDPSocket.new

      # Bind to a local port to receive the response
      udp_socket.bind('0.0.0.0', 0)

      # Send the message
      udp_socket.send(message, 0, '127.0.0.1', 55_355)

      # Set a timeout for the response (optional)
      begin
        udp_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, [1, 0].pack('l_2'))

        # Receive the response
        response, _addr = udp_socket.recvfrom(1024) # 1024 is the max buffer size
        return response.gsub("READ_CORE_MEMORY #{address.to_s(16)} ", '').strip.split(' ')
      rescue Errno::EAGAIN
        puts 'No response received (timeout)'
      end

      udp_socket.close
    end
  end
end
