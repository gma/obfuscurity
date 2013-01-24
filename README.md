# Obfuscurity

Have you ever needed to generate a unique number for a piece of data (a
little like a primary key) that's exposed to your customers? You might
use your database's primary key, but you don't want to expose an
internal counter that could give away sensitive information.

An **order number in a billing system** is a good example; until you've
processed thousands of orders you won't want people to know just how
young your business it (in some cases, it doesn't instil confidence).

Or perhaps you don't want your competitors to be able to work out **how
many people have signed up for your web app**, but want to include a
customer number in the URL? If you were to use an incrementing field
from your database, that information becomes painfully apparent.

The obvious solution (generating a random number and checking to see
whether it's already in use) feels like a hack, and performance starts
to suffer (because you find yourself generating numbers that have
already been used) quicker than you might expect.

Luckily, there's an easy solution, as outlined in [this comment][comment]
on StackOverflow. Just in case you don't have access to StackOverflow
right now, this is what it says:

> Pick a 8 or 9 digit number at random, say 839712541. Then, take your
> order number's binary representation (for this example, I'm not using
> 2's complement), pad it out to the same number of bits (30), reverse it,
> and xor the flipped order number and the magic number.

[comment]: http://stackoverflow.com/a/612085/158841

(Don't worry if you didn't follow that)

It's rather ingenius, and allows you to take a random seed (e.g.
839712541) and a incrementing series of numbers, and convert them into a
seemingly random series. You can then convert them back again simply by
reversing the approach.

Of course, this **isn't** a secure approach. Anybody with a computer and
plenty of time would be able to work out the pattern.

If you've got some numbers that you seriously need to protect, use
cryptography. Obscurity provides [no security at all][wikipedia].

[wikipedia]: http://en.wikipedia.org/wiki/Security_through_obscurity

## Installation

Add this line to your application's Gemfile:

    gem 'obfuscurity'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install obfuscurity

## Usage

To obfuscate the number you want to hide, make yourself a `Baffler`:

    baffler = Obfuscurity::Baffler.new
    baffler.obfuscate(1)  # -> 302841629
    baffler.obfuscate(2)  # -> 571277085

If you later want to convert back to your primary key, use the clarify
method:

    baffler.clarify(302841629)  # -> 1
    baffler.clarify(571277085)  # -> 2

The `Baffler` object just happens to convert `1` to `302841629` because
of the seed that it's using (see the [StackOverflow comment][comment]
for details).

### Configuring behaviour

If you'd like to use a different sequence specify a different seed when
you create the `Baffler` instance:

    baffler = Obfuscurity::Baffler.new(seed: 61493749)

You'll no doubt have noticed that the numbers produced by default are
rather large. The algorithm uses a fixed number of bits (30 by default),
so any number as large as `2 ** 30` could be returned by the `obfuscate`
method.

If you know you won't need anything like that many unique numbers you
can reduce the number of bits:

    baffler = Obfuscurity::Baffler.new(max_bits: 16)
    baffler.obfuscate(42)  # -> 21505

Just be aware that the maximum number of unique numbers that you can
cope with is `2 ** max_bits`, or in the case of 16 bits, just 32768
(which isn't a lot).

If you attempt to obfuscate a number that's too big to fit in the number
space available (i.e. you exceed the value set for `max_bits`) a
`Obfuscurity::Error` exception will be raised.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Thanks to @benlovell for suggesting the name.
