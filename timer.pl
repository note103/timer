#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Time::HiRes qw (sleep);
use Time::Piece;
use Time::Seconds;
use Pod::Usage;


my $VERSION = "v0.0.1";

my $num = $ARGV[0] // '';
my $s; my $ms;

if ($num =~ /\A(\d+)m(.*)/) {
    $num = $1 * 60;
    $s = $2;
    if ($s =~ /\A(\d+)s\z/) {
        $num = $1 + $num;
    }
}
elsif ($num =~ /\A(\d+)h(.*)/) {
    $num = $1 * 60 * 60;
    $ms = $2;
    if ($ms =~ /\A(\d+)m(.*)/) {
        $num = ($1 * 60) + $num;
        $s = $2;
        if ($s =~ /\A(\d+)s\z/) {
            $num = $1 + $num;
        }
    }
    elsif ($ms =~ /\A(\d+)s\z/) {
        $num = $1 + $num;
    }
}
elsif ($num =~ /(.*)_(\d+):(\d+)\z/ || $num =~ /(\d+):(\d+)\z/) {
    my $date; my $h; my $m;
    my $today = localtime->strftime('%Y-%m-%d');

    if ($num =~ /(.*)_(\d+):(\d+)\z/) {
        $date = $1; $h = $2; $m = $3;
        if ($date =~ /\A(\d+-\d+-\d+)\z/) {
            $today = $1;
        }
    }
    elsif ($num =~ /\A(\d+):(\d+)\z/) {
        $h = $1; $m = $2;
    }

    my $target = localtime->strptime("$today $h:$m:00", '%Y-%m-%d %T')->epoch;
    my $now = localtime->epoch;
    $num = $target - $now;
}
elsif ($num =~ /\A(-h|--help)\z/) {
    say "timer.pl $VERSION";
    pod2usage;
}
elsif ($num =~ /\A\D+\z/) {
    exit;
}

$num = 3 if $num eq '';
say "$num seconds.";


while ($num > 0) {
    sleep(1);
    $num--;
    say $num unless $num == 0;
}

say 'Timeout!';
exit if $num < 0;

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
    $times = 10;
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
=head1 SYNOPSIS

  $ perl timer.pl <time> [<alarm>]

  <time>: *h*m*s or hh:mm or yyyy-mm-dd_hh:mm or URL
  <alarm>: *(times) # default is 10 times.

  $ perl timer.pl 1h2m3s		#=> Rings 10 times after 3723 seconds.
  $ perl timer.pl 2m3s 5		#=> Rings 5 times after 123 seconds.
  $ perl timer.pl 3 http://example.com/	#=> Open example.com after 3 seconds.
  $ perl timer.pl 15:55			#=> If that time is 15:54, Rings 10 times after 60 seconds.
  $ perl timer.pl 2019-04-07_15:55	#=> If that time is 2019-04-06 15:54, Rings 10 times after 1 day and 60 seconds.
