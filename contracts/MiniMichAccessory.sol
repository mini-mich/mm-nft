// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ERC721A.sol";

contract MiniMichAccessory is ERC721A, Ownable, Pausable, ReentrancyGuard {
    string private _metadataBaseURI;
    bool public saleLiveToggle;
    bool public freezeURI;

    uint256 public constant MAX_NFT = 200;
    uint256 public constant MAX_MINT = 1;
    uint256 public MAX_BATCH = 5;
    uint256 public PRICE = 0;

    address private _creators = 0xF580fc0f5aE3032171c781FBBBE73f54Fe411C4b;//to be update 0x999eaa33BD1cE817B28459950E6DcD1dA14C411f
 
    // ** MODIFIERS ** //
    // *************** //
    modifier saleLive() {
        require(saleLiveToggle == true, "Sale is not live yet");
        _;
    }

    modifier maxSupply(uint256 mintNum) {
       require(
            totalSupply() + mintNum <= MAX_NFT,
            "Sold out"
        );
        _;
     }

    // ** CONSTRUCTOR ** //
    // *************** //
    constructor(string memory _mURI)
        ERC721A("MiniMichAccessory", "MMA", MAX_BATCH, MAX_NFT)
    {
        _metadataBaseURI = _mURI;
    }

    // ** ADMIN ** //
    // *********** //
    function _baseURI() internal view override returns (string memory) {
        return _metadataBaseURI;
    }

    function getOwnershipData(uint256 tokenId)
        external
        view
        returns (TokenOwnership memory)
    {
        return ownershipOf(tokenId);
    }

    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal override {
        require(!paused(), "Contract has been paused");
        super._beforeTokenTransfers(from, to, startTokenId, quantity);
    }

    /***
     *    ███╗   ███╗██╗███╗   ██╗████████╗
     *    ████╗ ████║██║████╗  ██║╚══██╔══╝
     *    ██╔████╔██║██║██╔██╗ ██║   ██║
     *    ██║╚██╔╝██║██║██║╚██╗██║   ██║
     *    ██║ ╚═╝ ██║██║██║ ╚████║   ██║
     *    ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝
     */

    function publicMint(uint256 mintNum)
        external
        payable
        nonReentrant
        saleLive
        maxSupply(mintNum)
    {
        require(
            numberMinted(msg.sender) + mintNum <= MAX_MINT,
            "Reaches wallet limit."
        );
        _safeMint(_msgSender(), mintNum);
    }

    function devMint(uint256 mintNum) 
        external 
        onlyOwner 
        maxSupply(mintNum) 
    {
        require(
            mintNum % MAX_BATCH == 0,
            "Multiple of the MAX_BATCH"
        );
        uint256 numChunks = mintNum / MAX_BATCH;
        for (uint256 i = 0; i < numChunks; i++) {
            _safeMint(msg.sender, MAX_BATCH);
        }
    }

    function reserve(address[] calldata receivers, uint256 mintNum)
        external
        onlyOwner
        maxSupply(mintNum*receivers.length)
    {
        for (uint256 i = 0; i < receivers.length; i++) {
            _safeMint(receivers[i], mintNum);
        }
    }

    /***
     *     ██████╗ ██╗    ██╗███╗   ██╗███████╗██████╗
     *    ██╔═══██╗██║    ██║████╗  ██║██╔════╝██╔══██╗
     *    ██║   ██║██║ █╗ ██║██╔██╗ ██║█████╗  ██████╔╝
     *    ██║   ██║██║███╗██║██║╚██╗██║██╔══╝  ██╔══██╗
     *    ╚██████╔╝╚███╔███╔╝██║ ╚████║███████╗██║  ██║
     *     ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
     * This section will have all the internals set to onlyOwner
     */

    function withdrawFunds() external onlyOwner {
        (bool success, ) = payable(_creators).call{value: address(this).balance}("");
        require(success, "Failed to send payment");
    }

    function setMetaURI(string calldata _URI) external onlyOwner {
        require(freezeURI == false, "Metadata is frozen");
        _metadataBaseURI = _URI;
    }

    //   function setMAX_BATCH(uint256 maxBatch) external onlyOwner returns (uint256 ) {
    //       MAX_BATCH = maxBatch;
    //       return MAX_BATCH;
    //   }

    //   function setCreator(address to) external onlyOwner returns (address) {
    //       _creators = to;
    //       return _creators;
    //   }

    function tglLive() external onlyOwner {
        saleLiveToggle = !saleLiveToggle;
    }

    function freezeAll() external onlyOwner {
        require(freezeURI == false, "Metadata is frozen");
        freezeURI = true;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function updatePrice(uint256 _price) external onlyOwner {
        PRICE = _price ;
    }

    // function setOwnersExplicit(uint256 quantity)
    //     external
    //     onlyOwner
    //    nonReentrant
    // {
    //     _setOwnersExplicit(quantity);
    // }

}