require 'spec_helper'

describe Ta do
	Ta::Data.new([1, 2, 3]).calc(:type => :sma, :variables => 3)
	Ta::Data.new(Securities::Stock.new(["aapl", "yhoo"]).history(:start_date => '2012-01-01', :end_date => '2012-01-30', :periods => :daily).results).calc(:type => :sma, :variables => 10)
end