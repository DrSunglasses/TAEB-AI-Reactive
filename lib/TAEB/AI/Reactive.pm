package TAEB::AI::Reactive;
use TAEB::OO;
use Set::Object;
extends 'TAEB::AI';

# Analyzers

has 'active_analyzers' => (
    isa => 'Set::Object',
    is => 'ro',
    default => sub { Set::Object->new; },
);

has 'suspended_analyzers' => (
    isa => 'Set::Object',
    is => 'ro',
    default => sub { Set::Object->new },
);

sub add_analyzer {
    my ($self, $analyzer) = @_;
    TAEB->log->ai("Adding analyzer $analyzer");
    $self->active_analyzers->insert($analyzer);
}

sub add_analyzer_suspended {
    my ($self, $analyzer) = @_;
    TAEB->log->ai("Adding analyzer $analyzer as initially suspended");
    $self->suspended_analyzers->insert($analyzer);
}

sub suspend_analyzer {
    my ($self, $analyzer) = @_;
    TAEB->log->ai("Suspending analyzer $analyzer");
    $self->active_analyzers->remove($analyzer);
    $self->suspended_analyzers->insert($analyzer);
}

sub restore_analyzer {
    my ($self, $analyzer) = @_;
    TAEB->log->ai("Restoring analyzer $analyzer");
    $self->suspended_analyzers->remove($analyzer);
    $self->active_analyzers->insert($analyzer);
}

sub remove_analyzer {
    my ($self, $analyzer) = @_;
    TAEB->log->ai("Removing analyzer $analyzer");
    $self->active_analyzers->remove($analyzer);
    $self->suspended_analyzers->remove($analyzer);
}

# initialize analyzers
# TODO: differentiate between new game and restored state

use Module::Pluggable (
    instantiate => 'new',
    sub_name => 'load_analyzers',
    search_path => ['TAEB::AI::Reactive::Analyzer'],
);

sub BUILD {
    my $self = shift;
    TAEB->log->ai("In BUILD, about to add analyzers");
    for my $analyzer (load_analyzers()) {
        $self->add_analyzer($analyzer);
    }
    TAEB->log->ai("Done loading analyzers");
}

# next_action and related things

has 'current_priority' => (
    isa => 'Int',
    is => 'rw',
    writer => '_set_current_priority',
    default => 0,
);

sub next_action {
    my $self = shift;
    
    my $next_action = undef;
    $self->_set_current_priority(0);
    my $currently = undef;
    
    TAEB->log->ai("Beginning analyzer loop");
    
    my @iterants = $self->active_analyzers->elements;
    for my $analyzer (@iterants) {
        my ($action, $priority, $currently_string) = $analyzer->analyze();
        if (!defined $action) {
            TAEB->log->ai("$analyzer was consulted, but proposed no action");
        } else {
            TAEB->log->ai("$analyzer wants $action ($currently_string) with priority $priority");
        }
        next unless defined $action;
        
        if ($priority > $self->current_priority) {
            $self->_set_current_priority($priority);
            $next_action = $action;
            $currently = $currently_string;
        }
    }
    
    TAEB->ai->currently("$currently: ${\$self->current_priority}");
    
    return $next_action;
}

__PACKAGE__->meta->make_immutable;

1;
