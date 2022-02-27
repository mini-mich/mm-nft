async function main() {
   // Grab the contract factory 
   const MmNFT = await ethers.getContractFactory("MiniMich");

   // Start deployment, returning a promise that resolves to a contract object
   const mmNFT = await MmNFT.deploy("https://gateway.pinata.cloud/ipfs/QmdWdwwr3SLqjRtXFGhnBP9NfVTkmpNLG3Zjx1Wtm1zDUo/")// Instance of the contract 
   console.log("Contract deployed to address:", myNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
