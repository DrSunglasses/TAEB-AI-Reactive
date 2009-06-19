package TAEB::AI::Reactive::Analyzer::CheckInteresting;
use TAEB::OO;
use MooseX::AttributeHelpers;
use TAEB::AI::Reactive::Priority qw(CHECK_INTERESTING);
extends 'TAEB::AI::Reactive::Analyzer';

has interesting_tiles => (
    metaclass => 'Collection::Array',
    isa => 'ArrayRef[TAEB::World::Tile]',
    is => 'ro',
    default => sub { [] },
    provides => {
        'push' => 'add_tile',
        'shift' => 'remove_tile',
        'first' => 'next_tile',
    },
);

has num_tiles => (
    metaclass => 'Counter',
);

after add_tile => sub {
    my $self = shift;
    $self->inc_num_tiles;
};

after remove_tile => sub {
    my $self = shift;
    $self->dec_num_tiles;
};

sub analyze {
    my ($self) = @_;
    TAEB->ai->suspend_analyzer($self) and return if $self->num_tiles == 0;
    return if TAEB->ai->current_priority >= CHECK_INTERESTING;
    
    my $target = $self->next_tile;
    while (!$target->is_interesting) {
        $self->remove_tile;
        TAEB->ai->suspend_analyzer($self) and return if $self->num_tiles == 0;
        $target = $self->next_tile;
    }
    
    return (TAEB::World::Path->calculate_path($target), CHECK_INTERESTING, 'moving to an interesting tile');
}

subscribe tile_became_interesting => sub {
    my ($self, $event) = @_;
    my $tile = $event->tile;
    #TAEB->log->ai('CheckInteresting got a message');
    if ($tile->is_interesting) {
        TAEB->log->ai('CheckInteresting heard about an interesting tile');
        $self->add_tile($tile);
        TAEB->ai->restore_analyzer($self);
    }
};

__PACKAGE__->meta->make_immutable;

1;
