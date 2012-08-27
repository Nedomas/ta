require 'spec_helper'

describe Ta do
	my_stocks = Securities::Stock.new(["aapl", "yhoo"])
	my_data = my_stocks.history(:start_date => '2012-01-01', :end_date => '2012-01-20', :periods => :daily)
	Ta::Moving_average.new(:data => my_data.results, :periods => 5)

	Ta::Moving_average.new(:data => [1, 2, 3, 4, 5], :periods => 2)
end