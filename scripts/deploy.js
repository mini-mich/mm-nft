async function main() {
   // Grab the contract factory 
   const MyNFT = await ethers.getContractFactory("MiniMich");

   // Start deployment, returning a promise that resolves to a contract object
   const myNFT = await MyNFT.deploy("https://gateway.pinata.cloud/ipfs/QmXN1eoYUuG1QkYhyAAbcsWrCjFYTFM9yFyp8RbpzA9Yh9/")// Instance of the contract 
   console.log("Contract deployed to address:", myNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
