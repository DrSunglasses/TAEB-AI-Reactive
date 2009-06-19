package TAEB::AI::Reactive::Priority;

# The general priority structure is based on the priority system of
# saiph, a rival NetHack bot that Jeffrey Bosboom (the author of
# Reactive) was involved with.

use constant {
    # >= 1000: actions that do not take time
    # there shouldn't be many of these, these are framework's job
    
    # 800-999: emergencies, spend any resource necessary to survive
    CURE_LEATHAL => 995, # sickness, stoning, sliming etc.
    FIX_HUNGER_STARVING => 950, # eat if possible, otherwise pray
    # 600-799: caution advised, but don't expend unnecessary resources
    
    # 400-599: don't move, but fight if safe, eat, etc.
    EAT_WEAK => 590,
    APPLY_UNIHORN_NONLEATHAL => 580, # hallu, conf, etc.
    EAT_CURE_NONLEATHAL => 575, # spring of wolfsbane, carrot, etc.
    EAT_HUNGRY => 450,
    # 200-399: go about our normal business
    BUC_ID_ITEMS => 350,
    TAKE_ITEMS => 300,
    DROP_ITEMS => 290,
    # 0-199: explore, etc. until we find something else to do
    CHECK_INTERESTING => 150,
    OPEN_DOOR => 100,
    EXPLORE_FIND_STAIRS_UP => 60,
    EXPLORE => 50,
    EXPLORE_FIND_STAIRS_DOWN => 40,
    DESCEND => 30,
    RANDOM_WALK_FALLBACK => 5,
};

#TODO: work out a system like saiph has for partitioning the priority space

1;
