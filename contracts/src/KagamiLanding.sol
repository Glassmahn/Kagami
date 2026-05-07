// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiLanding
/// @notice Viral marketing site (repo #85)
contract KagamiLanding is Ownable {
    struct LandingPage {
        uint256 id;
        string title;
        string tagline;
        string metaDescription;
        bool active;
        uint256 publishedAt;
        uint256 viewCount;
    }
    
    uint256 public pageCount;
    mapping(uint256 => LandingPage) public pages;
    mapping(string => uint256) public pageByTitle;
    
    event PageCreated(uint256 indexed pageId, string title);
    event ViewRecorded(uint256 indexed pageId, address viewer);
    event PageUpdated(uint256 indexed pageId, string newTitle);
    event LeadCaptureed(string email, uint256 timestamp);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Create landing page
    function createLandingPage(
        string calldata _title,
        string calldata _tagline,
        string calldata _metaDescription
    ) external onlyOwner returns (uint256) {
        pageCount++;
        
        pages[pageCount] = LandingPage({
            id: pageCount,
            title: _title,
            tagline: _tagline,
            metaDescription: _metaDescription,
            active: true,
            publishedAt: block.timestamp,
            viewCount: 0
        });
        
        pageByTitle[_title] = pageCount;
        
        emit PageCreated(pageCount, _title);
        return pageCount;
    }
    
    /// @notice Record page view
    function recordView(uint256 _pageId) external {
        LandingPage storage page = pages[_pageId];
        require(page.active, "Page not active");
        
        page.viewCount++;
        emit ViewRecorded(_pageId, msg.sender);
    }
    
    /// @notice Capture lead (email signup)
    function captureLead(string calldata _email) external {
        emit LeadCaptureed(_email, block.timestamp);
    }
    
    /// @notice Update landing page
    function updateLandingPage(
        uint256 _pageId,
        string calldata _newTitle,
        string calldata _newTagline
    ) external onlyOwner {
        LandingPage storage page = pages[_pageId];
        require(page.active, "Page not active");
        
        page.title = _newTitle;
        page.tagline = _newTagline;
        
        emit PageUpdated(_pageId, _newTitle);
    }
    
    /// @notice Deactivate page
    function deactivatePage(uint256 _pageId) external onlyOwner {
        pages[_pageId].active = false;
    }
    
    /// @notice Get landing page
    function getLandingPage(uint256 _pageId) external view returns (LandingPage memory) {
        return pages[_pageId];
    }
    
    /// @notice Get total views
    function getTotalViews(uint256 _pageId) external view returns (uint256) {
        return pages[_pageId].viewCount;
    }
    
    /// @notice Get all active pages
    function getActivePages() external view returns (uint256[] memory) {
        uint256[] memory active = new uint256[](pageCount);
        uint256 index = 0;
        
        for (uint256 i = 1; i <= pageCount; i++) {
            if (pages[i].active) {
                active[index++] = i;
            }
        }
        
        // Trim array
        assembly {
            mstore(active, index)
        }
        
        return active;
    }
}
