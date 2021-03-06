const fixedSupplyToken = artifacts.require("./FixedSupplyToken.sol");
const exchangeContract = artifacts.require("./Exchange.sol");
const assert = require("assert");

contract("FixedSupplyToken", function(accounts) {
  it("first account should own all tokens", () => {
    var totalSupplyToken;
    var myTokenInstance;
    return fixedSupplyToken
      .deployed()
      .then(function(instance) {
        myTokenInstance = instance;
        return myTokenInstance.totalSupply.call();
      })
      .then(function(totalSupply) {
        _totalSupply = totalSupply;
        return myTokenInstance.balanceOf(accounts[0]);
      })
      .then(function(balanceAccountOwner) {
        assert.equal(
          balanceAccountOwner.toNumber(),
          _totalSupply.toNumber(),
          "total amount of tokens owned by owner"
        );
      });
  });
  it("second account should get no initial tokens", async () => {
    var myTokenInstance = await fixedSupplyToken.deployed();
    var tokenBalance1 = await myTokenInstance.balanceOf(accounts[1]);
    assert.equal(
      tokenBalance1.toNumber(),
      0,
      "total amount of tokens in account two"
    );
  });
  it("should send tokens from one account to another", async () => {
    var token = await fixedSupplyToken.deployed();
    var account1Start = await token.balanceOf.call(accounts[0]);
    var account2Start = await token.balanceOf.call(accounts[1]);
    await token.transfer(accounts[1], 10, { from: accounts[0] });
    var account1End = await token.balanceOf.call(accounts[0]);
    var account2End = await token.balanceOf.call(accounts[1]);
    assert.equal(
      account1End.toNumber(),
      account1Start.toNumber() - 10,
      "Amount was not taken correctly from sender"
    );
    assert.equal(
      account2End.toNumber(),
      account2Start.toNumber() + 10,
      "Amount was not recieved correctly by reciver"
    );
  });
  it("Exchange should be able to add tokens", async () => {
    var token = await fixedSupplyToken.deployed();
    var exchange = await exchangeContract.deployed();
    await exchange.addToken("FIX", token.address);
    var hasToken = await exchange.hasToken.call("FIX");
    var nonExistantToken = await exchange.hasToken.call("NoneExistant");
    assert.equal(hasToken, true, "The token was not added");
    assert.equal(nonExistantToken, false, "None exisitant token exists");
  });
  it("Exchange should be able to deposit tokens", async () => {
    var token = await fixedSupplyToken.deployed();
    var exchange = await exchangeContract.deployed();
    await token.approve(exchange.address, 2000);
    await exchange.addToken("FIXED", token.address)
    await exchange.depositToken("FIXED", 2000);
    var balance = await exchange.getBalance("FIXED");
    assert.equal(balance, 2000, "Should deposit 2000 tokens into address");
  });
});
