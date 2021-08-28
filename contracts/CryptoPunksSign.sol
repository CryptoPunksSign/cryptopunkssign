// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./SafeMath.sol";
import "./ICryptoPunks.sol";

contract CryptoPunksSign is ERC721URIStorage {
    
    using SafeMath for uint256;
    
    uint256 private _tokenIds;
    uint256 private _totalSupply;
    address private _manager;
    address payable _cryptoPunksDao;
    CryptoPunksMarket private _cryptoPunksContract;
    // A record of the highest punk bid
    mapping (uint256 => uint256) public punkBids;
    
    modifier onlyOwner() {
        require(msg.sender == _manager);
        _;
    }
    
    function updateManager(address manager) public onlyOwner {
        _manager = manager;
    }
    
    function setCryptoPunksDao(address payable punksDao)public onlyOwner {
        _cryptoPunksDao = punksDao;
    }
    
    function setCryptoPunksContract(address cryptoPunksAddress)public onlyOwner {
        
    }
    
    function getMintPrice() public view returns(uint256){
        uint256 state =  SafeMath.div(_tokenIds,100);
        return mulDiv(state,1e18,100);
    } 
    
    function getUpdateSignPrice() public pure returns(uint256){
        return mulDiv(1,1e18,100);
    } 
    
    constructor() ERC721("CryptoPunksSign", "CryptoPunksSign") {
        _manager = msg.sender;
    }

    function mintCryptoPunksSign(string memory tokenURI)
        payable
        public
        returns (uint256)
    {
        require(_cryptoPunksDao != address(0x0),"mintCryptoPunksSign: address error !");
        require(_totalSupply < 10000,"mintCryptoPunksSign: Total 10000 !");
        if(_tokenIds > 1){
            uint256 fees = getMintPrice();
            require(fees <= msg.value,"mintCryptoPunksSign: msg.value error !");
            _cryptoPunksDao.transfer(fees);
        }
        _tokenIds++;
        _totalSupply++;
        uint256 newItemId = _tokenIds;
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
    
    function updatePunksSign(uint256 index,string memory tokenURI)
        payable
        public
        returns(bool)
    {
        require(index <= _tokenIds, "updatePunksSign: no index .");
        require(ownerOf(index) == msg.sender,"updatePunksSign: no permission .");
        require(getUpdateSignPrice() <= msg.value,"updatePunksSign: msg.value error !");
        _cryptoPunksDao.transfer(getUpdateSignPrice());
        _setTokenURI(index, tokenURI);
        return true;
    }
    
    function cryptoPunksClaim(uint256 index,string memory tokenURI)
        public
        returns (uint256)
    {
        require(_cryptoPunksDao != address(0x0),"mintCryptoPunksSign: address error !");
        require(_totalSupply < 10000,"mintCryptoPunksSign: Total 10000 !");
        CryptoPunksMarket cryptoPunks =  CryptoPunksMarket(_cryptoPunksContract);
        address cryptoPunksUser = cryptoPunks.punkIndexToAddress(index);
        require(cryptoPunksUser == msg.sender,"cryptoPunksClaim: no punks .");
        require(punkBids[index] == 0,"cryptoPunksClaim: exist claim .");
        _tokenIds++;
        _totalSupply++;
        uint256 newItemId = _tokenIds;
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        punkBids[index] = newItemId;
        return newItemId;
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    
    function mulDiv (uint256 _x, uint256 _y, uint256 _z) public pure returns (uint256) {
        uint256 temp = _x.mul(_y);
        return temp.div(_z);
    }
    
}