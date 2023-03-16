interface ISolmac {
    struct VersionData {
        uint256 major;
        uint256 minor;
        address contractAddress;
    }

    function getCurrentVersion(string memory name) external view returns (VersionData memory versionData);
    function getCurrentVersionByMajor(string memory name, uint256 majorVersion) external view returns (VersionData memory versionData);
    function getCurrentVersionByVersion(string memory name, uint256 majorVersion, uint256 minorVersion) external view returns (VersionData memory versionData);
}
