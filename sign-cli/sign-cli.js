const openpgp = require('openpgp');
const readline = require("readline");
const fs = require("fs");
const { exit } = require('process');
const { error } = require('console');

// Setup reader for console interface
const read_line = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});
let privateKeyRaw = ""

console.log('Willkommen beim automatisch Nachricht signier Programm');

read_line.question("please insert the complete path to your opgp private key: \n", function (path) {
    if (!fs.lstatSync(path).isFile()) {
        console.log("Wrong Path. Restart Programm")
        exit(1)
    }

    // open and read public key
    fs.readFile(path, "utf8", function (err, data) {
        if (err) {
            console.log(err);
            exit(1)
        }
        privateKeyRaw = data;

        read_line.question("Please insert your private passphrase: \t", function (passphrase) {
            encrypt_message(passphrase)
        })
    })
})


/**
 * signs message with the global "privateKeyRaw" and the passhphrase
 * @param {string} passphrase Passphrase to decrypt private key
 */
async function encrypt_message(passphrase) {

    // get timestamp
    const timeStamp = Date.now().toString()
    console.log("encrypting Timestamp: ", timeStamp)

    try {
        // parse private key
        const { keys: [privateKey] } = await openpgp.key.readArmored(privateKeyRaw);

        // decrypt private key
        if (!await privateKey.decrypt(passphrase)) {
            console.error("Cannot decrypt key. Please use correct Passphrase");
        }

        // sign timestamp-Message
        const { data: cleartext } = await openpgp.sign({
            message: openpgp.cleartext.fromText(timeStamp), // CleartextMessage or Message object
            privateKeys: [privateKey]                             // for signing
        });

        // printout message
        console.log("\n\nThe following is your signed message. Copy it in the singed message field")
        console.log(cleartext); // '-----BEGIN PGP SIGNED MESSAGE ... END PGP SIGNATURE-----'

        // exit program
        exit(0)
    } catch (error) {
        console.error(error)
    }
}