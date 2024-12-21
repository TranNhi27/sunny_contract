require("dotenv").config();
const { ethers } = require("ethers");
const contractABI = require("../abis/SunnySide.json");

const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RPC_URL = process.env.RPC_URL;

if (!CONTRACT_ADDRESS || !PRIVATE_KEY || !RPC_URL) {
  throw new Error("❌ Missing required environment variables.");
}

const provider = new ethers.JsonRpcProvider(RPC_URL);
const ownerWallet = new ethers.Wallet(PRIVATE_KEY, provider);

const sunnySideActivity = new ethers.Contract(
  CONTRACT_ADDRESS,
  contractABI,
  ownerWallet
);

async function joinWithReferral(user, referrer) {
  console.log(`🔍 Preparing to join with referral...`);
  console.log(`➡️ User: ${user}`);
  console.log(`➡️ Referrer: ${referrer}`);

  try {
    // Call the joinWithReferral function
    const tx = await sunnySideActivity.joinWithReferral(user, referrer);
    console.log(`⏳ Transaction sent: ${tx.hash}`);

    // Wait for the transaction to be mined
    const receipt = await tx.wait();
    console.log(`✅ Transaction mined! Block: ${receipt.blockNumber}`);
    console.log(`🎉 User joined with referral successfully!`);

    return receipt;
  } catch (error) {
    console.error("❌ Error joining with referral:", error);
    throw error;
  }
}

// Example Usage
(async () => {
  const USER_ADDRESS = "0x5e5Af5dc3Cc3c93FA8347fA98eddc942162d0Cbf"; // User's address (Reffered)
  const REFERRER_ADDRESS = "0x306563D12A1ee361280884d8Cf68b14c0d34908b"; // Referrer's address
  try {
    const receipt = await joinWithReferral(USER_ADDRESS, REFERRER_ADDRESS);
    console.log(`🎉 Referral process completed successfully!`);
  } catch (error) {
    console.error("❌ Script failed:", error);
  }
})();
