import BfeNFT from 0xa446e01659258758

transaction(nftId: UInt64, meta: {String : String}) {
    let ref: &BfeNFT.Collection
    prepare(signer: AuthAccount) {
        self.ref = signer.borrow<&BfeNFT.Collection>(from: /storage/BfeNFTcollection) ?? panic("Cannot borrow reference")
    }

    execute{
        self.ref.updateMetadata(id: nftId, metadata: meta)
    }

}
