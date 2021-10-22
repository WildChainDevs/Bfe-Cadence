// SPDX-License-Identifier: UNLICENSED

import BfeNFT from 0xa446e01659258758
import NFTStorefront from 0xa446e01659258758

transaction {
    prepare(signer: AuthAccount) {
        // if the account doesn't already have a collection
        if signer.borrow<&BfeNFT.Collection>(from: /storage/BfeNFTcollection) == nil {

            // create a new empty collection
            let collection <- BfeNFT.createEmptyCollection()
            
            // save it to the account
            signer.save(<-collection, to: /storage/BfeNFTcollection)

            // create a public capability for the collection
            signer.link<&AnyResource{BfeNFT.NFTReceiver}>(/public/BfeNFTreceiver, target: /storage/BfeNFTcollection)
        }

        if signer.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {
            let storefront <- NFTStorefront.createStorefront()
            signer.save<@NFTStorefront.Storefront>(<-storefront, to: NFTStorefront.StorefrontStoragePath)
            signer.link<&NFTStorefront.Storefront>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
        }
    }
}
