/**
 *Submitted for verification at Etherscan.io on 2017-07-19
*/
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
interface CryptoPunksMarket {
    
    //mapping (address => uint) public addressToPunkIndex;
    function punkIndexToAddress(uint index)external view returns(address);

}