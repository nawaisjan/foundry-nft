// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";


contract MoodNft is ERC721{
  //errors

  error MoodNft__CantFlipIfNotOwner();
  uint256 private s_tokenCounter;
  string private s_sadSvgImageUri;
  string private s_happySvgImageUri;

  enum Mood{
    HAPPY,
    SAD
  }

  mapping(uint256 => Mood) private s_tokenIdMood;





  constructor(string memory sadSvgaImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MF"){
    s_tokenCounter = 0;
    s_sadSvgImageUri = sadSvgaImageUri;
    s_happySvgImageUri = happySvgImageUri;
  }

  function mintNft() public{
    _safeMint(msg.sender,s_tokenCounter);
    s_tokenIdMood[s_tokenCounter] = Mood.HAPPY;
    s_tokenCounter++;
  }

  function flipMood(uint256 tokenId) public{

    if(!_isApprovedOrOwner(msg.sender,tokenId)){
      revertm MoodNft__CantFlipIfNotOwner();
    }
    if(s_tokenIdMood[tokenId] == Mood.HAPPY){
      s_tokenIdMood[tokenId] = Mood.SAD;
    }
    else{
      s_tokenIdMood[tokenId] = Mood.HAPPY;

    }

    
  }

  function _baseURI() internal pure override returns(string memory){
    return "data:application/json;base64,";

  }

  function tokenURI(uint256 tokenId) public view override returns(string memory){
    string memory imageURI;
    if(s_tokenIdMood[s_tokenCounter] == Mood.HAPPY){
      imageURI = s_happySvgImageUri;
      
    }
    else {
      imageURI = s_sadSvgImageUri;
    }


    return string(abi.encodePacked(
      _baseURI(),Base64.encode(bytes(abi.encodePacked('{"name":"',name(),'","description":"An Nft That reflects the owner mode.","attributes":[{"trait_type":"moodiness","value":100}],"image":"',imageURI,'"}')))));
  }


}