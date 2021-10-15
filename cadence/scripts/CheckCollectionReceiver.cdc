import BfeNFT from 0xa446e01659258758

pub fun main(address: Address): Bool {
  let ref = getAccount(address).getCapability<&{BfeNFT.NFTReceiver}>(/public/BfeNFTreceiver).check()
  return ref
}