const { expectRevert } = require("@openzeppelin/test-helpers");
const { inTransaction } = require("@openzeppelin/test-helpers/src/expectEvent");
const { assertion } = require("@openzeppelin/test-helpers/src/expectRevert");

const Voting = artifacts.require("Voting");

/**
 * @title Voting (tests)
 * Date: 30-11-2021
 * @dev 2nd challenge : Voting system (tests)
 *
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Voting", function (accounts) {
  const owner = accounts[0];
  const account_1 = accounts[1];
  const account_2 = accounts[2];
  
  const _status = '0';
  const description = "description de la proposition";

  beforeEach(async function () {
    this.Voting = await Voting.new({from: owner});
  });

  /**
   * 1. Vérifier le statut initial
   */
  it('vérifie le statut initial', async function () {
    let initialStatus = await this.Voting.status();

    assert.equal(initialStatus.toNumber(), 0);
  })

  /**
   * 2. Vérifier le changement de statut
   */
  it("vérifie le changement de statut", async function () {
    let previousStatus = await this.Voting.status();
    
    await this.Voting.proposalsRegistrationStart({from: owner});

    let newStatus = await this.Voting.status();

    assert.equal(newStatus.toNumber(), previousStatus.toNumber()+1);
  });

  /**
   * 3. Vérifier qu'un votant n'a pas déjà voté
   */
   it("vérifie qu'un votant qui s'enregistre n'a pas déjà voté", async function () {
    await this.Voting.registerVoters(account_1);
    
    let voter = await this.Voting.voters(account_1);
    let voterHasVoted = voter.hasVoted;
    
    assert.ok(!voterHasVoted);
  });

  /**
   * 4. Vérifier que la description de la proposition est bien enregistrée
   */
  it("vérifie que la description de la proposition est bien enregistrée", async function () {
    await this.Voting.registerVoters(account_1);
    await this.Voting.proposalsRegistrationStart();
    await this.Voting.proposalRegister(account_1, description);

    let proposal = await this.Voting.proposals(0);
    
    assert.equal(proposal.description, description);
  });

  /**
   * 5. Vérifier qu'un vote est bien pris en compte
   */
   it("vérifie qu'un vote est bien pris en compte", async function () {
    await this.Voting.registerVoters(account_1);
    await this.Voting.proposalsRegistrationStart();
    await this.Voting.proposalRegister(account_1, description); 
    await this.Voting.proposalsRegistrationEnd();
    await this.Voting.votingSessionStart();
    await this.Voting.vote(0);

    let proposal = await this.Voting.proposals(0);
    
    assert.equal(proposal.voteCount.words[0], 1);
  });

  /**
   * Autres tests possibles :
   * - Vérifier qu'un votant n'est pas déjà enregistré
   * - Vérifier que seul l'administrateur peut enregistrer des votants
   * - Vérifier qu'il y a bien une proposition gagnante
   */

});

