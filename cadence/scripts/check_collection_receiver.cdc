// SPDX-License-Identifier: UNLICENSED

import BfeNFT from "../contracts/BfeNFT.cdc"

pub fun main(address: Address): Bool {
  let ref = getAccount(address).getCapability<&{BfeNFT.NFTReceiver}>(BfeNFT.CollectionPublicPath).check()
  return ref
}