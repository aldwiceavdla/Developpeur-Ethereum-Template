// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.10; // Last version

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
/**
 * @title Voting
 * Date: 16-11-2021
 * @dev 1st challenge : Voting system
 */
contract Voting is Ownable {
    
    uint public winningProposalId; // id of the winning proposal
    
    mapping(address => Voter) public voters; // list of authorized persons
    
    Proposal[] public proposals; // list of proposals
    
    uint ProposalsRegistrationStart;
    uint ProposalsRegistrationEnd;
    uint VotingSessionStart;
    uint VotingSessionEnd;
    
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }
    
    struct Proposal {
        string description;
        uint voteCount;
    }
    
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    
    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted(address voter, uint proposalId);
    
    /**
     * @dev returns the winning proposal
     * @return id of the winning proposal
     */
    function getWinner() public returns(uint){
        return winningProposalId = votesTally();
    }
    
    /**
     * @dev authorize new voter
     * @param _voterAddress address of the voter to register
     */ 
    function registerVoters(address _voterAddress) public onlyOwner {
        require(!voters[_voterAddress].hasVoted, "This address is already registered !");
        voters[_voterAddress].isRegistered = true;
        emit VoterRegistered(_voterAddress);
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.RegisteringVoters);
    }
    
    /**
     * @dev start the proposal registration session
     */ 
    function proposalsRegistrationStart() public onlyOwner {
        ProposalsRegistrationStart = block.timestamp;
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }
    
    /**
     * @dev the voters register their proposals
     * @param _voterAddress address of the voter who wants submit proposal
     * @param _description value of the proposal
     */ 
    function proposalRegister(address _voterAddress, string memory _description) public {
        // l'enregistrement n'est possible que pdt la session d'enregistrement
        if (ProposalsRegistrationStart < block.timestamp && block.timestamp < ProposalsRegistrationEnd) {
            // seul un électeur enregistré peut soumettre une propositon
            if(voters[_voterAddress].isRegistered = true) {
                proposals.push(Proposal({
                    description: _description,
                    voteCount: 0
                }));
                emit ProposalRegistered(proposals.length);
            }
        }
    }
    
    /**
     * @dev stop the proposal registration session
     */ 
    function proposalsRegistrationEnd() public onlyOwner {
        ProposalsRegistrationEnd = block.timestamp;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }
    
    /**
     * @dev start the voting session
     */ 
    function votingSessionStart() public onlyOwner {
        VotingSessionStart = block.timestamp;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    } 
    
    /**
     * @dev the voters can vote one time
     * @param _proposalId id of the proposal choose by the voter
     */ 
    function vote(uint _proposalId) public {
        // le vote n'est possible que pdt la session de vote
        if (VotingSessionStart < block.timestamp && block.timestamp < VotingSessionEnd) {
            Voter storage sender = voters[msg.sender]; // variable d'état, donc à stocker dans le "storage"
            require(!sender.hasVoted, "Has already voted!");
            sender.hasVoted = true;
            sender.votedProposalId = _proposalId;
            proposals[_proposalId].voteCount += 1; // on comptabilise le vote
            emit Voted(msg.sender, _proposalId);
        }
    }
    
    /**
     * @dev stop the voting session
     */ 
    function votingSessionEnd() public onlyOwner {
        VotingSessionEnd = block.timestamp;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }
    
    /**
     * @dev tally the votes and get the winner proposal
     * @return _winner id of the proposal which get the most of votes
     */
    function votesTally() public onlyOwner returns (uint _winner) {
        uint winnerVoteCount = 0;
        // boucle pour récupérer la propositon avec le plus de votes
        for (uint i = 0; i < proposals.length; i++) {
            if(proposals[i].voteCount > winnerVoteCount) {
                winnerVoteCount = proposals[i].voteCount;
                _winner = i;
            }
        }
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
    }
    
}