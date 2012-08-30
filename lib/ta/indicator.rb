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
                                when :macd then macd(Ta::Parser.parse_data(stock_data), parameters[:variables])
                              end
            # Parser returns in {:date=>[2012.0, 2012.0, 2012.0], :open=>[409.4, 410.0, 414.95],} format
          end
        end
			else
				results = case parameters[:type]
				            when :sma then sma(data, parameters[:variables])
                    when :ema then ema(data, parameters[:variables])
                    when :bb then bb(data, parameters[:variables])
                    when :macd then macd(data, parameters[:variables])
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

    def self.get_variables variables, i=0, default=0
      if variables.is_a?(Array)
        # In case array is given not like [1, 2] but like this ["1", "2"]. This usually happens when getting data from input forms.
        variables = variables.map(&:to_i)
        if variables.length < 2
          return default if i != 0
          return variables[0]
        else
          if variables[i].nil? then return default else return variables[i] end
        end
      else
        return default if i != 0
        return variables
      end
    end

    #
    # Lagging indicators
    #

    # Simple Moving Average
    def self.sma data, variables
      periods = get_variables(variables)
      usable_data = Array.new
      usable_data = get_data(data, periods, :adj_close)

      # Just the calculation of SMA by the formula.
    	sma = []
  		usable_data.each_with_index do |value, index|
  			from = index-periods+1
  			if from >= 0
  				sum = usable_data[from..index].sum
  				sma[index] = (sum/periods.to_f)
  			else
  				sma[index] = nil
  			end
  		end
  		return sma
    end

    #
    # Exponential Moving Average

    # Multiplier: (2 / (Time periods + 1) ) = (2 / (10 + 1) ) = 0.1818 (18.18%)
    # EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
    def self.ema data, variables
      periods = get_variables(variables)
      usable_data = Array.new
      usable_data = get_data(data, periods, :adj_close)

      ema = []
      k = 2/(periods+1).to_f
      usable_data.each_with_index do |value, index|
        from = index+1-periods
        if from == 0
          ema[index] = sma(usable_data[from..index], periods).last
          # puts ma
        elsif from > 0
          ema[index] = ((usable_data[index] - ema[index-1]) * k + ema[index-1])
        else
          ema[index] = nil
        end
      end
      return ema
    end

    #
    # Bollinger Bands :type => :bb, :variables => 20, 2)

    # Middle Band = 20-day simple moving average (SMA)
    # Upper Band = 20-day SMA + (20-day standard deviation of price x 2) 
    # Lower Band = 20-day SMA - (20-day standard deviation of price x 2)
    def self.bb data, variables
      periods = get_variables(variables)
      default_multiplier = 2
      multiplier = get_variables(variables, 1, default_multiplier)

      usable_data = Array.new
      usable_data = get_data(data, periods, :adj_close)
      bb = []
      usable_data.each_with_index do |value, index|
        from = index-periods+1
        if from >= 0
          middle_band = sma(usable_data[from..index], periods).last
          upper_band = middle_band + (usable_data[from..index].standard_deviation * multiplier)
          lower_band = middle_band - (usable_data[from..index].standard_deviation * multiplier)
          # output is [middle, upper, lower]
          bb[index] = [middle_band, upper_band, lower_band]
        else
          bb[index] = nil
        end
      end
      return bb
    end

    # FIX ME!@!@! PROBABLY WRONG RESULTS.
    # MACD

    # MACD Line: (12-day EMA - 26-day EMA) 
    # Signal Line: 9-day EMA of MACD Line
    # MACD Histogram: MACD Line - Signal Line
    # Default MACD(12, 26, 9)
    def self.macd data, variables
      faster_periods = get_variables(variables, 0, 12)
      slower_periods = get_variables(variables, 1, 26)
      signal_periods = get_variables(variables, 2, 9)
      puts "faster=#{faster_periods}, slower=#{slower_periods}, signal=#{signal_periods}"

      usable_data = Array.new
      usable_data = get_data(data, slower_periods+signal_periods-1, :adj_close)
      macd = []
      macd_line = []

      usable_data.each_with_index do |value, index|
        if index+1 >= slower_periods
          # Calibrate me! Not sure why it doesn't accept from or from_faster.
          faster_ema = ema(usable_data[0..index], faster_periods).last
          slower_ema = ema(usable_data[0..index], slower_periods).last
          macd_line[index] = faster_ema - slower_ema
          if index+1 >= slower_periods + signal_periods
            # I'm pretty sure this is right
            signal_line = ema(macd_line[(-signal_periods)..index], signal_periods).last 
            # output is [MACD, Signal, MACD Hist]
            macd_histogram = macd_line[index] - signal_line
            macd[index] = [macd_line[index], signal_line, macd_histogram]
          end
        else
          macd_line[index] = nil
          macd[index] = nil
        end
      end
      return macd

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