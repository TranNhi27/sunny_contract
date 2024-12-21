import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import * as dotenv from "dotenv";
dotenv.config();

const SunnyActivityModule = buildModule("SunnyActivityModule", (m) => {
  const activity = m.contract("SunnySideActivity");

  return { activity };
});

export default SunnyActivityModule;
