# Ta

Technical analysis gem.

[![Build Status](https://secure.travis-ci.org/Nedomas/ta.png)](http://travis-ci.org/Nedomas/ta)[![Build Status](https://gemnasium.com/Nedomas/ta.png)](https://gemnasium.com/Nedomas/ta)

Current functionality demo of Ta and Securities gems: http://strangemuseum.heroku.com
To use this gem with Yahoo Finance information more efficiently, download securities gem: https://rubygems.org/gems/securities

## Installation

Add this line to your application's Gemfile:

    gem 'ta'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ta

## Usage
	
Accepts an array as data

	my_data = Ta::Data.new([1, 2, 3, 4, 5])
	my_data.calc(:type => :sma, :variables => 2) 

It returns SMA's in data point index places. Like:

	[nil, 1.5, 2.5, 3.5, 4.5]
	:type is set to default :sma (Simple Moving Average) if not specified.

Accepts a hash from securities gem as data.

	my_data = Ta::Data.new(Securities::Stock.new(["aapl", "yhoo"]).history(:start_date => '2012-01-01', :end_date => '2012-02-30', :periods => :daily).results)
	my_data.calc(:type => :sma, :variables => 5)

Bollinger Bands

	BB output is [middle band, upper band, lower band]
	my_data.calc(:type => :bb, :variables => [20, 2])
	
	Variables has to be a array [periods, multiplier]. If not specified, multiplier defaults to 2.
	my_data.calc(:type => :bb, :variables => 20)

Moving Average Convergence Divergence

	MACD output is [MACD line, signal line, MACD histogram]
	my_data.calc(:type => :macd, :variables => [12, 26, 9])
	
	Variables has to be a array [faster_periods, slower_periods, signal_line]. If slower periods and signal line are not specified, they default to 26, 9.
	my_data.calc(:type => :macd, :variables => 12)

## Indicators supported

NOW SUPPORTS: 
* SMA (Simpe Moving Averages)
* EMA (Exponental Moving Averages)
* BB (Bollinger Bands)
* MACD (Moving Average Convergence Divergence)

## To do

* Make it accept securities gem output as input without the extra hassle.+
* Refactor for a better gem skeleton.+
* Fix dividends error message from securities gem (undefined method `length' for nil:NilClass).+
* Recheck formulas.+

* Write specs.
* More validations
* Moving averages (SMA+, CMA, WMA, EMA+, MMA).
* Bollinger Bands+.
* MACD.+
* RSI.
* Stochastics.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
