#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

use Path::Tiny; # for slurping /usr/share/dict/words

my @wrong_guesses = ();
my @guesses = ();
my @body;
# my @word_pool = path('/usr/share/dict/words')->lines;
my @word_pool = qw/house barn dog/;

my $the_word = $word_pool[rand scalar @word_pool];

my $solved = 0;
do {
    compute_body($guesses);
    illustrate();
    get_new_letter();
} until ($#wrong_guesses eq 5 or is_solved());
if ($#wrong_guesses eq 5) {
    say "Man is hung.";
}
else {
    say "You figured it out!. $the_word";
}

illustrate(); # one last time

sub illustrate {
    say " _____";
    say " |    |";
    say " |   ", sprintf(" %s", $body[0]);
    say " |   ", sprintf("%s%s%s", $body[1], $body[3] || ' ', $body[2]);
    say " |   ", sprintf("%s %s", $body[4], $body[5]);
    say " |";

    print "Letters available: ";
    for my $l (a..z) {
        if (grep /$l/, @guesses) {
            print "_";
        }
        else {
            print $l;
        }
    }
    print "\n";

    for my $c (split //, $the_word) {
        if (grep /$c/, @guesses) {
            print "$c ";
        }
        else {
            print "_ ";
        }
    }
    print "\n";
}

sub compute_body {
    my @full_body = qw(O / \\ | / \\); 
    for my $i (0..$#wrong_guesses) {
        $body[$i] = $full_body[$i];
    }
}

sub get_new_letter {
    print "Enter your guess: ";
    my $guess = <STDIN>;
    chomp $guess;

    if (grep /$guess/, @guesses) {
        say "You've already tried that.";
    }
    else {
        if (grep /$guess/, (split //, $the_word)) {
            say "Yes, there is a '$guess' in the word!";
            push @guesses, $guess;
        }
        else {
            say "No, there is no '$guess' in the word!";
            push @guesses, $guess;
            push @wrong_guesses, $guess;
        }
    }
}

sub is_solved {
    for my $l (split //, $the_word) {
        if (! grep /$l/, @guesses) {
            return 0;
        }
    }

    return 1;
}
