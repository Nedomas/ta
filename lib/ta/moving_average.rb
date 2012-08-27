module Ta
  #
  # Moving averages
  # Usage: Ta::Moving_average.new(:type => :ema, :periods => 2, :data => [1, 2, 3, 4])
  # :type is set to default :sma if not specified.
	class Moving_average

		def self.calculate data, parameters

      # puts "DATA IS A #{data.class}"

			if data.is_a?(Hash)
        @results = Hash.new
        data.each do |symbol, stock_data|
          # {"aapl" => {:close => [1, 2, 3], :open => []}}
          usable_data = Ta::Parser.parse_data(stock_data)
          @results[symbol] = sma(usable_data, parameters[:variables])
        end
        puts @results
				# @results = Hash.new
				# data.each do |symbol, stock_data|
				# 	case parameters[:type]
				# 		when :sma 
				# 			puts stock_data.class
				# 			@results[symbol] = sma(stock_data, parameters[:variables])
				# 	end
				# end
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