const Migrations = artifacts.require("Migrations");
const PadlockToken = artifacts.require("PrescriptionToken");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(PrescriptionToken);
};
