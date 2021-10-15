import WildCoin from 0xa446e01659258758

transaction {
  prepare(acct: AuthAccount) {
    acct.link<&WildCoin.Vault{WildCoin.Receiver, WildCoin.Balance}>(/public/MainReceiver, target: /storage/MainVault)

    log("Public Receiver reference created!")
  }

  post {
    getAccount(acct).getCapability<&WildCoin.Vault{WildCoin.Receiver}>(/public/MainReceiver)
                    .check():
                    "Vault Receiver Reference was not created correctly"
    }
}
