require("dotenv").config();
const { ethers } = require("ethers");
const factoryABI = require("../abis/SunnyFactory.json");

const FACTORY_ADDRESS = process.env.FACTORY_ADDRESS;
const RPC_URL = process.env.RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

if (!FACTORY_ADDRESS || !RPC_URL || !PRIVATE_KEY) {
  throw new Error("❌ Missing required environment variables.");
}

const provider = new ethers.JsonRpcProvider(RPC_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

// SunnySideActivityFactory contract
const factoryContract = new ethers.Contract(
  FACTORY_ADDRESS,
  factoryABI,
  wallet
);

async function createActivityContract() {
  console.log(`🔍 Preparing to create a new SunnySideActivity contract...`);
  console.log(`➡️ Factory Address: ${FACTORY_ADDRESS}`);
  const owner = await wallet.getAddress();

  console.log(`➡️ New Owner: ${owner}`);

  try {
    // Call the createActivityContract method
    const tx = await factoryContract.createActivityContract(owner);
    console.log(`⏳ Transaction sent: ${tx.hash}`);

    // Wait for the transaction to be mined
    const receipt = await tx.wait();
    console.log("Receipt logs:", receipt.logs);

    // Parse the event from the receipt logs
    const event = receipt.logs
      .map((log) => {
        try {
          return factoryContract.interface.parseLog(log);
        } catch (e) {
          return null;
        }
      })
      .find(
        (parsedLog) => parsedLog && parsedLog.name === "ActivityContractCreated"
      );

    if (!event) {
      console.error("❌ ActivityContractCreated event not found in logs.");
      return;
    }

    const newContractAddress = event.args.activityContract;
    console.log(
      `🎉 New SunnySideActivity contract created at: ${newContractAddress}`
    );

    return newContractAddress;
  } catch (error) {
    console.error("❌ Error creating activity contract:", error);
    throw error;
  }
}

(async () => {
  try {
    const newContractAddress = await createActivityContract();
    console.log(
      `🏗️ Activity contract successfully created at: ${newContractAddress}`
    );
  } catch (error) {
    console.error("❌ Script failed:", error);
  }
})();
