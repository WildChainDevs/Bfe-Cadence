// SPDX-License-Identifier: UNLICENSED

import NFTStorefront from 0xa446e01659258758

pub fun main(address: Address): Bool {
  let ref = getAccount(address).getCapability<&NFTStorefront.Storefront>(NFTStorefront.StorefrontPublicPath).check()
  return ref
}