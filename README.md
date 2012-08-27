# Ta

Technical analysis gem.

[![Build Status](https://secure.travis-ci.org/Nedomas/ta.png)](http://travis-ci.org/Nedomas/ta)[![Build Status](https://gemnasium.com/Nedomas/ta.png)](https://gemnasium.com/Nedomas/ta)

## Installation

Add this line to your application's Gemfile:

    gem 'ta'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ta

## Usage

# Moving averages
Usage:

	Ta::Moving_average.new(:type => :sma, :data => [1, 2, 3, 4, 5], :periods => 2)
	:type is set to default :sma if not specified.

	It returns SMA's in data point index places. Like:
	[nil, 1.5, 2.5, 3.5, 4.5]

## To do

* Moving averages (SMA+, CMA, WMA, EMA, MMA).
* Make it accept securities gem output as input without the extra hassle.+
* Refactor for a better gem skeleton.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
