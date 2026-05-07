// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiLanding
/// @notice Viral marketing site (repo #85)
interface IKagamiLanding {
    struct LandingPage {
        uint256 id;
        string title;
        string tagline;
        string metaDescription;
        bool active;
        uint256 publishedAt;
    }
    
    event PageCreated(uint256 indexed pageId, string title);
    event ViewRecorded(uint256 indexed pageId, address viewer);
    event LeadCaptured(string email, uint256 timestamp);
    
    /// @notice Create landing page
    function createLandingPage(
        string calldata _title,
        string calldata _tagline,
        string calldata _metaDescription
    ) external returns (uint256);
    
    /// @notice Record page view
    function recordView(uint256 _pageId) external;
    
    /// @notice Capture lead (email signup)
    function captureLead(string calldata _email) external;
    
    /// @notice Get landing page
    function getLandingPage(uint256 _pageId) external view returns (LandingPage memory);
    
    /// @notice Get total views
    function getTotalViews(uint256 _pageId) external view returns (uint256);
}
