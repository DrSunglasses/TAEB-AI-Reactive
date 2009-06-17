package TAEB::AI::Reactive::Analyzer::RandomWalk;
use TAEB::OO;
use TAEB::Util qw(delta2vi first shuffle);
use TAEB::Action::Move;
use TAEB::AI::Reactive::Priority qw(RANDOM_WALK_FALLBACK);

extends 'TAEB::AI::Reactive::Analyzer';

sub analyze {
    my $x = 0;
    my $y = 0;
    
    until ($x != 0 || $y != 0) {
        $x = shuffle (-1, 0, 1);
        $y = shuffle (-1, 0, 1);
    }
    
    return (TAEB::Action::Move->new(direction => delta2vi($x, $y)), RANDOM_WALK_FALLBACK);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
