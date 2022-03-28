async function main() {
  //  const MmNFT = await ethers.getContractFactory("MiniMich");
  //  const mmNFT = await MmNFT.deploy("https://mini-mich.mypinata.cloud/ipfs/QmdWdwwr3SLqjRtXFGhnBP9NfVTkmpNLG3Zjx1Wtm1zDUo/")
  //  console.log("Contract deployed to address:", mmNFT.address);

  //  const MmaNFT = await ethers.getContractFactory("MiniMichAccessory");
  //  const mmaNFT = await MmaNFT.deploy("https://mini-mich.mypinata.cloud/ipfs/QmW9Wcj8aJm2HdT4CLAABYfChUrRqtut2mnDBd6K69kueB/")
  //  console.log("Contract deployed to address:", mmaNFT.address);

   const Mmav2NFT = await ethers.getContractFactory("MiniMichAccessoryV2");
   const mmav2NFT = await Mmav2NFT.deploy("https://mini-mich.mypinata.cloud/ipfs/QmVxiWtRrp1qyfDDw8fc6zy1T29kDa6UnJVaCyCtxz8g89/")
   console.log("Contract deployed to address:", mmav2NFT.address);

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
