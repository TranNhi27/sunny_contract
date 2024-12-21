import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
const { vars } = require("hardhat/config");
require("@nomicfoundation/hardhat-ethers");

const ATLANTIC_PRIVATE_KEY = vars.get("ATLANTIC_PRIVATE_KEY");

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    atlantic: {
      url: `https://evm-rpc-testnet.sei-apis.com`,
      accounts: [ATLANTIC_PRIVATE_KEY],
    },
    sei: {
      url: `https://evm-rpc.sei-apis.com`,
      accounts: [ATLANTIC_PRIVATE_KEY],
    },
  },
};

export default config;
