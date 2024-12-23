require("dotenv").config();
const { ethers } = require("ethers");
const userABI = require("../abis/UserManagement.json");

const USER_BEACON = process.env.USER_BEACON;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RPC_URL = process.env.RPC_URL;

if (!USER_BEACON || !PRIVATE_KEY || !RPC_URL) {
  throw new Error("❌ Missing required environment variables.");
}

const provider = new ethers.JsonRpcProvider(RPC_URL);
const ownerWallet = new ethers.Wallet(PRIVATE_KEY, provider);

const userManagement = new ethers.Contract(USER_BEACON, userABI, ownerWallet);

async function addToWhitelist(user) {
  console.log(`🔍 Preparing to whitelist user...`);
  console.log(`➡️ User: ${user}`);

  try {
    // Call the addToWhitelist function
    const tx = await userManagement.addToWhitelist(user);
    console.log(`⏳ Transaction sent: ${tx.hash}`);

    // Wait for the transaction to be mined
    const receipt = await tx.wait();
    console.log(`✅ Transaction mined! Block: ${receipt.blockNumber}`);

    return receipt;
  } catch (error) {
    console.error("❌ Error whitelisting user:", error);
    throw error;
  }
}

// Example Usage
(async () => {
  const USER_ADDRESS = "0x306563D12A1ee361280884d8Cf68b14c0d34908b";

  try {
    const receipt = await addToWhitelist(USER_ADDRESS);
    console.log(`🎉 User whitelisted successfully!`);
  } catch (error) {
    console.error("❌ Script failed:", error);
  }
})();
