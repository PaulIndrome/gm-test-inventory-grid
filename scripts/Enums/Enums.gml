enum ITEM_ROTATIONS {
	NORTH,
	EAST,
	SOUTH,
	WEST,
}

enum ITEM_REASON {
	DEFAULT, 
	QUEST_ADD_REWARD,
	QUEST_ADD_ITEM,
	QUEST_REMOVE_ITEM,
	DEATH_PENALTY,
}

enum ITEM_ERROR {
	NONE,
	DEST_INVENTORY_FULL,
	DEST_OCCUPIED,
	DEST_FIT,
	SWAP_DEST_FIT,
	SWAP_SRC_FIT,
	SWAP_BOTH_FIT,
	SWAP_CONFLICT,
	AMOUNT_INSUFFICIENT,
}

#macro ITEM_ERROR_STRING __get_item_error_string
///@ignore
function __get_item_error_string(_enum){
    switch(_enum){
	    case ITEM_ERROR.NONE:
			return "NONE";
	    case ITEM_ERROR.DEST_INVENTORY_FULL:
			return "DEST_INVENTORY_FULL";
	    case ITEM_ERROR.DEST_OCCUPIED:
			return "DEST_OCCUPIED";
	    case ITEM_ERROR.DEST_FIT:
			return "DEST_FIT";
	    case ITEM_ERROR.SWAP_DEST_FIT:
			return "SWAP_DEST_FIT";
	    case ITEM_ERROR.SWAP_SRC_FIT:
			return "SWAP_SRC_FIT";
	    case ITEM_ERROR.SWAP_BOTH_FIT:
			return "SWAP_BOTH_FIT";
	    case ITEM_ERROR.SWAP_CONFLICT:
			return "SWAP_CONFLICT";
	    case ITEM_ERROR.AMOUNT_INSUFFICIENT:
			return "AMOUNT_INSUFFICIENT";
	    //case ITEM_ERROR.:
		//	return ;
	    //case ITEM_ERROR.:
		//	return ;
	    //case ITEM_ERROR.:
		//	return ;
	    //case ITEM_ERROR.:
		//	return ;
	    //case ITEM_ERROR.:
		//	return ;
	    //case ITEM_ERROR.:
		//	return ;
		default:
			return "";
	}
}