// Allows us to use ES6 in our migrations and tests.
require("babel-register");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      host: "localhost",
      port: 8545,
      network_id: "4", // Rinkeby network id
      from: "0x59ec72026e0259bb726940ef7ee29290fb4cc166",
      gas: 860000
    }
  }
};
