module Ta
  #
  # Moving averages
	class Moving_average

    # Error handling.
    class Moving_averageException < StandardError
    end

		def self.calculate data, parameters

			if data.is_a?(Hash)
        results = Hash.new
        data.each do |symbol, stock_data|
          results[symbol] = case parameters[:type]
                              when :sma then sma(Ta::Parser.parse_data(stock_data), parameters[:variables])
                            end
          # Parser returns in {:date=>[2012.0, 2012.0, 2012.0], :open=>[409.4, 410.0, 414.95],} format
        end
			else
				results = case parameters[:type]
				            when :sma then sma(data, parameters[:variables])
				          end
			end

			return results
    end

    def self.sma data, variables
      usable_data = []
      # If this is a hash, choose which column of values to use for calculations.
      if data.is_a?(Hash)
        usable_data = data[:adj_close]
      else
        usable_data = data
      end

      if usable_data.length < variables
        raise Moving_averageException, "Data point length (#{usable_data.length}) must be greater or equal to periods value (#{variables})."
      end
      # Just the calculation of SMA by the formula.
    	sma = []
  		usable_data.each_with_index do |value, index|
  			from = index+1-variables
  			if from >= 0
  				sum = usable_data[from..index].inject { |sum, value| sum + value }
  				sma[index] = (sum/variables.to_f).round(3)
  			else
  				sma[index] = nil
  			end
  		end
  		return sma
    end

	end
end