import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import * as dotenv from "dotenv";
dotenv.config();

const ImplModule = buildModule("ImplModuleModule", (m) => {
  const master = m.contract("SunnysideMaster");
  const point = m.contract("PointManagement");
  const user = m.contract("UserManagement");

  return { master, point, user };
});

export default ImplModule;
