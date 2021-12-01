// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.10; // Last version

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/**
 * @title VotingCorrection
 * Date: 17-11-2021
 * @dev 1st challenge : Voting system
 */
contract VotingCorrection is Ownable {

    /*
    * Ordre de déclaration :
    * - structure
    * - énumération
    * - variable local
    * - événement
    * - "modifier"
    * - constructeur
    * - fonction
    */ 
    
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
   
    WorkflowStatus status = WorkflowStatus.RegisteringVoters;
   
    uint public winningProposalId; // id of the winning proposal
   
    mapping(address => Voter) public voters; // list of authorized persons
   
    Proposal[] public proposals; // list of proposals
   
    uint ProposalsRegistrationStart;
    uint ProposalsRegistrationEnd;
    uint VotingSessionStart;
    uint VotingSessionEnd;  
   
    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted(address voter, uint proposalId);
       
    /**
     * @dev authorize new voter
     * @param _voterAddress address of the voter to register
     */
    function registerVoters(address _voterAddress) public onlyOwner {
        require(status == WorkflowStatus.RegisteringVoters);
        require(!voters[_voterAddress].hasVoted, "This address is already registered !");
       
        voters[_voterAddress].isRegistered = true;
       
        emit VoterRegistered(_voterAddress);
    }
   
    /**
     * @dev start the proposal registration session
     */
    function proposalsRegistrationStart() public onlyOwner {
        require(status==WorkflowStatus.RegisteringVoters);
        status = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }
   
    /**
     * @dev the voters register their proposals
     * @param _voterAddress address of the voter who wants submit proposal
     * @param _description value of the proposal
     */
    function proposalRegister(address _voterAddress, string memory _description) public {
        require(status == WorkflowStatus.ProposalsRegistrationStarted);
        require(voters[_voterAddress].isRegistered);
        require(proposals.length < 10000);
        proposals.push(Proposal({
            description: _description,
            voteCount: 0
        }));
               
        emit ProposalRegistered(proposals.length);
    }
   
    /**
     * @dev stop the proposal registration session
     */
    function proposalsRegistrationEnd() public onlyOwner {
        require(status == WorkflowStatus.ProposalsRegistrationStarted);
        status = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }
   
    /**
     * @dev start the voting session
     */
    function votingSessionStart() public onlyOwner {
        require(status == WorkflowStatus.ProposalsRegistrationEnded);
        status = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }
   
    /**
     * @dev the voters can vote one time and define the winning proposal
     * @param _proposalId id of the proposal choose by the voter
     */
    function vote(uint _proposalId) public {
        require(status == WorkflowStatus.VotingSessionStarted);
        require(!voters[msg.sender].hasVoted, "Has already voted!");
       
        Voter storage sender = voters[msg.sender]; // variable d'état, donc à stocker dans le "storage"
           
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;
        proposals[_proposalId].voteCount += 1; // on comptabilise le vote
           
        if(proposals[_proposalId].voteCount > proposals[winningProposalId].voteCount) {
            winningProposalId = _proposalId;
        }
        
        emit Voted(msg.sender, _proposalId);
    }
   
    /**
     * @dev stop the voting session
     */
    function votingSessionEnd() public onlyOwner {
        require(status == WorkflowStatus.VotingSessionStarted);
        status = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }
   
    /**
     * @dev tally the votes
     */
    function votesTally() public onlyOwner {
        require(status == WorkflowStatus.VotingSessionEnded);
        status = WorkflowStatus.VotesTallied;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
    }
   
    /**
     * @dev returns the winning proposal
     * @return id of the winning proposal
     */
    function getWinner() public view returns(uint) {
        return  winningProposalId;
    }
}