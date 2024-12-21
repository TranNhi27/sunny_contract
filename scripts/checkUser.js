require("dotenv").config();
const { ethers } = require("ethers");
const contractABI = require("../abis/SunnySide.json");

const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const RPC_URL = process.env.RPC_URL;

if (!CONTRACT_ADDRESS || !RPC_URL) {
  throw new Error("❌ Missing required environment variables.");
}

// Setup provider and contract
const provider = new ethers.JsonRpcProvider(RPC_URL);
const sunnySideActivity = new ethers.Contract(
  CONTRACT_ADDRESS,
  contractABI,
  provider
);

async function getContractDetails(user) {
  console.log(`🔍 Fetching details for user: ${user}`);

  try {
    // Call each getter function
    const isWhitelisted = await sunnySideActivity.isWhitelisted(user);
    const isReferred = await sunnySideActivity.isReferred(user);
    const totalPoints = await sunnySideActivity.getUserPoints(user);
    const dailyQuestPoints = await sunnySideActivity.getDailyQuestPoints(user);
    const activityPoints = await sunnySideActivity.getActivityPoints(user);

    // Log the results
    console.log("✅ User Details:");
    console.log(`➡️ Is Whitelisted: ${isWhitelisted}`);
    console.log(`➡️ Is Referred: ${isReferred}`);
    console.log(`➡️ Total Points: ${totalPoints}`);
    console.log(`➡️ Daily Quest Points: ${dailyQuestPoints}`);
    console.log(`➡️ Activity Points: ${activityPoints}`);
  } catch (error) {
    console.error("❌ Error fetching user details:", error);
  }
}

async function getActivityName(activityId) {
  try {
    const activityName = await sunnySideActivity.getActivityName(activityId);
    console.log(`➡️ Activity Name [ID: ${activityId}]: ${activityName}`);
    return activityName;
  } catch (error) {
    console.error(
      `❌ Error fetching activity name for ID ${activityId}:`,
      error
    );
  }
}

// Example Usage
(async () => {
  const USER_ADDRESS = "0x5e5Af5dc3Cc3c93FA8347fA98eddc942162d0Cbf"; // Replace with the user's address

  // Fetch user details
  await getContractDetails(USER_ADDRESS);

  // Fetch activity names (example IDs: 0, 1, 2, 3, 4)
  for (let i = 0; i <= 4; i++) {
    await getActivityName(i);
  }
})();
