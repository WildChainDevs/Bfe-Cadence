// SPDX-License-Identifier: UNLICENSED

import BfeNFT from "../contracts/BfeNFT.cdc"

transaction(customData: {String : String}) {
    // If the person executing this tx doesn't have access to the
    // resource, then the tx will fail. Thus, references...
    let receiverRef: &{BfeNFT.NFTReceiver}
    let minterRef: &BfeNFT.NFTMinter

    // ...in "prepare", the code borrows capabilities on the two resources referenced above,
    // takes in information of the person executing the tx, and validates.
    prepare(acct: AuthAccount) {
        self.receiverRef = acct.getCapability<&{BfeNFT.NFTReceiver}>(/public/BfeNFTreceiver)
            .borrow()
            ?? panic("Could not borrow receiver reference.")

        self.minterRef = acct.borrow<&BfeNFT.NFTMinter>(from: /storage/BfeNFTminter)
            ?? panic("Could not borrow minter reference.")
    }

    execute {

        let metadata : {String : String} = customData //{KeysData.slice(from: 4, upTo: KeysData.length): ValuesData.slice(from: 4, upTo: ValuesData.length)}

        // This is where the NFT resource itself is created
        let newNFT <- self.minterRef.mintNFT(metadata: metadata)

        // This is where the metadata comes into the picture to join with the new NFT!
        self.receiverRef.deposit(token: <-newNFT)

        log("NFT has been minted and deposited to Account's Collection")
    }
}
