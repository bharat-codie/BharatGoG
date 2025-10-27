// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BlockMatrix-DAO
 * @dev A decentralized governance contract where members can propose, vote, and execute decisions.
 */
contract BlockMatrixDAO {
    struct Proposal {
        uint id;
        string description;
        uint voteCount;
        bool executed;
        address proposer;
    }

    mapping(uint => Proposal) public proposals;
    mapping(address => bool) public members;
    mapping(uint => mapping(address => bool)) public hasVoted;

    uint public proposalCount;
    address public owner;

    event ProposalCreated(uint id, string description, address proposer);
    event Voted(uint id, address voter);
    event ProposalExecuted(uint id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Only DAO members can participate");
        _;
    }

    constructor() {
        owner = msg.sender;
        members[msg.sender] = true;
    }

    // Core Function 1: Add new members to DAO
    function addMember(address _member) public onlyOwner {
        members[_member] = true;
    }

    // Core Function 2: Create a proposal
    function createProposal(string memory _description) public onlyMember {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: _description,
            voteCount: 0,
            executed: false,
            proposer: msg.sender
        });
        emit ProposalCreated(proposalCount, _description, msg.sender);
    }

    // Core Function 3: Vote on a proposal
    function vote(uint _proposalId) public onlyMember {
        require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal ID");
        require(!hasVoted[_proposalId][msg.sender], "You already voted");
        require(!proposals[_proposalId].executed, "Proposal already executed");

        hasVoted[_proposalId][msg.sender] = true;
        proposals[_proposalId].voteCount++;

        emit Voted(_proposalId, msg.sender);
    }

    // Core Function 4: Execute proposal (simple majority)
    function executeProposal(uint _proposalId) public onlyOwner {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCount > 0, "No votes cast");

        proposal.executed = true;
        emit ProposalExecuted(_proposalId);
    }
}

