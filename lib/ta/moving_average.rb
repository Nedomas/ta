module Ta
  #
  # Moving averages
  # Usage: Ta::Moving_average.new(:type => :ema, :periods => 2, :data => [1, 2, 3, 4])
  # :type is set to default :sma if not specified.
	class Moving_average

		attr_reader :data, :results
		# Error handling
		class Moving_averageException < StandardError
		end

		TYPES_ARRAY = [:sma]

		def initialize parameters
			validate_input(parameters)
			# @type = parameters[:type]
			# @periods = parameters[:periods]
			calculate_output(parameters)
    end

    private

    def calculate_output parameters
    	#
    	# Ta::Moving_average.new(:type => :sma, :data => [1, 2, 3, 4, 5], :periods => 2)
    	if parameters[:type] == :sma

    		if @input_type == :array
	    		@results = calculate_sma(@data, parameters[:periods])
	    	elsif @input_type == :hash
	    		# Hash from securities gem.
	    		@results = Hash.new
	    		@data.each do |symbol, stock_data|
		    		@results[symbol] = calculate_sma(stock_data, parameters[:periods])
		    	end
	    	end
	    	return @results
    	end
    	# TODO: Add EMA, etc.
    end

    #
    # Calculating Simple Moving Average.
    def calculate_sma data, periods
    	sma = []
  		data.each_with_index do |value, index|
  			from = index+1-periods
  			if from >= 0
  				sum = data[from..index].inject { |sum, value| sum + value }
  				sma[index] = (sum/periods.to_f).round(3)
  			else
  				sma[index] = nil
  			end
  		end
  		return sma
    end

    # Validate input parameters
    def validate_input parameters

    	unless parameters.is_a?(Hash)
				raise Moving_averageException, 'Given parameters have to be a hash.'
			end

			unless parameters.has_key?(:periods)
				raise Moving_averageException, 'You must specify periods value.'
			end

			unless parameters[:periods].is_a?(Integer)
				raise Moving_averageException, 'Periods value must be an integer.'
			end

    	# If not specified, set default :type to :sma.
    	parameters[:type] = :sma if parameters[:type].nil? or parameters[:type].empty?

    	unless TYPES_ARRAY.include?(parameters[:type])
				raise Moving_averageException, 'Invalid type value specified.'
			end

			unless parameters.has_key?(:data)
				raise Moving_averageException, 'You must give some data to work on.'
			end

			# Data should be {"aapl"=>
  		# [{:date=>"2012-01-04",
  		# 	:open=>"410.00",
  		# 	:high=>"414.68", 
  		# 	:low=>"409.28", 
  		# 	:close=>"413.44", 
  		# 	:volume=>"9286500", 
  		# 	:adj_close=>"411.67"}]}

  		# For testing
  		# Ta::Moving_average.new(:type => :sma, :data => Securities::Stock.new(["aapl", "yhoo"]).history(:start_date => '2012-01-01', :end_date => '2012-01-05', :periods => :daily).results, :periods => 5)

  		@data = parameters[:data]
			if @data.is_a?(Array)
				# Got data as [1, 2, 3, 4, 5]
				@input_type = :array

				# Raise this exception after alien data exception.
				length_error = true if @data.length < parameters[:periods]
			elsif @data.is_a?(Hash)
				# Probably got the data from securities gem.
				@input_type = :hash

				# Traverse this hash to {symbol => adj_close prices array}
				@data.each do |symbol, stock_data|
					prices_array = []
					stock_data.each_with_index { |row, index| prices_array[index] = row[:adj_close].to_f }
					@data[symbol] = prices_array.reverse

					# Raise this exception after alien data exception.
					length_error = true if @data[symbol].length < parameters[:periods]
				end
			else
				raise Moving_averageException, 'Alien data. Given data must be an array or a hash.'
			end

			if length_error == true
				raise Moving_averageException, "Data point length (#{data_length}) must be greater or equal to periods value (#{parameters[:periods]})."
			end

			return @data
    end
	end
end