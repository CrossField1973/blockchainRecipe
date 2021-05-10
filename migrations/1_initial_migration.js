const Migrations = artifacts.require("Migrations");
const PadlockToken = artifacts.require("PadlockToken");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(PadlockToken);
};
