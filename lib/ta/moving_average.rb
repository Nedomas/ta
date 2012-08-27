module Ta
  #
  # Moving averages
	class Moving_average

		def self.calculate data, parameters

			if data.is_a?(Hash)
        @results = Hash.new
        # stock_data is {"aapl" => {:close => [1, 2, 3], :open => []}}
        data.each do |symbol, stock_data|
          # Parser returns in {:date=>[2012.0, 2012.0, 2012.0], :open=>[409.4, 410.0, 414.95],} format
          @results[symbol] = sma(Ta::Parser.parse_data(stock_data), parameters[:variables])
        end
			else
				case parameters[:type]
					when :sma then @results = sma(data, parameters[:variables])
				end
			end

			return @results
    end

    def self.sma data, variables
      my_data = []
      if data.is_a?(Hash)
        my_data = data[:adj_close]
      else
        my_data = data
      end

    	sma = []
  		my_data.each_with_index do |value, index|
  			from = index+1-variables
  			if from >= 0
  				sum = my_data[from..index].inject { |sum, value| sum + value }
  				sma[index] = (sum/variables.to_f).round(3)
  			else
  				sma[index] = nil
  			end
  		end
  		return sma
    end

	end
end