import path from "path";
import { 
  emulator, 
  init, 
  executeScript,
  getAccountAddress,
  mintFlow, 
  sendTransaction,
  shallPass
} from "flow-js-testing";
import {
  deployFUSDContract,
  createFUSDVault,
  getFUSDBalance,
  fundAccountWithFUSD
} from "./src/FUSD";
// Increase timeout if your tests failing due to timeout
jest.setTimeout(10000);

describe("FUSD", ()=>{
  beforeEach(async () => {
    const basePath = path.resolve(__dirname, "../"); 
		// You can specify different port to parallelize execution of describe blocks
    const port = 8080; 
		// Setting logging flag to true will pipe emulator output to console
    const logging = true;
    
    await init(basePath, { port, logging });
    return emulator.start(port);
  });
  
 // Stop emulator, so it could be restarted
  afterEach(async () => {
    return emulator.stop();
  });
  
  it("deploys FUSD contract", async () => {
    await deployFUSDContract();
  });

  it("should create FUSD vault", async () => {
    await deployFUSDContract();
    const recipient = await getAccountAddress("FUSDAdmin")
    await createFUSDVault(recipient);
    const balance = await getFUSDBalance(recipient)
    expect(balance).toBe("0.00000000")
  });

  it("Should mint FUSD", async () => {
    await deployFUSDContract();
    const admin = await getAccountAddress("FUSDAdmin")
    const recipient = await getAccountAddress("FUSDAdmin")
    const balance = await fundAccountWithFUSD(admin, recipient, "100.00")
    expect(balance).toBe("100.00000000")
  });
})
