require("dotenv").config();
const { ethers } = require("ethers");
const sunnyFactoryABI = require("../abis/SunnyFactory.json");
const pointFactoryABI = require("../abis/PointFactory.json");
const userFactoryABI = require("../abis/UserFactory.json");

const SUNNY_FACTORY_ADDRESS = process.env.SUNNY_FACTORY_ADDRESS;
const POINT_FACTORY_ADDRESS = process.env.POINT_FACTORY_ADDRESS;
const USER_FACTORY_ADDRESS = process.env.USER_FACTORY_ADDRESS;

const RPC_URL = process.env.RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ACTIVITY_ADDRESS = process.env.ACTIVITY_ADDRESS;
const SUNNY_BEACON = "0x4a9E3a6f8Ef258ec2401F945Bb4390Bf2a09D127";
if (
  !SUNNY_FACTORY_ADDRESS ||
  !RPC_URL ||
  !POINT_FACTORY_ADDRESS ||
  !USER_FACTORY_ADDRESS ||
  !PRIVATE_KEY ||
  !ACTIVITY_ADDRESS
) {
  throw new Error("❌ Missing required environment variables.");
}

const provider = new ethers.JsonRpcProvider(RPC_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

// Factory Contracts
const sunnyFactory = new ethers.Contract(
  SUNNY_FACTORY_ADDRESS,
  sunnyFactoryABI,
  wallet
);

const userFactory = new ethers.Contract(
  USER_FACTORY_ADDRESS,
  userFactoryABI,
  wallet
);

const pointFactory = new ethers.Contract(
  POINT_FACTORY_ADDRESS,
  pointFactoryABI,
  wallet
);

async function createSunnyActivityContract() {
  console.log(`🔍 Preparing to create a new SunnySideActivity contract...`);
  const owner = await wallet.getAddress();

  console.log(`➡️ Factory Address: ${SUNNY_FACTORY_ADDRESS}`);
  console.log(`➡️ New Owner: ${owner}`);

  try {
    const tx = await sunnyFactory.createMasterContract(owner, ACTIVITY_ADDRESS);
    console.log(`⏳ Transaction sent: ${tx.hash}`);
    const receipt = await tx.wait();
    console.log("Receipt logs:", receipt.logs);

    const event = receipt.logs
      .map((log) => {
        try {
          return sunnyFactory.interface.parseLog(log);
        } catch (e) {
          return null;
        }
      })
      .find(
        (parsedLog) => parsedLog && parsedLog.name === "MasterContractCreated"
      );

    if (!event) {
      console.error("❌ MasterContractCreated event not found in logs.");
      return;
    }

    const newContractAddress = event.args.masterContract;
    console.log(
      `🎉 New SunnySideActivity contract created at: ${newContractAddress}`
    );

    return newContractAddress;
  } catch (error) {
    console.error("❌ Error creating SunnySideActivity contract:", error);
    throw error;
  }
}

async function createUserManagementContract() {
  console.log(`🔍 Preparing to create a new UserManagement contract...`);
  const owner = await wallet.getAddress();

  console.log(`➡️ Factory Address: ${USER_FACTORY_ADDRESS}`);
  console.log(`➡️ New Owner: ${owner}`);

  try {
    const tx = await userFactory.createUserManagementContract(SUNNY_BEACON);
    console.log(`⏳ Transaction sent: ${tx.hash}`);
    const receipt = await tx.wait();
    console.log("Receipt logs:", receipt.logs);

    const event = receipt.logs
      .map((log) => {
        try {
          return userFactory.interface.parseLog(log);
        } catch (e) {
          return null;
        }
      })
      .find(
        (parsedLog) =>
          parsedLog && parsedLog.name === "UserManagementContractCreated"
      );

    if (!event) {
      console.error(
        "❌ UserManagementContractCreated event not found in logs."
      );
      return;
    }

    const newContractAddress = event.args.userManagementContract;
    console.log(
      `🎉 New UserManagement contract created at: ${newContractAddress}`
    );

    return newContractAddress;
  } catch (error) {
    console.error("❌ Error creating UserManagement contract:", error);
    throw error;
  }
}

async function createPointManagementContract() {
  console.log(`🔍 Preparing to create a new PointManagement contract...`);
  const owner = await wallet.getAddress();

  console.log(`➡️ Factory Address: ${POINT_FACTORY_ADDRESS}`);
  console.log(`➡️ New Owner: ${owner}`);

  try {
    const tx = await pointFactory.createPointManagementContract(SUNNY_BEACON);
    console.log(`⏳ Transaction sent: ${tx.hash}`);
    const receipt = await tx.wait();
    console.log("Receipt logs:", receipt.logs);

    const event = receipt.logs
      .map((log) => {
        try {
          return pointFactory.interface.parseLog(log);
        } catch (e) {
          return null;
        }
      })
      .find(
        (parsedLog) =>
          parsedLog && parsedLog.name === "PointManagementContractCreated"
      );

    if (!event) {
      console.error(
        "❌ PointManagementContractCreated event not found in logs."
      );
      return;
    }

    const newContractAddress = event.args.pointManagementContract;
    console.log(
      `🎉 New PointManagement contract created at: ${newContractAddress}`
    );

    return newContractAddress;
  } catch (error) {
    console.error("❌ Error creating PointManagement contract:", error);
    throw error;
  }
}

(async () => {
  try {
    console.log(`🏗️ Starting contract creation...`);
    // const activityContract = await createSunnyActivityContract();
    // console.log(
    //   `🌞 SunnySideActivity contract created at: ${activityContract}`
    // );

    const userContract = await createUserManagementContract();
    console.log(`👤 UserManagement contract created at: ${userContract}`);

    const pointContract = await createPointManagementContract();
    console.log(`💎 PointManagement contract created at: ${pointContract}`);
  } catch (error) {
    console.error("❌ Script failed:", error);
  }
})();
