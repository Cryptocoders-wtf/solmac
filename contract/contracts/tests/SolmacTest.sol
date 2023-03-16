import "../interfaces/ISolmac.sol";

interface ITestContractVersionOne {
    function getCurrentVersion() external view returns (uint256 version);
}

contract TestContractVersionOne is ITestContractVersionOne {
    function getCurrentVersion() external pure returns (uint256 version) {
        version = 1;
    }
}
contract TestContractVersionOneOne is ITestContractVersionOne {
    function getCurrentVersion() external pure returns (uint256 version) {
        version = 11;
    }
}

contract TestContractVersionOneTwo is ITestContractVersionOne {
    function getCurrentVersion() external pure returns (uint256 version) {
        version = 12;
    }
}


interface ITestContractVersionTwo {
    function getCurrentVersion2() external view returns (uint256 version);
}


contract TestContractVersionTwo is ITestContractVersionTwo {
    function getCurrentVersion2() external pure returns (uint256 version) {
        version = 2;
    }
}

contract SolmacTest {
    ISolmac solmac;
    constructor(ISolmac _solmac) {
        solmac = _solmac;
    }
    
    function getSolVersion() external view returns (ISolmac.VersionData memory versionData) {
        versionData = solmac.getCurrentVersion("apptest");
    }
    function getVersion() external view returns (uint256 out) {
        ISolmac.VersionData memory versionData = solmac.getCurrentVersion("apptest");
        ITestContractVersionOne test = ITestContractVersionOne(versionData.contractAddress);
        out = test.getCurrentVersion();
    }
}
