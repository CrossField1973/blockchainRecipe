const Migrations = artifacts.require("Migrations");
const PrescriptionToken = artifacts.require("PrescriptionToken");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(PrescriptionToken);
};
