require("@nomiclabs/hardhat-ethers");


module.exports = {
  solidity: "0.8.18", // Specify the Solidity version
  networks: {
    hardhat: {
      // Local Hardhat Network configuration
    },
    localhost: {
      url: "http://127.0.0.1:8545", // Localhost configuration
      // accounts are automatically provided by Hardhat when using localhost
    },
  },
};

