require("dotenv").config();
const { ethers } = require("ethers");

const SUNNYSIDE_MASTER_ADDRESS = process.env.SUNNY_BEACON;
const RPC_URL = process.env.RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const USER_BEACON = process.env.USER_BEACON;
const POINT_BEACON = process.env.POINT_BEACON;

if (
  !SUNNYSIDE_MASTER_ADDRESS ||
  !RPC_URL ||
  !PRIVATE_KEY ||
  !USER_BEACON ||
  !POINT_BEACON
) {
  throw new Error("❌ Missing required environment variables.");
}

const provider = new ethers.JsonRpcProvider(RPC_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

const sunnysideMasterABI = [
  "function setManagementAddress(bytes32 id, address managementAddress) external",
  "event ManagementAddressUpdated(bytes32 indexed id, address indexed contractAddress)",
];

const sunnysideMaster = new ethers.Contract(
  SUNNYSIDE_MASTER_ADDRESS,
  sunnysideMasterABI,
  wallet
);

async function addManagementAddress(id, managementAddress) {
  console.log(`🔍 Adding management address...`);
  console.log(`➡️ ID: ${id}`);
  console.log(`➡️ Management Address: ${managementAddress}`);

  try {
    // Compute the keccak256 hash of the ID
    const idHash = ethers.keccak256(ethers.toUtf8Bytes(id));
    // Call the setManagementAddress function
    const tx = await sunnysideMaster.setManagementAddress(
      idHash,
      managementAddress
    );
    console.log(`⏳ Transaction sent: ${tx.hash}`);

    // Wait for the transaction to be mined
    const receipt = await tx.wait();
    console.log(`✅ Transaction mined in block ${receipt.blockNumber}`);

    // Parse the event log
    const event = receipt.events.find(
      (e) => e.event === "ManagementAddressUpdated"
    );
    if (event) {
      console.log(
        `🎉 Management address updated: ID=${event.args.id}, Address=${event.args.contractAddress}`
      );
    } else {
      console.log("❌ ManagementAddressUpdated event not found.");
    }
  } catch (error) {
    console.error("❌ Error adding management address:", error);
    throw error;
  }
}

(async () => {
  try {
    // console.log("🏗️ Adding UserManagement...");
    // await addManagementAddress("UserManagement", USER_BEACON);

    console.log("🏗️ Adding PointManagement...");
    await addManagementAddress("PointManagement", POINT_BEACON);

    console.log("🎉 All management addresses added successfully!");
  } catch (error) {
    console.error("❌ Script failed:", error);
  }
})();
