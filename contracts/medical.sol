pragma solidity ^0.7.0;

contract PadlockToken {

    // Lock struct to save values
    struct Lock {
        string pubk;
        address owner;

        string tempPubk;
        uint256 expDate;
    }

    // event to fire for debugging for the registerKey functiond

    // event RegisterKeyEvent(
    //     string pubk,
    //     string lock_id
    // );
    
    // saves all locks, maps from the lock_id to the Lock
    mapping(string => Lock) public _ownerTable;

    constructor() {}


    function name() public pure returns (string memory) {
        return "Medical";
    }
    function symbol() public pure returns (string memory) {
        return "Medical";
    }

    /*
    * Function to register a public key for a given lock id
    * Creates a new Lock in the global mapping
    */
    function registerKey(string memory owner_public_key, string memory lock_id) public returns (bool){

        // save new Lock
        _ownerTable[lock_id] = Lock(owner_public_key,msg.sender,"",0);

        // check if registering was successful
        require((bytes(_ownerTable[lock_id].pubk).length != 0), "Couldn't register id.");

        // emit RegisterKeyEvent(owner_public_key,lock_id);

        return true;
    }

    /*
    * Returns public key of the owner according to the lock_id
     */
    function getOwnerKey(string memory lock_id) public view returns (string memory) {

        // get public key
        string memory pubk=_ownerTable[lock_id].pubk;

        // if result is empty
        require(bytes(pubk).length != 0,"Could not find lock_id ");
        return pubk;
    }

    /*
    * Transfers Lock to a new owner by overwriting the registered owner address and the public key
    *
     */
    function transferKey(string memory pub_key_new_owner, string memory lock_id, address new_owner) public returns (bool) {

        // check that old owner calls transfer        
        require(msg.sender==_ownerTable[lock_id].owner,"You are not authorised for that action.");

        // register new Owner on lock
        _ownerTable[lock_id]=Lock(pub_key_new_owner,new_owner,"",0);

        return true;
    }


    /*
    * Registers secundary temporary owner for the given lock by the id. 
    * This will add the public key and a timeStamp until the public key is valid to unlock the lock
     */
    function lendKey(string memory pub_key_temp_owner, string memory lock_id, uint256 expiration_date) public returns (bool) {
        
        // check that old owner calls transfer        
        require(msg.sender==_ownerTable[lock_id].owner,"You are not authorised for that action.");

        // get Lock
        Lock memory lock=_ownerTable[lock_id];

        // verifies correct Lock has been found
        require(bytes(lock.pubk).length != 0,"Could not find lock_id ");

        // add temporary data to Lock
        _ownerTable[lock_id].tempPubk=pub_key_temp_owner;
        _ownerTable[lock_id].expDate=expiration_date;

        return true;
    }

    /*
    * returns the saved temporary key of the given Lock id
    * second parameter should be TimeStamp of now
     */
    function getTemporaryKey(string memory lock_id,uint256 timeStamp_now) public view returns (string memory) {

        Lock memory lock=_ownerTable[lock_id];
        
        // lock exists and temporary owner registered
        require(bytes(lock.tempPubk).length != 0,"Could not find lock_id ");

        // Timestamp still valid
        require(timeStamp_now<lock.expDate,"You are no longer authorised to use that lock.");

        return lock.tempPubk;
    }























    // // mapping(uint256 => Lock) private _locks;
    // uint256 private _lockCount;
    // mapping(uint256 => bool) public _keychain;



    // function getLockCount() public view returns (uint256) {
    //     return _lockCount;
    // }
        // _lockCount=0;

    // function includes(uint256 key) private returns (bool) {
    //     return _keychain[key];
    // }

    // function createToken(uint256 lock_id, address owner) public returns (bool) {

    //     // check lock_id new
    //     require(!includes(lock_id), "LockId is already in use");

    //     //Create new Lock
    //     Lock memory newLock = Lock(
    //         // set text-name as some weird bytes
    //         string(abi.encodePacked(lock_id)),
    //         // set lock id
    //         lock_id,
    //         // set sender as owner
    //         owner,
    //         // set some meta string
    //         "hello World!"
    //     );

    //     // assosiate padlock with wallet
    //     _keychain[newLock.id]=true;
    //     _lockCount = _lockCount+1;

    //     _locks[lock_id]=newLock;
    //     //_private_keychain[]
    //     return true;
    // }
}
