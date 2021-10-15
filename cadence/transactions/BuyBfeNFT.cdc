import BfeNFT from 0xa446e01659258758
import NFTStorefront from 0xa446e01659258758
import FUSD from 0xe223d8a629e49c68
import FungibleToken from 0x9a0766d93b6608b7

// This transaction uses the signer's tokens to purchase an NFT
// from the Sale collection of the seller account.
transaction(sellerAcct: Address, nftID: UInt64, tokenAmount: UFix64, listId: UInt64) {

  // reference to the buyer's NFT collection where they
  // will store the bought NFT
  let collectionRef: &AnyResource{BfeNFT.NFTReceiver}

  // Vault that will hold the tokens that will be used to
  // buy the NFT
  let temporaryVault: @FungibleToken.Vault

  prepare(acct: AuthAccount) {

    // get the references to the buyer's fungible token Vault
    // and NFT Collection Receiver
    self.collectionRef = acct.getCapability<&AnyResource{BfeNFT.NFTReceiver}>(/public/BfeNFTreceiver).borrow()
        ?? panic("Could not borrow reference to the signer's nft collection")

    let vaultRef = acct.borrow<&FUSD.Vault>(from: /storage/fusdVault)
        ?? panic("Could not borrow reference to the signer's vault")

    // withdraw tokens from the buyers Vault
    self.temporaryVault <- vaultRef.withdraw(amount: tokenAmount)
  }

  execute {
    // get the read-only account storage of the seller
    let seller = getAccount(sellerAcct)

    let nftCapability = seller.getCapability(/public/BfeNFTreceiver)
      
    // Pull out the "borrow()" capability to get the script to borrow from the deployed contract
    let nftRef = nftCapability.borrow<&{BfeNFT.NFTReceiver}>()
      ?? panic("Could not borrow the rec reference")

    // get the reference to the seller's sale
    let storefrontCapability = seller.getCapability<&AnyResource{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath)
        
    let storefrontRef = storefrontCapability.borrow()
      ?? panic("could not borrow reference to the seller's sale")

    let listingRef = storefrontRef.borrowListing(listingResourceID: listId)!

    // purchase the NFT the the seller is selling, giving them the reference
    // to your NFT collection and giving them the tokens to buy it
    let nft <- listingRef.purchase(payment: <-self.temporaryVault)
    let nftId = nft.id
    self.collectionRef.depositMeta(token: <-nft, metadata: nftRef.getMetadata(id: nftId))
    storefrontRef.cleanup(listingResourceID: listId)
  }
}