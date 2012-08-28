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
          # Check if this symbol was empty and don't go further with it.
          if stock_data.length == 0
            results[symbol] = []
          else
            results[symbol] = case parameters[:type]
                                when :sma then sma(Ta::Parser.parse_data(stock_data), parameters[:variables])
                                when :ema then ema(Ta::Parser.parse_data(stock_data), parameters[:variables])
                              end
            # Parser returns in {:date=>[2012.0, 2012.0, 2012.0], :open=>[409.4, 410.0, 414.95],} format
          end
        end
			else
				results = case parameters[:type]
				            when :sma then sma(data, parameters[:variables])
                    when :ema then ema(data, parameters[:variables])
				          end
			end

			return results
    end

    private

    def self.get_data data, variables, column
      # If this is a hash, choose which column of values to use for calculations.
      if data.is_a?(Hash)
        usable_data = data[column]
      else
        usable_data = data
      end
      if usable_data.length < variables
        raise Moving_averageException, "Data point length (#{usable_data.length}) must be greater or equal to periods value (#{variables})."
      end
      return usable_data
    end

    # Simple Moving Average
    def self.sma data, variables
      usable_data = Array.new
      usable_data = get_data(data, variables, :adj_close)

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

    # Exponential Moving Average
    def self.ema data, variables
      usable_data = Array.new
      usable_data = get_data(data, variables, :adj_close)

      # Multiplier: (2 / (Time periods + 1) ) = (2 / (10 + 1) ) = 0.1818 (18.18%)
      # EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
      ema = []
      k = 2/(variables+1).to_f
      usable_data.each_with_index do |value, index|
        from = index+1-variables
        if from == 0
          sma = sma(usable_data[from..index], variables)
          ema[index] = sma[index]
          # puts ma
        elsif from > 0
          ema[index] = ((usable_data[index] - ema[index-1]) * k + ema[index-1]).round(3)
          @ma = ema[index]
        else
          ema[index] = nil
        end
      end
      return ema
    end

	end
end