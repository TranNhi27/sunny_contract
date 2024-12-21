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

const Activity = {
  None: 0,
  ReferralBonus: 1,
  DailyLogin: 2,
  Fishing: 3,
  OpenChest: 4,
};

async function addPoints(user, activity, points) {
  console.log(`🔍 Preparing to add points...`);
  console.log(`➡️ User: ${user}`);
  console.log(`➡️ Points: ${points}`);

  try {
    // Call the addPoints function
    const tx = await sunnySideActivity.addPoints(user, activity, points);
    console.log(`⏳ Transaction sent: ${tx.hash}`);

    const receipt = await tx.wait();
    console.log(`✅ Transaction mined! Block: ${receipt.blockNumber}`);

    return receipt;
  } catch (error) {
    console.error("❌ Error adding points:", error);
    throw error;
  }
}

// Example Usage
(async () => {
  const USER_ADDRESS = "0x306563D12A1ee361280884d8Cf68b14c0d34908b"; // User's address
  const ACTIVITY = Activity.Fishing; // Enum value for "Fishing"
  const POINTS = 100; // Number of points

  try {
    const receipt = await addPoints(USER_ADDRESS, ACTIVITY, POINTS);
    console.log(`🎉 Points added successfully!`);
  } catch (error) {
    console.error("❌ Script failed:", error);
  }
})();
