const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    
    console.log("Deploying contracts with the account:", deployer.address);

    // Define camera IDs
    const primaryCameraId = 1;
    const secondaryCameraId = 2;

    // Deploy the contract
    const FailoverCameraSystem = await ethers.getContractFactory("FailoverCameraSystem");
    const failoverCameraSystem = await FailoverCameraSystem.deploy(primaryCameraId, secondaryCameraId);

    console.log("Failover Camera System deployed to:", failoverCameraSystem.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
