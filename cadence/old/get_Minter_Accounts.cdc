import WildNFT from 0xa446e01659258758

pub fun main() : [Address]? {
    let account = getAccount(0xa446e01659258758)
    let capability = account.getCapability(/public/AccessList) 
    let ref = capability.borrow<&{WildNFT.NFTMinterAccessPub}>() 
        ?? panic("Could not borrow account access list reference")

    return ref.getAccounts()
}
