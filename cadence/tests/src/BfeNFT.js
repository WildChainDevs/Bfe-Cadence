import {
    getAccountAddress,
    mintFlow,
    deployContractByName,
    sendTransaction,
    executeScript
} from "flow-js-testing"

export const deployBfeNFTContract = async () => {
    const BfeNFTAdmin = await getAccountAddress("BfeNFTAdmin")
    await mintFlow(BfeNFTAdmin, "10.0")
    await deployContractByName({ to: BfeNFTAdmin, name: "NonFungibleToken"})
    const addressMap = { NonFungibleToken: BfeNFTAdmin }
    await deployContractByName({ to: BfeNFTAdmin, name: "BfeNFT", addressMap})
}

export const mintBfeNFT = async (data,admin) => {
    const BfeNFTAdmin = await getAccountAddress(admin)
    const name = "MintCustomMetadata";
	const args = [data];
	const signers = [BfeNFTAdmin];

	return sendTransaction({ name, args, signers });
};

export const getNFTIds = async (account) => {
    const name = "GetNFTIds";
	const args = [account];
	return executeScript({ name, args });
};

export const getNFTMeta = async (account,id) => {
    const name = "GetNFTMetadata";
	const args = [account,id];
	return executeScript({ name, args });
};

/*export const updateNFTMeta = async (id,data) => {
    const name = "UpdateNFTMetadata";
	const args = [id,data];
    const BfeNFTAdmin = await getAccountAddress("BfeNFTAdmin")
    const signers = [BfeNFTAdmin];
	return sendTransaction({ name, args, signers });
};*/

export const checkCollectionReceiver = async( account ) => {
    const name = "CheckCollectionReceiver";
    const args = [account]
	return executeScript({ name, args });
};
