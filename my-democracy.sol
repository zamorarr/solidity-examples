pragma solidity ^0.4.18;

contract owned {
    address public owner;
    
    /*
     * Constructor. Sets owner of contract to be sender of contract.
    */
    function owned() public {
        owner = msg.sender;
    }
    
    /*
     * Modifier useful for other functions. Requires sender to
     * be owner of contract.
    */
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    /*
     * Transfer ownership of this contract to a new owner.
    */
    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

contract Congress is owned {
    // public variables
    uint quorum;
    uint debate_minutes;
    int margin;
    
    mapping (address => uint) public member_ids;
    Member[] public members;
    
    // events
    event MembershipChange(address member, bool is_member);
    event ChangeOfRules(uint new_quorum, uint new_debate_minutes, int new_margin);
    
    // structures
    struct Member {
        address member;
        string name;
        uint memberSince;
    }

    /*
     * Constructor
     * @param _quorum minimum number of votes needed for quorum
     * @param _debate_minutes length of time allowed for votes
     * @param _margin number of votes above 50% needed for majority
    */
    function Congress(uint _quorum, uint _debate_minutes, int _margin) payable public {
        changeVotingRules(_quorum, _debate_minutes, _margin);
        addMember(owner, "founder");
    }
    
    /*
     * Change voting rules
     * 
     * Set rules such that proposals need to be discussed for at least
     * `debate_minutes`, have at least `quorum` votes, and have 50% +
     * `margin` votes to be executed.
     * 
     * @param quorum minimum number of votes needed for quorum
     * @param debate_minutes length of time allowed for votes
     * @param margin number of votes above 50% needed for majority
    */
    function changeVotingRules(uint _quorum, uint _debate_minutes, int _margin) onlyOwner public {
        quorum = _quorum;
        debate_minutes = _debate_minutes;
        margin = _margin;
        
        // trigger event
        ChangeOfRules(quorum, debate_minutes, margin);    }
    
    /*
     * Add member to group.
     *
     * Make `target_member` a member named `name`
     * @param target_member address to be added
     * @param target_name public name for that member
    */
    function addMember(address target_member, string target_name) onlyOwner public {
        uint id = member_ids[target_member];
        
        // target_member must not already be a member
        require(id == 0);
        
        // get new id
        id = members.length;
        member_ids[target_member] = id;
        
        // add member to array
        members[id] = Member({
            member: target_member,
            name: target_name, 
            memberSince: block.timestamp});
    
        // trigger event
        MembershipChange(target_member, true);
    }
}