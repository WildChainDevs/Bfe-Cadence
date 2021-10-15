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
  deployBfeNFTContract,
  mintBfeNFT,
  getNFTIds,
  getNFTMeta,
  checkCollectionReceiver
} from "./src/BfeNFT";
// Increase timeout if your tests failing due to timeout
jest.setTimeout(10000);

let testData = {
  "author": "goat",
  "text": "testText",
  "lang": "eng",
  "date": "2021-04-27 22:19:41",
  "retweet_count": "165",
  "favorite_count": "1442",
  "id_str": "1390376068733804545",
  "uri": "ipfs://Qmduj4VjKMMWRLwxcrHugxCTWD1cZ66iiKTeW2JGRZtY9u"
}

describe("BfeNFT", ()=>{
  beforeEach(async () => {
    const basePath = path.resolve(__dirname, "../"); 
		// You can specify different port to parallelize execution of describe blocks
    const port = 8081; 
		// Setting logging flag to true will pipe emulator output to console
    const logging = true;
    
    await init(basePath, { port, logging });
    return emulator.start(port);
  });
  
 // Stop emulator, so it could be restarted
  afterEach(async () => {
    return emulator.stop();
  });
  
  it("deploys BfeNFT contract", async () => {
    await deployBfeNFTContract()
  });

  it("mints a NFT", async () => {
    await deployBfeNFTContract()
		await shallPass(mintBfeNFT(testData, "BfeNFTAdmin"))
  });

  it("gets all NFT ids on account", async () => {
    await deployBfeNFTContract()
		const BfeNFTAdmin = await getAccountAddress("BfeNFTAdmin");
    await mintBfeNFT(testData, "BfeNFTAdmin")
    await mintBfeNFT(testData, "BfeNFTAdmin")
		const ids = await getNFTIds(BfeNFTAdmin)
    expect(ids).toEqual(expect.arrayContaining([1,2]))
  });

  it("gets metadata of specific NFT on account", async () => {
    await deployBfeNFTContract()
		const BfeNFTAdmin = await getAccountAddress("BfeNFTAdmin")
    await mintBfeNFT(testData, "BfeNFTAdmin")
		const meta = await getNFTMeta(BfeNFTAdmin,1)
    expect(meta).toEqual(expect.objectContaining(testData))
  });

  it("checks if NFT collection receiver exists", async () => {
    await deployBfeNFTContract()
		const BfeNFTAdmin = await getAccountAddress("BfeNFTAdmin")
    const res = await checkCollectionReceiver(BfeNFTAdmin)
    expect(res).toEqual(true)
  });

})
