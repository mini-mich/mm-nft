async function main() {
  //  const MmNFT = await ethers.getContractFactory("MiniMich");
  //  const mmNFT = await MmNFT.deploy("https://gateway.pinata.cloud/ipfs/QmdWdwwr3SLqjRtXFGhnBP9NfVTkmpNLG3Zjx1Wtm1zDUo/")// Instance of the contract 
  //  console.log("Contract deployed to address:", mmNFT.address);

   const MmaNFT = await ethers.getContractFactory("MiniMichAccessory");
   const mmaNFT = await MmaNFT.deploy("https://gateway.pinata.cloud/ipfs/QmdWdwwr3SLqjRtXFGhnBP9NfVTkmpNLG3Zjx1Wtm1zDUo/")// Instance of the contract 
   console.log("Contract deployed to address:", mmaNFT.address);

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
