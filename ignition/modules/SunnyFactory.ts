import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import * as dotenv from "dotenv";
dotenv.config();

// Load environment variables
const INITIAL_IMPLEMENTATION = process.env.INITIAL_IMPLEMENTATION;

const SunnySideModule = buildModule("SunnySideModule", (m) => {
  // Load parameters
  const initialImplementation = m.getParameter(
    "initialImplementation",
    INITIAL_IMPLEMENTATION
  );

  // Deploy the Factory contract
  const factory = m.contract("SunnySideActivityFactory", [
    initialImplementation,
  ]);

  return { factory };
});

export default SunnySideModule;
