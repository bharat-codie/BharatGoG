Core Function 1: Add new members to DAO
    function addMember(address _member) public onlyOwner {
        members[_member] = true;
    }

    Core Function 3: Vote on a proposal
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
// 
update
// 
