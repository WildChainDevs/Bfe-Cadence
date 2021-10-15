import path from "path";
import * as sdk from "@onflow/sdk";
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
  deployNFTStorefrontContract,
  sellBfeNFT,
  buyBfeNFT,
  setupAccount,
  checkStorefront
} from "./src/NFTStorefront";
import {
  mintBfeNFT,
  checkCollectionReceiver,
  getNFTIds
} from "./src/BfeNFT";
import {
  createFUSDVault,
  fundAccountWithFUSD,
  getFUSDBalance
} from "./src/FUSD";
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

describe("NFTStorefront", ()=>{
  beforeEach(async () => {
    const basePath = path.resolve(__dirname, "../"); 
		// You can specify different port to parallelize execution of describe blocks
    const port = 8082; 
		// Setting logging flag to true will pipe emulator output to console
    const logging = true;
    
    await init(basePath, { port, logging });
    return emulator.start(port);
  });
  
 // Stop emulator, so it could be restarted
  afterEach(async () => {
    return emulator.stop();
  });

  it("deploys NFTStorefront contract", async () => {
    await deployNFTStorefrontContract()
  });
  
  it("sets up an account's NFT collection and Storefront", async () => {
    await deployNFTStorefrontContract()
		const StorefrontAdmin = await getAccountAddress("StorefrontAdmin")
    await setupAccount("StorefrontAdmin")
    var res = []
    res.push(await checkCollectionReceiver(StorefrontAdmin))
    res.push(await checkStorefront(StorefrontAdmin))

    expect(res).toEqual([true,true])
  });

  it("puts up an NFT for sale", async () => {
    await deployNFTStorefrontContract()
    const StorefrontAdmin = await getAccountAddress("StorefrontAdmin")
    await createFUSDVault(StorefrontAdmin)
    await mintBfeNFT(testData, "StorefrontAdmin")
    await setupAccount("StorefrontAdmin")
    await shallPass(sellBfeNFT("StorefrontAdmin",1,"10.00000000"))
  });

  it("buys a listed NFT", async () => {
    await deployNFTStorefrontContract()
    const StorefrontAdmin = await getAccountAddress("StorefrontAdmin")
    const Alice = await getAccountAddress("Alice")

    await fundAccountWithFUSD(StorefrontAdmin, Alice, "100.00")

    await mintBfeNFT(testData, "StorefrontAdmin")
    await setupAccount("StorefrontAdmin")
    await setupAccount("Alice")

    const listingData = await sellBfeNFT("StorefrontAdmin",1,"10.0")

    const listResourceId = listingData.events[0].data.listingResourceID

    await buyBfeNFT("Alice",StorefrontAdmin,1,"10.0",listResourceId)

    var res = []
    res.push(await getFUSDBalance(Alice))
    res.push(await getNFTIds(Alice))
    expect(res).toEqual(["90.00000000",[1]])
  });

})
