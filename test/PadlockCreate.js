const PadlockToken = artifacts.require("PadlockToken");

contract("PadlockToken", (accounts) => {

  // setup accounts
  const alice = accounts[0];
  const bob = accounts[1];
  const carol = accounts[2];
  const daniel = accounts[3];

  // setup test data, can be modified
  const lock_id = "awdwadwadwadwadawdwa";
  const pubk = "pubKadawdawd";

  let newPadlock;
  let instance;

  beforeEach(async () => {
    instance = await PadlockToken.deployed();
  });

  /**
   * Important:
   *  If no client address is used. The first account of alice is beeing used
   */


  /**
   * Registers Public key for a new Lock for alice
   */
  it("Register Key", async () => {
    const tx = await instance.registerKey(pubk, lock_id);

    assert.equal(tx.receipt.status, true, "Returns status successfull");
  });

  /**
   * Gets the registered Public key for the new lock 
   */
  it("Get Owner Key", async () => {

    // check saved public key in contract table
    const lock = await instance._ownerTable(lock_id)
    assert.equal(pubk, lock.pubk, "Should save correct public key");

    // get public key by function
    const registered_pubk = await instance.getOwnerKey(lock_id);
    assert.equal(registered_pubk, pubk, "Returns correct pubkey");

    // try getting key for NON existing lock. Should throw error. Asserst Error message
    try {
      const shall_not_pubK = await instance.getOwnerKey("NOT_EXISTING_ID");
    } catch (error) {
      const error_msg_should = "-Returned error: VM Exception while processing transaction: revert Could not find lock_id"
      assert.equal(error.message, error_msg_should, "Shoudl throw error as alice is not authorised");
    }
  });

  /**
   * Transfer locks to other owner
   */
  it("Transfer Key", async () => {

    // alice transfers lock to bob
    const tx = await instance.transferKey(pubk, lock_id, bob);

    // check successful
    assert.equal(tx.receipt.status, true, "Transfer lock to bob successfull");

    // alice tries to transfer lock to herself again, but is not owner anymore => error
    // asserst error message
    try {
      const ftx = await instance.transferKey(pubk, lock_id, alice);
    } catch (error) {
      const error_msg_should = "Returned error: VM Exception while processing transaction: revert You are not authorised for that action. -- Reason given: You are not authorised for that action.."
      assert.equal(error.message, error_msg_should, "Shoudl throw error as alice is not authorised");

    }

    // check if bob is registered as owner in the contract
    const lock = await instance._ownerTable(lock_id);
    assert.equal(bob, lock.owner, "Should show bob as new owner");

  });

  /**
   * Lends lock to other owner
   */
  it("Lend Key", async () => {
    /**
     * Important: Bob owns lock and lends it to alice
     */

    // secondary public key and timestamp
    const tmpPubK = "otherPubk";
    const timeStampExpiary = Date.now().toString()

    // register secondary public key from BOB (as he is still the owner)
    const tx = await instance.lendKey(tmpPubK, lock_id, timeStampExpiary, { from: bob })
    assert.equal(tx.receipt.status, true, "Shoudl register temporal key");

    // check for correct registered secondary key and correct temporary owner
    const lock = await instance._ownerTable(lock_id);
    assert.equal(tmpPubK, lock.tempPubk, "Should save correct temporary public key");
    assert.equal(timeStampExpiary, lock.expDate, "Should save correct timestamp for exirpation date");

    // get the temorary key and verifies it. Uses still active timestamp
    const savedTmpKey = await instance.getTemporaryKey(lock_id, timeStampExpiary - 1)
    assert.equal(tmpPubK, savedTmpKey, "Should return correct temporary public key");

    // tries to get temporary key with expired key
    // Assert error message
    try {
      const savedTmpKey = await instance.getTemporaryKey(lock_id, timeStampExpiary + 1)
    } catch (error) {
      const error_msg_should = "Returned error: VM Exception while processing transaction: revert You are no longer authorised to use that lock."
      assert.equal(error.message, error_msg_should, "Shoudl throw error as timestamp is run out");
    }
  });
});