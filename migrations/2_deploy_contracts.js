var fixedSupplyToken = artifacts.require("./FixedSupplyToken.sol");

module.exports = function(deployer) {
  deployer.deploy(fixedSupplyToken);
};
