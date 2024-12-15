module Game
  class SymbolReader
    def self.read_symbol(address)
      address_as_string =
        if address.is_a?(String)
          address.downcase.rjust(8, '0')

        elsif address.is_a?(Integer)
          address.to_s(16).downcase.rjust(8, '0')
        else
          raise ArgumentError, 'Address must be a string or an integer'
        end

      File.foreach(Rails.root.join('db', 'data', 'symbols.txt')) do |line|
        symbol_address, address_scope, address_length, address_name = line.strip.split(' ')

        if symbol_address == address_as_string
          return {
            address: symbol_address,
            scope: address_scope,
            length: address_length,
            name: address_name
          }
        end
      end

      nil
    end
  end
end
