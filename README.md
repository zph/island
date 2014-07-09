# Island

`no one is an island`

But scripts should be. At least the ones where you want to rely on them, not need to install in each ruby version, and make sure they're inside each Gemfile if executed from somewhere that bundler's active.

Do we need the ack perl module installed to use ack? No, it's self contained.

Shouldn't ruby have a simple way to generate standalone scripts? Island thinks so and will help.

Generates standalone ruby scripts from gems.

## Installation

Add this line to your application's Gemfile:

    gem 'island'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install island

## Usage

    Checkout `examples/*`.

    The basics are glob your necessary files names, including dependencies.

    Pass that info along with some lambdas for rejecting certain lines.

    Write it out to whatever script name you want.

## Motivation for Project

    I saw people re-implementing this same behavior, and after doing it a couple times myself, wanted a better way.

    The project is young, but I've used it to create a couple standalone scripts from gems that have a couple dependencies.  Auto-dependency resolution will make it much nicer in the future.

## TODO

- Detect other files to include at beginning, ignore STDLIB

## Contributing

1. Fork it ( http://github.com/zph/island/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
