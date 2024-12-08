require 'async'
require 'async/barrier'
require 'socket'

module Retroarch
  class GameManager

    def self.launch_game
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
