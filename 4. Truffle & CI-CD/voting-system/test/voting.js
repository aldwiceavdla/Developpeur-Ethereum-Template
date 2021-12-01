const { expectRevert } = require("@openzeppelin/test-helpers");
const { inTransaction } = require("@openzeppelin/test-helpers/src/expectEvent");
const { assertion } = require("@openzeppelin/test-helpers/src/expectRevert");

const Voting = artifacts.require("Voting");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Voting", function (accounts) {
  const owner = accounts[0];
  const _status = '0';

  beforeEach(async function () {
    this.Voting = await Voting.new({from: owner});
  });
/*
  it("vérifie le statut initial", async function () {    
    expect(await this.Voting.proposalsRegistrationStart()).to.equal(_status);
  });
*/
  it("vérifie le changement de statut", async function () {
    let previousStatus = this.Voting.proposalsRegistrationStart().status;
    
    await this.Voting.proposalsRegistrationStart();

    let newStatus = this.Voting.WorkflowStatus();

    assert.NotEqual(newStatus, previousStatus);
  });
/*
  it("vérifie que seul l'administrateur peut enregistrer des votants", async function () {
    
  });

  it("vérifie qu'une proposition ne peut être proposée que par une adresse enregistrée", async function () {
    
  });

  it("vérifie qu'un votant n'a pas déjà voté", async function () {
    
  });

  it("vérifie qu'il y a une proposition gagnante", async function () {
    
  });

  it("test", async function () {
    
  });
/* 
  it("Admin", async function() {
    let status = await this.Voting.getWinner();

    expect(status).to.equal('0');
    
    //await expectRevert(this.Voting.proposalsRegistrationStart, "RegisteringVoters");
  });
*/
/*
  it("vérifie le statut initial", async function () {
    expect((await this.Voting.winningProposalId()).toString()).to.equal('0');
  });
*/ 
/*
  it("Initial WorkflowStatus is RegisteringVoters", async function () {
    let WorkflowStatus = await this.Voting.registerVoters(owner).status;

    expect(WorkflowStatus).to.be.equal("RegisteringVoters");
  });
*/
/*
  it("WorkflowStatus has changed", async function () {
    await this.Voting.proposalsRegistrationEnd();


    expect((await this.Voting.winningProposalId()).toString()).to.equal(Voting.WorkflowStatus.ProposalsRegistrationStarted.toString());
  });
*/
/*
  it("should assert true", async function () {
    await Voting.deployed();
    return assert.isTrue(true);
  });
*/
  


});

