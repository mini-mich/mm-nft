/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require('hardhat-contract-sizer');
require("@nomiclabs/hardhat-etherscan");
const { API_URL, PRIVATE_KEY, ETHERSCAN_API_KEY,API_URL_RINKEBY} = process.env;
module.exports = {
   solidity: "0.8.2",
   optimizer: {
     enabled: true,
     runs: 200
   },
   defaultNetwork: "ropsten",
   networks: {
      hardhat: {},
      ropsten: {
         url: API_URL,
         accounts: [`0x${PRIVATE_KEY}`]
      },
      rinkeby: {
         url: API_URL_RINKEBY,
         accounts: [`0x${PRIVATE_KEY}`]
      }
   },
   etherscan: {
     apiKey: process.env.ETHERSCAN_API_KEY
   },
}



