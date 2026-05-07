// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiExplorer
/// @notice Real-time fractal explorer (DexScreener but for ideas) (repo #35)
interface IKagamiExplorer {
    struct ReflectionData {
        uint256 id;
        address creator;
        string metadataURI;
        uint256 marketCap;
        uint256 volume24h;
        uint256 priceChange24h; // basis points
        uint256 childCount;
        uint256 totalRevenue;
    }
    
    event ReflectionViewed(uint256 indexed reflectionId, address viewer);
    event ExplorerSearched(string query, uint256 resultCount);
    
    /// @notice Get reflection data for explorer
    function getReflectionData(uint256 _reflectionId) 
        external view returns (ReflectionData memory);
    
    /// @notice Get trending reflections (sorted by volume)
    function getTrendingReflections(uint256 _limit) 
        external view returns (uint256[] memory reflectionIds);
    
    /// @notice Search reflections by metadata
    function searchReflections(string calldata _query) 
        external view returns (uint256[] memory reflectionIds);
    
    /// @notice Get real-time price feed for reflection
    function getReflectionPrice(uint256 _reflectionId) 
        external view returns (uint256 price, uint256 timestamp);
    
    /// @notice Track view (for analytics)
    function trackView(uint256 _reflectionId) external;
}
