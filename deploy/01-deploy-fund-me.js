//import 
//main function
//calling main function
const {networkConfig} = require("../helper-hardhat-config")

const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]

module.exports = async ({getNamedAccounts, deployments}) => {
    const {deploy,log} = deployments
    const {deployer} = await getNamedAccounts()
    const chainId = network.config.chainId
}