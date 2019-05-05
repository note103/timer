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
my $url = $ARGV[1] // '';

if ($num =~ /\A(\d+)s\z/) {
    $num = $1;
}
elsif ($num =~ /\A(\d+)m(.*)/) {
    $num = $1 * 60;
    my $s = $2;
    if ($s =~ /\A(\d+)s\z/) {
        $num = $1 + $num;
    }
}
elsif ($num =~ /\A(\d+)h(.*)/) {
    $num = $1 * 60 * 60;
    my $ms = $2;
    if ($ms =~ /\A(\d+)m(.*)/) {
        $num = ($1 * 60) + $num;
        my $s = $2;
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
elsif ($num =~ /\A(https?:\S+)\z/) {
    $num = '';
    $url = $1;
}
elsif ($num =~ /\A(-h|--help)\z/) {
    say "timer.pl $VERSION\n";
    pod2usage(verbose => 0);
}

$num = 3 if $num eq '';
say "$num seconds.";


while ($num > 0) {
    sleep(1);
    $num--;
    say $num unless $num == 0;
}

say 'Timeout!';

my @sound = qw /
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
/;

@sound = map {chomp; $_} @sound;
my $random_sound = $sound[int(rand(scalar @sound))];

if ($url) {
    print `open $url`;
}
else {
    print `afplay /System/Library/Sounds/$random_sound` while (1);
}

print `open $url` if ($url =~ /\A(http\S+)/);

exit if $num < 0;


__END__

=head1 SYNOPSIS

$ perl timer.pl [time] [URL]

Example:

  $ perl timer.pl 1h2m3s
  $ perl timer.pl 3s http://example.com/
  $ perl timer.pl 15:55
  $ perl timer.pl 2019-04-07_15:55

Options:

  -h --help            Show help
