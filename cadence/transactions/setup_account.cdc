// SPDX-License-Identifier: UNLICENSED

import BfeNFT from "../contracts/BfeNFT.cdc"
import NFTStorefront from "../contracts/NFTStorefront.cdc"

transaction {
    prepare(signer: AuthAccount) {
        // if the account doesn't already have a collection
        if signer.borrow<&BfeNFT.Collection>(from: BfeNFT.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- BfeNFT.createEmptyCollection()
            
            // save it to the account
            signer.save(<-collection, to: BfeNFT.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&AnyResource{BfeNFT.NFTReceiver}>(BfeNFT.CollectionPublicPath, target: BfeNFT.CollectionStoragePath)
        }

        if signer.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {
            let storefront <- NFTStorefront.createStorefront()
            signer.save<@NFTStorefront.Storefront>(<-storefront, to: NFTStorefront.StorefrontStoragePath)
            signer.link<&NFTStorefront.Storefront>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
        }
    }
}
