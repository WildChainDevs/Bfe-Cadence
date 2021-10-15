import Marketplace from 0xa446e01659258758
pub fun main(account: Address): [UInt64]? {
    let acct = getAccount(account)

    let acctReceiverRef = acct.getCapability<&Marketplace.SaleCollection{Marketplace.SalePublic}>(/public/NFTSale)
        .borrow()
        ?? panic("Could not borrow a reference to the acct receiver")

    return acctReceiverRef.getIDs()
}
