/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require('hardhat-contract-sizer');
require("@nomiclabs/hardhat-etherscan");
const { API_URL_MAINNET, API_URL_ROPSTEN, PRIVATE_KEY, ETHERSCAN_API_KEY, API_URL_RINKEBY } = process.env;
module.exports = {
   solidity: {
      version: "0.8.2",
      settings: {
         optimizer: {
            enabled: true,
            runs: 500
         }
      }
   },
   defaultNetwork: "ropsten",
   networks: {
      hardhat: {},
      ropsten: {
         url: API_URL_ROPSTEN,
         accounts: [`0x${PRIVATE_KEY}`]
      },
      rinkeby: {
         url: API_URL_RINKEBY,
         accounts: [`0x${PRIVATE_KEY}`]
      },
      mainnet: {
         url: API_URL_MAINNET,
         accounts: [`0x${PRIVATE_KEY}`]
      }
   },
   etherscan: {
      apiKey: process.env.ETHERSCAN_API_KEY
   },
}



