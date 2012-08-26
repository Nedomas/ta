module Ta
  #
  # Moving averages
  # Usage: Ta::Moving_average.new(:type => :ema, :periods => 2, :data => [1, 2, 3, 4])
  # :type is set to default :sma if not specified.
	class Moving_average

		# Error handling
		class Moving_averageException < StandardError
		end

		TYPES_ARRAY = [:sma]

		def initialize parameters
			validate_input(parameters)
			@type = parameters[:type]
			@periods = parameters[:periods]
			# FIXME: Accept hash from securities as data.
			@data = parameters[:data]
			calculate_output(parameters)
    end

    private

    def calculate_output parameters

    	#
    	# Calculating Simple Moving Average.
    	# Ta::Moving_average.new(:type => :sma, :data => [1, 2, 3, 4, 5], :periods => 2)

    	if @type == :sma
    		@sma = []
    		# Should return [nil, (1+2)/2, (2+3)/2, (3+4)/2, (4+5)/2]
    		@data.each_with_index do |value, index|
    			from = index+1-@periods
    			if from >= 0
    				sum = @data[from..index].inject { |sum, value| sum + value }
    				@sma[index] = sum/@periods.to_f
    			else
    				@sma[index] = nil
    			end
    		end
    		# Return [nil, 1.5, 2.5, 3.5, 4.5]
    		return @sma
    	end

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

  		# Currently accepts arrays only.
  		# FIXME: Should accept securities gem output as input.
			unless parameters[:data].is_a?(Array)
				raise Moving_averageException, 'Given data must be an array.'
			end

			unless parameters[:data].length >= parameters[:periods]
				raise Moving_averageException, "Data point length (#{parameters[:data].length}) must be greater or equal to periods value (#{parameters[:periods]})."
			end

    end

	end

end