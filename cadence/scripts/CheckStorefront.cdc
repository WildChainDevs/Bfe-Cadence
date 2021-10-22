// SPDX-License-Identifier: UNLICENSED

import NFTStorefront from "../contracts/NFTStorefront.cdc"

pub fun main(address: Address): Bool {
  let ref = getAccount(address).getCapability<&NFTStorefront.Storefront>(NFTStorefront.StorefrontPublicPath).check()
  return ref
}