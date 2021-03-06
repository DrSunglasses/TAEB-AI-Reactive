package TAEB::AI::Reactive::Analyzer::Explore;
use TAEB::OO;
use TAEB::AI::Reactive::Priority;
extends 'TAEB::AI::Reactive::Analyzer';

sub analyze {
    return if TAEB->ai->current_priority > TAEB::AI::Reactive::Priority::EXPLORE;
    my $self = shift;
    
    my $path = TAEB::World::Path->first_match(sub {
        shift->unexplored;
    }, through_unknown => 1);
    unless (defined $path) {
        TAEB->ai->suspend_analyzer($self);
        return;
    }
    
    return ($path, TAEB::AI::Reactive::Priority::EXPLORE, "exploring");
}

subscribe level_change => sub {
    my $self = shift;
    TAEB->ai->restore_analyzer($self);
};

subscribe tile_type_change => sub {
    my $self = shift;
    TAEB->ai->restore_analyzer($self);
};

__PACKAGE__->meta->make_immutable;

1;
