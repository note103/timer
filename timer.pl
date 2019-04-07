#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Time::HiRes qw (sleep);

my $num = $ARGV[0] // 3;
my $VERSION = "v0.0.1";

if ($num =~ /\A(\d+)m\z/) {
    $num = $1 * 60;
}
elsif ($num =~ /\A(\d+)m(\d+)s\z/) {
}
elsif ($num =~ /\A(-h|--help)\z/) {
    say "timer.pl $VERSION";
    say '';
my $help = <<"help";
Usage:
    \$ perl timer.pl <time> [<alarm>]

    <time>: *h*m*s or hh:mm or yyyy-mm-dd_hh:mm or URL
    <alarm>: *(times) # default is 10 times.

Synopsis: 
    \$ perl timer.pl 1h2m3s\t#=> Rings 10 times after 3723 seconds.
    \$ perl timer.pl 2m3s 5\t#=> Rings 5 times after 123 seconds.
    \$ perl timer.pl 3s http://example.com/\t#=> Open example.com after 3 seconds.
    \$ perl timer.pl 15:55\t#=> If that time is 15:54, Rings 10 times after 60 seconds.
    \$ perl timer.pl 2019-04-07_15:55\t#=> If that time is 2019-04-06 15:54, Rings 10 times after 1 day and 60 seconds.
help
    say $help;
    exit;
}
elsif ($num =~ /\A\D+\z/) {
    exit;
}

say "$num seconds.";

while ($num > 0) {
    sleep(1);
    $num--;
    say $num unless $num == 0;
}

say 'Timeout!';

my @sound = <DATA>;
@sound = map {chomp; $_} @sound;
my $selected_sound = $sound[int(rand(scalar @sound))];

my $url;
my $times = $ARGV[1] // '';

if ( $times =~ /\A(\d+)\z/) {
    $times = $1;
}
elsif ($times =~ /\A(http\S+)/) {
    $url = $1;
}
elsif ($times =~ /\A(\D+)\z/) {
    exit;
}
else {
    $times = 60;
}

if ($url) {
    print `open $url`;
}
else {
    my $bell = 0;
    while ($bell < $times) {
        print `afplay /System/Library/Sounds/$selected_sound`;
        $bell++;
    }
}

__DATA__
Ping.aiff
Basso.aiff
Blow.aiff
Bottle.aiff
Frog.aiff
Funk.aiff
Glass.aiff
Hero.aiff
Morse.aiff
Pop.aiff
Purr.aiff
Sosumi.aiff
Submarine.aiff
Tink.aiff
