import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import * as dotenv from "dotenv";
dotenv.config();

const CONTRACT_OWNER = process.env.CONTRACT_OWNER;

const ActivityModule = buildModule("ActivityModule", (m) => {
  const owner = CONTRACT_OWNER!;

  const activity = m.contract("ActivityManagement", [owner]);

  return { activity };
});

export default ActivityModule;
