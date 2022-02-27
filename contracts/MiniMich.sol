// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ERC721A.sol";

contract MiniMich is ERC721A, Ownable, Pausable, ReentrancyGuard {
    string private _metadataBaseURI;
    bytes32 private wlisteRoot;
    bool public preLiveToggle;
    bool public saleLiveToggle;
    bool public freezeURI;

    uint256 public constant MAX_NFT = 10;//10000;
    uint256 public constant MAX_RESERVE = 9;//199;
    uint256 public constant MAX_PRESALE = 9;//999;
    uint256 public constant MAX_PRESALE_MINT = 2;
    uint256 public MAX_BATCH = 5;
    uint256 public RESERVE_COUNT = 0;
    uint256 public PRESALE_COUNT = 0;
    uint256 public PRICE = 0.02 ether;//0.5 ether;
    uint256 public PRESALE_PRICE = 0.01 ether;//0.2 ether;

    address private _creators = 0xF580fc0f5aE3032171c781FBBBE73f54Fe411C4b;//to be update

    // ** MODIFIERS ** //
    // *************** //
    modifier saleLive() {
        require(saleLiveToggle == true, "Sale is not live yet");
        _;
    }

    modifier preSaleLive() {
        require(preLiveToggle == true, "Presale is not live yet");
        _;
    }

    modifier correctPayment(uint256 mintPrice, uint32 numToMint) {
        require(
            msg.value == mintPrice * numToMint,
            "Payment failed"
        );
        _;
    }

    // ** CONSTRUCTOR ** //
    // *************** //
    constructor(string memory _mURI)
        ERC721A("MiniMich", "MM", MAX_BATCH, MAX_NFT)
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

    function publicMint(uint32 mintNum)
        external
        payable
        nonReentrant
        saleLive
        correctPayment(PRICE, mintNum)
    {
        require(
            totalSupply() + mintNum + MAX_RESERVE - RESERVE_COUNT <= MAX_NFT,
            "Sold out"
        );
        _safeMint(_msgSender(), mintNum);
    }

    function preMint(uint32 mintNum, bytes32[] calldata merkleProof)
        external
        payable
        nonReentrant
        preSaleLive
        correctPayment(PRESALE_PRICE, mintNum)
    {
        require(
            MerkleProof.verify(
                merkleProof,
                wlisteRoot,
                keccak256(abi.encodePacked(_msgSender()))
            ),
            "Not on whitelist"
        );

        require(
            numberMinted(msg.sender) + mintNum <= MAX_PRESALE_MINT,
            "Reaches wallet limit."
        );

        require(PRESALE_COUNT + mintNum < MAX_PRESALE, "Presale reaches limit");

        _safeMint(_msgSender(), mintNum);
        PRESALE_COUNT += mintNum;
    }

    function devMint(uint256 mintNum) external onlyOwner {
        require(
            totalSupply() + mintNum <= MAX_NFT,
            "Dev reaches mint"
        );
        require(
            mintNum % MAX_BATCH == 0,
            "Multiple of the MAX_BATCH"
        );
        uint256 numChunks = mintNum / MAX_BATCH;
        for (uint256 i = 0; i < numChunks; i++) {
            _safeMint(msg.sender, MAX_BATCH);
        }
    }

    function reserve(address[] calldata receivers, uint32 mintNum)
        external
        onlyOwner
    {
        require(
            totalSupply() + receivers.length * mintNum <= MAX_NFT,
            "Sold out"
        );
        require(
            RESERVE_COUNT + receivers.length * mintNum <= MAX_RESERVE,
            "Reach reserve limit"
        );

        for (uint32 i = 0; i < receivers.length; i++) {
            require(receivers[i] != address(0), "zero address");
            _safeMint(receivers[i], mintNum);
        }
        RESERVE_COUNT = RESERVE_COUNT + receivers.length * mintNum;
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

    function withdrawFunds(uint256 _amt) external onlyOwner {
        uint256 pay_amt;
        if (_amt == 0) {
            pay_amt = address(this).balance;
        } else {
            pay_amt = _amt;
        }

        (bool success, ) = payable(_creators).call{value: pay_amt}("");
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

    function tglPresale() external onlyOwner {
        preLiveToggle = !preLiveToggle;
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

    function updatePrice(uint256 _price, uint32 _list) external onlyOwner {
        if (_list == 0) {
            // sale price
            PRICE = _price * 10**18;
        } else {
            // presale price
            PRESALE_PRICE = _price * 10**18;
        }
    }

    function setMerkleRoot(bytes32 _root) external onlyOwner {
        wlisteRoot = _root;
    }

    // function setOwnersExplicit(uint256 quantity)
    //     external
    //     onlyOwner
    //    nonReentrant
    // {
    //     _setOwnersExplicit(quantity);
    // }
}
