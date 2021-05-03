
# Padlock Token Project

# Overview
There are several steps that needs to be performed to run this program. 
These steps are explained in the following.
There also exist a video that performs these steps.

[Video Tutorial](https://youtu.be/4EiR-UCbqvY)

# Important Note
The project supplies also a **.devcontainer** subdirectory. It might be possible to run parts of this project in docker.
However, these steps were not tested by the initial project members.

# Installation processes

## Smart contract 
First step is to build the contract interface as both frontends  rely on it.
1. Install Python 3 and Node LTS on your system.
2. Clone this repository.
3. In the main repository directory, run `npm i` or `yarn` to install the dependencies.
4. Run `npm start` or `yarn start`.
5. Run `npm run migrate` or `yarn migrate` to compile the contract.

In case of errors with the **ganach-cli**:
A GUI version of [Ganache](https://www.trufflesuite.com/ganache) also can be
downloaded.

### Testing the contract
To test the contract in the process:  
Run `npm test` or `yarn test` to run the file [test/PadlockCreate.js](test/PadlockCreate.js)




#Frontends
After the contract is build the frontends can be setup.

1. Open a terminal in the project folder.
2. ( Run `npm i` to install the dependencies. )
3. Run `npm run locksite` for the **locksite** frontend.
4. Open a second terminal in the project folder.
5. Run `npm run chainsite` in the second terminal for the **chainsite** frontend.

### Connect to frontend in browser

1. [locksite](http://localhost:4000): Open http://localhost:4000/
2. [chainsite](http://localhost:8080): In a new Tab open Open http://localhost:8080/

# consumer steps to use our lock solution
The following steps have to be performed by the consumer to lock or unlock his assets with our solution:

First of all the user has to generate a PGP key pair. This will be used in the following.
Most of the cases, the key files can be found in the user space in the directory *.gnupg/*.

## Setup and lock
1. On the **locksite**: (http://localhost:4000/) paste in your public key content and press _Register Lock_.
2. When you get a successfully registered id, copy the random string above the public key field.
3. On the **chainsite**: (http://localhost:8080/) paste the copied id and submit.

The lock is now registered and locked.
The public key is registered with the lock id and the owner address. 

### Unlock the lock
To unlock the lock, enter a signed message on the **locksite**: (http://localhost:4000/) and submit.
The signed message can be build with the Cli programm included in this project.

1. Open a terminal in the project folder.
2. Run `npm run cli`
3. Follow the terminal instructions:  
    - Enter the complete path to the private key file. It probably can be found in the user space in the directory *.gnupg/*.  
    - Enter the passphrase for the key pair
4. The singed message will be printed out in the console. From there it can be copied.
5. Paste the copied message in the timestamp field on the [locksite](http://localhost:4000) website and hit submit.

To lock the lock again, press lock.   
To delete the registered Id press "Delete Id".
