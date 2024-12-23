require("dotenv").config();
const { ethers } = require("ethers");

// Load environment variables
const SUNNY_MASTER_ADDRESS = process.env.SUNNY_BEACON;
const USER_MANAGEMENT_ADDRESS = process.env.USER_BEACON;
const POINT_MANAGEMENT_ADDRESS = process.env.POINT_BEACON;
const RPC_URL = process.env.RPC_URL;

if (
  !SUNNY_MASTER_ADDRESS ||
  !USER_MANAGEMENT_ADDRESS ||
  !POINT_MANAGEMENT_ADDRESS ||
  !RPC_URL
) {
  throw new Error("❌ Missing required environment variables.");
}

// Load ABIs
const sunnyMasterABI = require("../abis/SunnySide.json");
const userManagementABI = require("../abis/UserManagement.json");
const pointManagementABI = require("../abis/PointManagement.json");

// Setup provider and contracts
const provider = new ethers.JsonRpcProvider(RPC_URL);

const sunnyMaster = new ethers.Contract(
  SUNNY_MASTER_ADDRESS,
  sunnyMasterABI,
  provider
);
const userManagement = new ethers.Contract(
  USER_MANAGEMENT_ADDRESS,
  userManagementABI,
  provider
);
const pointManagement = new ethers.Contract(
  POINT_MANAGEMENT_ADDRESS,
  pointManagementABI,
  provider
);

// Function to fetch details from UserManagement contract
async function getUserDetails(user) {
  console.log(`🔍 Fetching user details from UserManagement for: ${user}`);

  try {
    const isWhitelisted = await userManagement.isWhitelisted(user);
    console.log("✅ User Details:");
    console.log(`➡️ Is Whitelisted: ${isWhitelisted}`);
  } catch (error) {
    console.error("❌ Error fetching user details:", error);
  }
}

// Function to fetch points details from PointManagement contract
async function getUserPoints(user) {
  console.log(`🔍 Fetching user points from PointManagement for: ${user}`);

  try {
    const totalPoints = await pointManagement.getUserPoints(user);
    const dailyQuestPoints = await pointManagement.getDailyQuestPoints(user);
    const activityPoints = await pointManagement.getActivityPoints(user);

    console.log("✅ User Points:");
    console.log(`➡️ Total Points: ${totalPoints}`);
    console.log(`➡️ Daily Quest Points: ${dailyQuestPoints}`);
    console.log(`➡️ Activity Points: ${activityPoints}`);
  } catch (error) {
    console.error("❌ Error fetching user points:", error);
  }
}

// Example Usage
(async () => {
  const USER_ADDRESS = "0x306563D12A1ee361280884d8Cf68b14c0d34908b"; // Replace with the user's address

  // Fetch details from UserManagement contract
  await getUserDetails(USER_ADDRESS);

  // Fetch points details from PointManagement contract
  await getUserPoints(USER_ADDRESS);
})();
