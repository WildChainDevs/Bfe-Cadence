// SPDX-License-Identifier: UNLICENSED

import FungibleToken from "../contracts/FungibleToken.cdc"
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import FUSD from "../contracts/FUSD.cdc"
import BfeNFT from "../contracts/BfeNFT.cdc"
import NFTStorefront from "../contracts/NFTStorefront.cdc"

transaction(saleItemID: UInt64, saleItemPrice: UFix64) {

    let fusdReceiver: Capability<&FUSD.Vault{FungibleToken.Receiver}>
    let BfeProvider: Capability<&BfeNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(account: AuthAccount) {
        // We need a provider capability, but one is not provided by default so we create one if needed.
        let BfeCollectionProviderPrivatePath = /private/BfeCollectionProvider

        self.fusdReceiver = account.getCapability<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver)!
        
        assert(self.fusdReceiver.borrow() != nil, message: "Missing or mis-typed FUSD receiver")

        if !account.getCapability<&BfeNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(BfeCollectionProviderPrivatePath)!.check() {
            account.link<&BfeNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(BfeCollectionProviderPrivatePath, target: /storage/BfeNFTcollection)
        }

        self.BfeProvider = account.getCapability<&BfeNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(BfeCollectionProviderPrivatePath)!
        
        assert(self.BfeProvider.borrow() != nil, message: "Missing or mis-typed BfeNFT.Collection provider")

        self.storefront = account.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {
        let saleCut = NFTStorefront.SaleCut(
            receiver: self.fusdReceiver,
            amount: saleItemPrice
        )
        self.storefront.createListing(
            nftProviderCapability: self.BfeProvider,
            nftType: Type<@BfeNFT.NFT>(),
            nftID: saleItemID,
            salePaymentVaultType: Type<@FUSD.Vault>(),
            saleCuts: [saleCut]
        )
    }
}