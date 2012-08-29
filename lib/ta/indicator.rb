module Ta
  #
  # Moving averages
	class Indicator

    # Error handling.
    class IndicatorException < StandardError
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
                                when :bb then bb(Ta::Parser.parse_data(stock_data), parameters[:variables])
                              end
            # Parser returns in {:date=>[2012.0, 2012.0, 2012.0], :open=>[409.4, 410.0, 414.95],} format
          end
        end
			else
				results = case parameters[:type]
				            when :sma then sma(data, parameters[:variables])
                    when :ema then ema(data, parameters[:variables])
                    when :bb then bb(data, parameters[:variables])
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
        raise IndicatorException, "Data point length (#{usable_data.length}) must be greater or equal to periods value (#{variables})."
      end
      return usable_data
    end

    # periods = get_variables([5, 2], 1, 3)
    # default_multiplier = 2
    # multiplier = get_variables(variables, 1, default_multiplier)
    def self.get_variables variables, i=0, default=0
      puts "variables=#{variables}, i=#{i}, default=#{default}"
      if variables.is_a?(Array)
        if variables.length < 2
          puts "Its a fixnum in array #{variables}, returning #{variables[0]}"
          return variables[0]
        else
          puts "Its an array #{variables}, variables[0]=#{variables[0]}, variables[1]=#{variables[1]}"
          if variables[i].nil?
            puts "variables[i] #{variables[i]} is nil. returning default #{default}"
            return default
          else
            puts "variables[i] #{variables[i]} is not nil. returning it"
            return variables[i]
          end
        end
      else
        if i != 0
          puts "Returning default #{default}"
          return default
        end
        puts "its a fixnum #{variables}, returning it, and i is = #{i}"
        return variables
      end
      # if i != 0
      #   if variables.is_a?(Array)
      #     if variables[i].nil?
      #       puts "returning default #{default}"
      #       return default
      #     else
      #       puts "returning variables[i] #{variables[i]}"
      #       return variables[i]
      #     end
      #   else
      #     raise IndicatorException, "You gave an array as variables where you shouldn't."
      #   end
      # else
      #   puts "returning #{variables}"
      #   return variables
      # end

      # if variables.is_a?(Array)
      #   usable_variable = variables[i]
      #   puts "usab #{usable_variable} and class #{usable_variable.class}"
      # else
      #   usable_variable = variables
      # end
      # return usable_variable
    end

    #
    # Moving Averages
    #

    # Simple Moving Average
    def self.sma data, variables
      periods = get_variables(variables)
      usable_data = Array.new
      usable_data = get_data(data, periods, :adj_close)

      # Just the calculation of SMA by the formula.
    	sma = []
  		usable_data.each_with_index do |value, index|
  			from = index+1-periods
  			if from >= 0
  				sum = usable_data[from..index].sum
  				sma[index] = (sum/periods.to_f).round(3)
  			else
  				sma[index] = nil
  			end
  		end
  		return sma
    end

    # Exponential Moving Average
    def self.ema data, variables
      periods = get_variables(variables)
      usable_data = Array.new
      usable_data = get_data(data, periods, :adj_close)

      # Multiplier: (2 / (Time periods + 1) ) = (2 / (10 + 1) ) = 0.1818 (18.18%)
      # EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
      ema = []
      k = 2/(periods+1).to_f
      usable_data.each_with_index do |value, index|
        from = index+1-periods
        if from == 0
          ema[index] = sma(usable_data[from..index], periods).last
          # puts ma
        elsif from > 0
          ema[index] = ((usable_data[index] - ema[index-1]) * k + ema[index-1]).round(3)
        else
          ema[index] = nil
        end
      end
      return ema
    end

    # Bollinger Bands bb(:variables => 20, 2)
    def self.bb data, variables
      periods = get_variables(variables)
      default_multiplier = 2
      multiplier = get_variables(variables, 1, default_multiplier)
      # FIXME: Set default multiplier.
      usable_data = Array.new
      usable_data = get_data(data, periods, :adj_close)
      # Middle Band = 20-day simple moving average (SMA)
      # Upper Band = 20-day SMA + (20-day standard deviation of price x 2) 
      # Lower Band = 20-day SMA - (20-day standard deviation of price x 2)
      bb = []
      # usable_data.each_with_index do |value, index|
      #   from = index+1-periods
      #   if from >= 0
      #     middle_band = sma(usable_data[from..index], periods).last
      #     upper_band = middle_band + (usable_data.standard_deviation * multiplier)
      #     lower_band = middle_band - (usable_data.standard_deviation * multiplier)
      #     # output is [middle, upper, lower]
      #     bb[index] = [middle_band, upper_band.round(3), lower_band.round(3)]
      #   else
      #     bb[index] = nil
      #   end
      # end
      return bb
    end


	end
end

# Extra methods for mathematical calculations
module Enumerable

  def sum
    return self.inject(0){|accum, i| accum + i }
  end

  def mean
    return self.sum / self.length.to_f
  end

  def sample_variance
    m = self.mean
    sum = self.inject(0){|accum, i| accum + (i - m) ** 2 }
    return sum / (self.length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end

end