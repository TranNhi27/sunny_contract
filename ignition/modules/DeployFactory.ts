import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import * as dotenv from "dotenv";
dotenv.config();

// Load environment variables
const SUNNY_IMPL_IMPLEMENTATION = process.env.SUNNY_IMPL_IMPLEMENTATION;
const POINT_IMPL_IMPLEMENTATION = process.env.POINT_IMPL_IMPLEMENTATION;
const USER_IMPL_IMPLEMENTATION = process.env.USER_IMPL_IMPLEMENTATION;

const FactoryModule = buildModule("FactoryModule", (m) => {
  // Load parameters
  const sunnyImplementation = m.getParameter(
    "initialImplementation",
    SUNNY_IMPL_IMPLEMENTATION
  );

  const userImplementation = m.getParameter(
    "initialImplementation",
    USER_IMPL_IMPLEMENTATION
  );

  const pointImplementation = m.getParameter(
    "initialImplementation",
    POINT_IMPL_IMPLEMENTATION
  );

  // Deploy the Factory contract
  const sunny_factory = m.contract("SunnysideMasterFactory", [
    sunnyImplementation,
  ]);

  const user_factory = m.contract("UserManagementFactory", [
    userImplementation,
  ]);

  const point_factory = m.contract("PointManagementFactory", [
    pointImplementation,
  ]);

  return { sunny_factory, point_factory, user_factory };
});

export default FactoryModule;
