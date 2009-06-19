package TAEB::AI::Reactive::Priority;
use Sub::Exporter -setup => {
    exports => [ qw(EAT_STARVING PRAY_STARVING EAT_WEAK EAT_HUNGRY CURE_USING_UNIHORN CHECK_INTERESTING EXPLORE RANDOM_WALK_FALLBACK) ]
};
use constant {
    EAT_STARVING => 955,
    PRAY_STARVING => 950,
    EAT_WEAK => 850,
    EAT_HUNGRY => 500,
    CURE_USING_UNIHORN => 700,
    CHECK_INTERESTING => 80,
    EXPLORE => 50,
    RANDOM_WALK_FALLBACK => 5,
};

#TODO: work out a system like saiph has for partitioning the priority space
#TODO: also, auto-export all those constants without having to list them ;)

1;
