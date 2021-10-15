import {
    getAccountAddress,
    mintFlow,
    deployContractByName,
    sendTransaction,
    executeScript
  } from "flow-js-testing"

const FUSD_ADMIN = "FUSDAdmin"

export const deployFUSDContract = async () => {
    const FUSDAdmin = await getAccountAddress(FUSD_ADMIN)
    await mintFlow(FUSDAdmin, "10.0")
    const addressMap = { FungibleToken: "0xee82856bf20e2aa6" }
    await deployContractByName({ to: FUSDAdmin, name: "FUSD", addressMap })
  }

export const createFUSDVault = async (recipient) => {
    const signers = [recipient]
    const name = "CreateFUSDVault"
    await sendTransaction({ signers, name })
}

export const createFUSDMinter = async (admin) => {
  const signers = [admin]
  const name = "CreateFUSDMinter"
  await sendTransaction({ signers, name })
}

export const mintFUSD = async (admin, recipient, amount) => {
  const signers = [admin]
  const args = [recipient, amount]
  const name = "MintFUSD"
  await sendTransaction({ name, args, signers })
}

export const getFUSDBalance = async (account) => {
    const args = [account]
    const balance = await executeScript({ name: "GetFUSDBalance", args })
    return balance
}

export const fundAccountWithFUSD = async (admin ,recipient, amount) => {
  await createFUSDMinter(admin)
  await createFUSDVault(admin)
  await createFUSDVault(recipient)
  await mintFUSD(admin,recipient,amount)
  const balance = await getFUSDBalance(recipient)
  return balance
}