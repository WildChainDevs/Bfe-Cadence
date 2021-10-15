import WildNFT,WildCoin,Marketplace from 0xa446e01659258758

transaction(minterAcct: Address) {
    prepare(acct: AuthAccount) {
        let MinterAccess <- acct.load<@WildNFT.NFTMinterAccess>(from: /storage/WildNFTMinterAccess)!
        MinterAccess.addAccount(mintAccount: minterAcct)
        acct.save(<- MinterAccess, to: /storage/WildNFTMinterAccess)
    }
}
