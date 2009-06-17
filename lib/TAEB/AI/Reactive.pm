package TAEB::AI::Reactive;
use TAEB::OO;
use Set::Object;
extends 'TAEB::AI';

has 'analyzers' => (
    isa => 'Set::Object',
    default => sub { Set::Object->new; },
    handles => {
        add_analyzer => 'insert',
        remove_analyzer => 'remove',
        analyzers => 'elements',
    },
);

has 'current_priority' => (
    isa => 'Int',
    is => 'rw',
    writer => '_set_current_priority',
    default => 0,
);

use Module::Pluggable (
    instantiate => 'new',
    sub_name => 'load_analyzers',
    search_path => ['TAEB::AI::Reactive::Analyzer'],
);

sub BUILD {
    my $self = shift;
    TAEB->log->ai("In BUILD, about to add analyzers");
    for my $analyzer (load_analyzers()) {
        TAEB->log->ai("Adding analyzer $analyzer").
        $self->add_analyzer($analyzer);
    }
}

sub next_action {
    my $self = shift;
    
    my $next_action = undef;
    $self->_set_current_priority(0);
    my $currently = undef;
    
    TAEB->log->ai("Beginning analyzer loop");
    
    for my $analyzer ($self->analyzers) {
        my ($action, $priority, $currently_string) = $analyzer->analyze();
        TAEB->log->ai("$analyzer proposed $action with priority $priority");
        next unless defined $action;
        
        if ($priority > $self->current_priority) {
            $self->_set_current_priority($priority);
            $next_action = $action;
            $currently = $currently_string;
        }
    }
    
    TAEB->ai->currently("$currently: " . $self->current_priority);
    
    return $next_action;
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;
