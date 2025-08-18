function __InputConfigVerbs()
{
    enum INPUT_VERB
    {
        //Add your own verbs here!
        REBIND_TEST,
    }
    
    enum INPUT_CLUSTER
    {
        //Add your own clusters here!
        //Clusters are used for two-dimensional checkers (InputDirection() etc.)
        NAVIGATION,
    }
    
    if (not INPUT_ON_SWITCH)
    {
        InputDefineVerb(INPUT_VERB.REBIND_TEST,      "test",         ["W"],    [gp_padu]);
    }
    else //Flip A/B over on Switch
    {
        InputDefineVerb(INPUT_VERB.REBIND_TEST,      "test",         undefined,    [gp_padu]);
    }
    
    //Define a cluster of verbs for moving around
    //InputDefineCluster(INPUT_CLUSTER.NAVIGATION, INPUT_VERB.UP, INPUT_VERB.RIGHT, INPUT_VERB.DOWN, INPUT_VERB.LEFT);
}
