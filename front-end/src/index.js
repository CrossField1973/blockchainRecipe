import Web3 from "web3";
import PadlockToken from "../../build/contracts/PadlockToken.json";     // import smart contract interface from build directory


const name_id_field = "id_field"
let generated_id = ""

/**
 * Object does communicate with web3 and smart contract.
 */
const App = {
  web3: null,
  account: null,      // selected account to communicate with contract
  padLock: null,      // smart contract interface

  /**
   * Function to setup connection to smart contract
   */
  start: async function () {
    const { web3 } = this;

    try {
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = PadlockToken.networks[networkId];

      // setup smart contract
      this.padLock = new web3.eth.Contract(
        PadlockToken.abi,
        deployedNetwork.address
      );

      // register selected account
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];

      // console.log("Choose account",this.account)

      // logging for Smart Contract RegisterKeyEvent
      // this.padLock.events.RegisterKeyEvent(console.log)

    } catch (error) {
      console.error("Could not connect to contract or chain. ", error);
    }
  },

  /**
   * Function to call the registerKey  function on the smart contract. Registeres a public key with the correct Lock-Id in the smart contract. 
   */
  registerLock: async function () {
    // console.log("Start registering lock for ID: ", generated_id)

    const pubk = document.getElementById("pubK_input").value
    const { registerKey } = this.padLock.methods;

    // call registerKey contract function
    const tx = await registerKey(pubk, generated_id).send({ from: this.account });

    // if successful
    if (tx.status) {
      alert("Lock registered")

      document.getElementById("pubK_input").value = "Public Key was registered!"

    } else {
      alert("Id is already in use.\nReload page and try again")
    }
  },

  /**
   * Function to call the transferKey function on the smart contract. Transfers a Lopck to a new owner by updating the saved address and public key.
   */
  transferLock: async function () {

    // setup values
    const pubk = document.getElementById("pubK_input").value
    const new_owner = document.getElementById("new_owner_adress").value
    const lock_id = document.getElementById("lock_id_register").value

    const { transferKey } = this.padLock.methods;

    // call transferKey contract function
    const tx = await transferKey(pubk, lock_id, new_owner).send({ from: this.account })

    // if successful
    if (tx.status) {
      alert("Lock transfered")

      // reload page
      location.reload()
    } else {
      alert("Cannot transfer ownership!")
    }
  }

};

// make the Variables available globally
window.App = App;
window.generateID = generateID;

// onload Setup function
window.addEventListener("load", function () {

  // if metamask is active
  if (window.ethereum) {
    // use MetaMask's provider
    App.web3 = new Web3(window.ethereum);
    window.ethereum.enable(); // get permission to access accounts
  } else {
    alert("Cannot use metamask! Reload Page.")
  }

  // setup the smart contract connection
  App.start();

  // generate a new Lock ID
  generateID();

  // set up the html forms
  loadForm();
});

/**
 * Get a random int between the mix and max value
 * @param {number} min the minimal value of the random value
 * @param {number} max the maximal value of the random value
 */
function getRndInteger(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

/**
 * Generate a random id and saves it in the global variable "generated_id" and sets it in the html document with dom "name_id_field"
 */
function generateID() {

  generated_id = ""

  for (let i = 0; i < 64; i++) {
    let n = 0;
    // exlude chars
    while (n == 0 || n == 34 || n == 39 || n == 47 || n == 60 || n == 62 || n == 92) {
      n = getRndInteger(33, 126);
    }

    generated_id += String.fromCharCode(n);

  }

  document.getElementById(name_id_field).innerHTML = generated_id
}


/**
 * Setup the html forms
 */
function loadForm() {
  // deactivate page refreshing on all forms
  const forms = document.getElementsByTagName("form");

  for (const f in forms) {
    if (forms.hasOwnProperty(f)) {
      const element = forms[f];

      element.addEventListener('submit', function (event) {
        event.preventDefault();
      });
    }
  }
}

function loggedIn(req, res, next) {
  if (req.isAuthenticated()) {
    next();
  } else {
    res.redirect('/index.html');
  }
}