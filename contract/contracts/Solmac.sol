// SPDX-License-Identifier: MIT
/*
 *
 * Solmac - solidity package managemet collection
 * Created by Isamu Arimoto (@isamua)
 *
 */

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/ISolmac.sol";

contract Solmac  {
    using Strings for uint256;

    struct VersionMaster {
        uint256 currentMajor;
        uint256 currentMinor;
        address ownerAddress;
        string repositoryUrl;
    }
    struct VersionMinor {
        uint256 major;
        uint256 currentMinor;
        string interfaceUrl;
    }
        
    
    mapping(string => VersionMaster) private versionRepository; // packagename => major 
    mapping(bytes32 => VersionMinor) private minorRepository; // key is hash(packagename, majorVersion)
    mapping(bytes32 => ISolmac.VersionData) private dataRepository; // key is hash(packagename, majorVersion, minorVersion)
       

    function setNewData(string memory name, address myAddress, string memory interfaceUrl, string memory repositoryUrl) external {
      uint256 majorVersion = 0;
      uint256 minorVersion = 0;
      
      versionRepository[name] = VersionMaster(majorVersion, minorVersion, msg.sender, repositoryUrl); // insert

      bytes32 minorRepositoryKey = keccak256(abi.encodePacked(name, ",", majorVersion.toString()));
      minorRepository[minorRepositoryKey] = VersionMinor(majorVersion, minorVersion, interfaceUrl); // insert

      bytes32 dataRepositoryKey = keccak256(abi.encodePacked(name, ",", majorVersion.toString(), minorVersion.toString()));
      dataRepository[dataRepositoryKey] = ISolmac.VersionData(majorVersion, minorVersion, myAddress); // insert
  }
    function getCurrent(string memory name) external view returns (VersionMaster memory versionMaster) {
        versionMaster = versionRepository[name];
  }
  function setMinorVersion(string memory name,address myAddress) external {
      VersionMaster memory versionMaster = versionRepository[name];
      bytes32 minorRepositoryKey = keccak256(abi.encodePacked(name, ",", versionMaster.currentMajor.toString()));

      VersionMinor memory minorVersion = minorRepository[minorRepositoryKey];
      uint256 nextMinorVersion = minorVersion.currentMinor + 1;
      minorRepository[minorRepositoryKey].currentMinor = nextMinorVersion; // update
      
      bytes32 dataRepositoryKey = keccak256(abi.encodePacked(name, ",", versionMaster.currentMajor.toString(), nextMinorVersion.toString()));
      dataRepository[dataRepositoryKey] = ISolmac.VersionData(versionMaster.currentMajor, nextMinorVersion, myAddress); // insert
  } 


  function setMajorVersion(string memory name,address myAddress, string memory interfaceUrl) external {
      VersionMaster memory varsionMaster = versionRepository[name];

      // update version master
      uint256 nextMajor = varsionMaster.currentMajor + 1;
      uint256 minorVersion = 0;

      versionRepository[name].currentMajor = nextMajor; // update
      versionRepository[name].currentMinor = minorVersion; // update
      
      bytes32 minorRepositoryKey = keccak256(abi.encodePacked(name, ",", nextMajor.toString()));
      minorRepository[minorRepositoryKey] = VersionMinor(nextMajor, minorVersion, interfaceUrl); // insert

      bytes32 dataRepositoryKey = keccak256(abi.encodePacked(name, ",", nextMajor.toString(), minorVersion.toString()));
      dataRepository[dataRepositoryKey] = ISolmac.VersionData(nextMajor, minorVersion, myAddress); // insert
  } 


  function getCurrentVersion(string memory name) external view returns (ISolmac.VersionData memory versionData){
      VersionMaster memory varsionMaster = versionRepository[name];
      bytes32 minorRepositoryKey = keccak256(abi.encodePacked(name, ",", varsionMaster.currentMajor.toString()));

      VersionMinor memory minorVersion = minorRepository[minorRepositoryKey];
      
      bytes32 dataRepositoryKey = keccak256(abi.encodePacked(name, ",", varsionMaster.currentMajor.toString(), minorVersion.currentMinor.toString()));
      versionData = dataRepository[dataRepositoryKey];
      
  } 

  function getCurrentVersionByMajor(string memory name, uint256 majorVersion) external  view returns (ISolmac.VersionData memory versionData){
      bytes32 minorRepositoryKey = keccak256(abi.encodePacked(name, ",", majorVersion.toString()));

      VersionMinor memory minorVersion = minorRepository[minorRepositoryKey];
      
      bytes32 dataRepositoryKey = keccak256(abi.encodePacked(name, ",", majorVersion.toString(), minorVersion.currentMinor.toString()));
      versionData = dataRepository[dataRepositoryKey];
      
  } 
  function getCurrentVersionByVersion(string memory name, uint256 majorVersion, uint256 minorVersion) external  view returns (ISolmac.VersionData memory versionData){
      bytes32 dataRepositoryKey = keccak256(abi.encodePacked(name, ",", majorVersion.toString(), minorVersion.toString()));
      versionData = dataRepository[dataRepositoryKey];
  } 

}

