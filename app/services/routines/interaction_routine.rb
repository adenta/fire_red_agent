require 'async'

module Routines
  class InteractionRoutine
    def self.run
      Async do |task|
        text_buffer = nil
        loop do
          text = Intelligence::TextReader.read_text
          puts "text: #{text}"
          if text_buffer == text
            ap text
            break
          else
            text_buffer = text
          end
        end
        # loop do
        #   text = Intelligence::TextReader.read_text

        #   if text.empty?
        #     ap
        #   else
        #     TextMemory.create!(body: text) unless text.empty?
        #     Retroarch::KeyboardService.a

        #   end

        # end
      end
    end
  end
end
