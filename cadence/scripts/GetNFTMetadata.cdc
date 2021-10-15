import BfeNFT from 0xa446e01659258758

pub fun main(account: Address, nftId: UInt64) : {String : String} {
    let nftOwner = getAccount(account)
    let capability = nftOwner.getCapability(/public/BfeNFTreceiver)
    let receiverRef = capability.borrow<&{BfeNFT.NFTReceiver}>()
        ?? panic("Could not borrow the receiver reference")

    return receiverRef.getMetadata(id: nftId)
}
