package TAEB::AI::Reactive::Analyzer::RandomWalk;
use TAEB::OO;
use TAEB::Util qw(delta2vi first shuffle);
use TAEB::Action::Move;
use TAEB::AI::Reactive::Priority qw(RANDOM_WALK_FALLBACK);

extends 'TAEB::AI::Reactive::Analyzer';

sub analyze {
    my @walkable_neighbors;
    
    TAEB->each_adjacent(sub {
        my ($tile, $direction) = @_;
        push @walkable_neighbors, $direction if $tile->is_walkable;
    });
    
    return if scalar(@walkable_neighbors) == 0;
    
    shuffle @walkable_neighbors;
    
    return (TAEB::Action::Move->new(direction => $walkable_neighbors[0]), 
        TAEB::AI::Reactive::Priority::RANDOM_WALK_FALLBACK, "randomly walking");
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
