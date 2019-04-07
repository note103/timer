#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Time::HiRes qw (sleep);

my $num = $ARGV[0] // 3;

if ($num =~ /\A(\d+)m\z/) {
    $num = $1 * 60;
}
elsif ($num =~ /\A(\d+)m(\d+)s\z/) {
}
elsif ($num =~ /\A(-h|--help)\z/) {
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
