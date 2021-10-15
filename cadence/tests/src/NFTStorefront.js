import {
    getAccountAddress,
    mintFlow,
    deployContractByName,
    sendTransaction,
    executeScript
} from "flow-js-testing"

export const deployNFTStorefrontContract = async () => {
    const StorefrontAdmin = await getAccountAddress("StorefrontAdmin")
    await mintFlow(StorefrontAdmin, "10.0")
    await deployContractByName({ to: StorefrontAdmin, name: "NonFungibleToken"})
    const addressMap = { NonFungibleToken: StorefrontAdmin, FungibleToken: "0xee82856bf20e2aa6"}
    await deployContractByName({ to: StorefrontAdmin, name: "FUSD", addressMap})
    await deployContractByName({ to: StorefrontAdmin, name: "BfeNFT", addressMap})
    await deployContractByName({ to: StorefrontAdmin, name: "NFTStorefront", addressMap})
}

export const sellBfeNFT = async (seller, nftId, price) => {
    const Seller = await getAccountAddress(seller)
    const name = "SellBfeNFT";
	const args = [nftId, price];
	const signers = [Seller];
	return sendTransaction({ name, args, signers });
};

export const buyBfeNFT = async (buyer, seller, nftId, price, listId) => {
    const Buyer = await getAccountAddress(buyer)
    const name = "BuyBfeNFT";
	const args = [seller, nftId, price,listId];
	const signers = [Buyer];
	return sendTransaction({ name, args, signers });
};

export const setupAccount = async( account ) => {
    const name = "SetupAccount";
    const Acct = await getAccountAddress(account)
    const signers = [Acct];
	return sendTransaction({ name, signers });
};

export const checkStorefront = async( account ) => {
    const name = "CheckStorefront";
    const args = [account]
	return executeScript({ name, args });
};