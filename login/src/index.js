var bodyParser = require('body-parser');
var path = require('path');

import Web3 from "web3";
import PrescriptionToken from "../../bin/contracts/PrescriptionToken.json"; 

let generated_id = ""

const App = {
	web3: null,
	account: null,      // selected account to communicate with contract
	
	/**
	 * Function to setup connection to smart contract
	 */
	start: async function () {
	  const { web3 } = this;
  
	  try {
		const networkId = await web3.eth.net.getId();
		const deployedNetwork = PrescriptionToken.networks[networkId];
  
		// setup smart contract
		this.prescription = new web3.eth.Contract(
		  PrescriptionToken.abi,
		  deployedNetwork.address
		);
  
		// register selected account
		const accounts = await web3.eth.getAccounts();
		this.account = accounts[0];
		console.log("Choose account",this.account)

		// console.log("Choose account",this.account)
  
		// logging for Smart Contract RegisterKeyEvent
		// this.padLock.events.RegisterKeyEvent(console.log)
  
	  } catch (error) {
		console.error("Could not connect to contract or chain. ", error);
	  }
	},
  
	

	createDrug: async function() {
		const typ = document.getElementById("typ").value
		const adresse_arzt = document.getElementById("adresse_arzt").value
		const adresse_patient = document.getElementById("adresse_patient").value
		const medikament = document.getElementById("medikament").value
		const aggregat = document.getElementById("aggregat").value
		const menge = document.getElementById("menge").value

		generateID();

		const { mint } = this.prescription.methods;
		const tx = await mint(adresse_patient, adresse_arzt, generated_id, medikament, aggregat, menge, typ).send({ from: this.account })

		if (tx.status) {
			alert("Drug created")  
		} else {
			alert("Error")
		}
	},
};

window.App = App;
window.generateID = generateID;



window.addEventListener("load", function () {

	// if metamask is active
	if (window.ethereum) {
	  // use MetaMask's provider
	  	App.web3 = new Web3(window.ethereum);
	  	window.ethereum.enable(); // get permission to access accounts
	} else {
		App.web3 = new Web3(new Web3.providers.HttpProvider("127.0.0.1:7545"));
	  	alert("Cannot use metamask! Reload Page.")
	}
  
	// setup the smart contract connection
	App.start();
  
	// generate a new Lock ID
	
  
	// set up the html forms
	loadForm();
  });
  
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

	//document.getElementById(name_id_field).innerHTML = generated_id
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
