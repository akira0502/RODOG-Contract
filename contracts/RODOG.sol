// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "./ERC721Burnable.sol";
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Counters.sol";

contract RODOG is ERC721Enumerable, Ownable, ERC721Burnable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIdTracker;
    bool private _pause;

    string public baseTokenURI;
    mapping(address => uint) public addressClaimed;

    uint256 public constant MAX_SUPPLY = 10;
    uint256 public constant MAX_MINT = 1;
    address public constant team1 = 0x146164fbCe3932E46234E6Bd7eE7Efbcf98b834c;
    
    constructor(string memory baseURI) ERC721("Robot Dogs", "RODOG") {
        setBaseURI(baseURI);
        pause(true);
    }
    modifier saleIsOpen {
        require(_totalSupply() <= MAX_SUPPLY, "All RODOGs are accounted for");
        if (_msgSender() != owner()) {
            require(!_pause, "Pausable: paused");
        }
        _;
    }
    function _totalSupply() internal view returns (uint) {
        return _tokenIdTracker.current();
    }
    function totalMint() public view returns (uint256) {
        return _totalSupply();
    }
    function mint() external saleIsOpen {
        require(addressClaimed[_msgSender()] < MAX_MINT, "You have already received your max Token");
        addressClaimed[_msgSender()] += 1;
        _safeMint(msg.sender, 1);
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
    function setBaseURI(string memory baseURI) public onlyOwner {
        baseTokenURI = baseURI;
    }
    function pause(bool val) public onlyOwner {
        _pause = val;
    }
    function withdrawAll() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0);
        _widthdraw(team1, address(this).balance);
    }
    function _widthdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}