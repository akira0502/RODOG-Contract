const RODOG = artifacts.require("RODOG");
const baseURL = "https://ipfs.io/ipfs/QmWwmRPdM9Jkyk7Em2zMUfRqVwcrZswGNCCycVbNfpnvxv/"

module.exports = function(deployer) {
  deployer.deploy(RODOG, baseURL);
};