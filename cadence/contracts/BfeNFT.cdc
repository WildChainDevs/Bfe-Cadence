import NonFungibleToken from 0x631e88ae7f1d7c20

pub contract BfeNFT: NonFungibleToken {

    pub event NFTMinted(id: UInt64)

    pub event ContractInitialized()

    pub event Withdraw(id: UInt64, from: Address?)

    pub event Deposit(id: UInt64, to: Address?)

    pub var totalSupply: UInt64

    // Declare the NFT resource type
    pub resource NFT: NonFungibleToken.INFT {
        // The unique ID that differentiates each NFT
        pub let id: UInt64

        // Initialize fields in the init function
        init(initID: UInt64) {
            self.id = initID
        }
    }

    // We define this interface purely as a way to allow users
    // to create public, restricted references to their NFT Collection.
    // They would use this to only expose the deposit, getIDs,
    // idExists, and getMetadata fields in their Collection
    pub resource interface NFTReceiver {

        pub fun deposit(token: @NonFungibleToken.NFT)

        pub fun depositMeta(token: @NonFungibleToken.NFT, metadata: {String : String}) 

        pub fun getIDs(): [UInt64]

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT

        pub fun idExists(id: UInt64): Bool

        pub fun cleanMetadata()

        pub fun getMetadata(id: UInt64): {String : String}

    }

    // The definition of the Collection resource that
    // holds the NFTs that a user owns
    pub resource Collection: NFTReceiver,  NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        // dictionary of NFT conforming tokens
        // NFT is a resource type with an `UInt64` ID field
        
        // ownedNFTs keeps track of all NFTs a user owns 
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        // metadataObjs extends Flow NFT contract functionality to 
        // map an NFT's token id to its associated metadata--
        // which means you need the NFT's token id before you can set this var.
        pub var metadataObjs: {UInt64: {String : String}}

        // Initialize the ownedNFTs field to an empty collection (for NFTs),
        // and the metadataObjs field to an empty dictionary (for Strings)
        init () {
            self.ownedNFTs <- {}
            self.metadataObjs = {}
        }

        // withdraw 
        //
        // Function that removes an NFT from the collection 
        // and moves it to the calling context
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            // If the NFT isn't found, the transaction panics and reverts
            let token <- self.ownedNFTs.remove(key: withdrawID)?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }

        // deposit
        // Takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        //
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @BfeNFT.NFT

            let id: UInt64 = token.id

            // add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[id] <- token

            emit Deposit(id: id, to: self.owner?.address)

            destroy oldToken
        }

        // deposit 
        //
        // Function that takes an NFT and its metadata as an argument, and 
        // adds the NFT to the collections dictionary and
        // adds its associated metadata to the metadata dictionary.
        // NOTE: to make sure that only the minter of the token can add
        // metadata to the token, the addition of metadata is confined to the minting execution.
        pub fun depositMeta(token: @NonFungibleToken.NFT, metadata: {String : String}) {
            let newToken <- token as! @BfeNFT.NFT
            let id: UInt64 = newToken.id
            self.metadataObjs[id] = metadata
            self.ownedNFTs[id] <-! newToken
            emit Deposit(id: id, to: self.owner?.address)
            // As opposed to this other technique,
            // adding the new token to the dictionary which removes the old one:
            //let oldToken <- self.ownedNFTs[token.id] <- token
            //destroy oldToken
        }

         // borrowNFT
        // Gets a reference to an NFT in the collection
        // so that the caller can read its metadata and call its methods
        //
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        /*
        pub fun updateMetadata(id: UInt64, metadata: {String: String}) {
            self.metadataObjs[id] = metadata
        }

        pub fun removeMetadata(k: UInt64): {String : String}? {
            return self.metadataObjs.remove(key: k)
        }
        */

        pub fun cleanMetadata(){
            for k in self.metadataObjs.keys {
                if !self.idExists(id: k){
                    self.metadataObjs.remove(key: k)
                }
            }
        }

        pub fun getMetadata(id: UInt64): {String : String} {
            return self.metadataObjs[id]!
        }

        // idExists checks to see if a NFT 
        // with the given ID exists in the collection
        pub fun idExists(id: UInt64): Bool {
            return self.ownedNFTs[id] != nil
        }

        // getIDs returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    // creates a new empty Collection resource and returns it 
    pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    // NFTMinter
    //
    // Resource that would be owned by an admin or by a smart contract 
    // that allows them to mint new NFTs when needed
    pub resource NFTMinter {

        // the ID that is used to mint NFTs
        // it is only incremented so that NFT ids remain
        // unique. It also keeps track of the total number of NFTs
        // in existence.
        pub var idCount: UInt64

        init() {
            self.idCount = 1
        }

        // mintNFT 
        //
        // Function that mints a new NFT with a new ID
        // and, instead of depositing the NFT into a specific recipient's collection storage location,
        // just returns the NFT itself!
        pub fun mintNFT(): @NonFungibleToken.NFT {

            // create a new NFT! This is where the NFT's core ID gets created.
            // Right now, it's just getting this ID from the idCount field, which
            // merely increments up with each NFT minted. If we want to create more
            // complex IDs with hashing etc., this would be the place to put that new ID
            // generated from that technique.
            var oldNFT <- create NFT(initID: self.idCount) 

            let newNFT <- oldNFT as! @NonFungibleToken.NFT

            emit NFTMinted(id: self.idCount)

            // Increments the id so that each ID is unique
            self.idCount = self.idCount + 1 as UInt64

            BfeNFT.totalSupply = BfeNFT.totalSupply + (1 as UInt64)

            return <-newNFT 
        }
    }


    init() {

        // Initialize the total supply
        self.totalSupply = 0

		// store an empty NFT Collection in account storage
        self.account.save(<-self.createEmptyCollection(), to: /storage/BfeNFTcollection)

        // publish a reference to the Collection in storage
        self.account.link<&{BfeNFT.NFTReceiver}>(/public/BfeNFTreceiver, target: /storage/BfeNFTcollection)

        // store a minter resource in account storage
        self.account.save(<-create NFTMinter(), to: /storage/BfeNFTminter)

        emit ContractInitialized()

    }
}