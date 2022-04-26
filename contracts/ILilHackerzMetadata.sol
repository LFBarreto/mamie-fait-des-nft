// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title IERC2981Royalties
/// @dev Interface for the ERC2981 - Token Royalty standard
interface ILilHackerzMetadata {
    function _getP0() external view returns (string memory);

    function _getP1() external view returns (string memory);

    function _setSvgParts(string memory p0, string memory p1) external;

    function _getDescription() external view returns (string memory);

    function _setDescription(string memory description) external;

    function _getWebBaseLink() external view returns (string memory);

    function _setWebBaseLink(string memory web_link) external;

    function _getHeads() external view returns (uint16[6][][] memory);

    function _getHeadsTraits() external view returns (string[] memory);

    function _addHeads(
        uint16[6][][] calldata heads,
        string[] memory head_traits
    ) external;

    function _setHead(
        uint16[6][] calldata head,
        string memory head_trait,
        uint256 index
    ) external;

    function _getHairs() external view returns (uint16[6][][] memory);

    function _getHairsTraits() external view returns (string[] memory);

    function _addHairs(
        uint16[6][][] calldata hairs,
        string[] memory hair_traits
    ) external;

    function _setHair(
        uint16[6][] calldata hair,
        string memory hair_trait,
        uint256 index
    ) external;

    function _getHats() external view returns (uint16[6][][] memory);

    function _getHatsTraits() external view returns (string[] memory);

    function _addHats(uint16[6][][] calldata hats, string[] memory hats_traits)
        external;

    function _setHats(
        uint16[6][] calldata hat,
        string memory hat_traits,
        uint256 index
    ) external;

    function _getAccessories() external view returns (uint16[6][][] memory);

    function _getAccessoriesTraits() external view returns (string[] memory);

    function _addAccessories(
        uint16[6][][] calldata accessories,
        string[] memory accessories_traits
    ) external;

    function _setAccessory(
        uint16[6][] calldata accesory,
        string memory accessory_trait,
        uint256 index
    ) external;

    function _getEyes() external view returns (uint16[6][][] memory);

    function _getEyesTraits() external view returns (string[] memory);

    function _addEyes(uint16[6][][] calldata eyes, string[] memory eyes_traits)
        external;

    function _setEyes(
        uint16[6][] calldata eye,
        string memory eye_trait,
        uint256 index
    ) external;

    function _getMouths() external view returns (uint16[6][][] memory);

    function _getMouthsTraits() external view returns (string[] memory);

    function _addMouths(
        uint16[6][][] calldata mouths,
        string[] memory mouths_traits
    ) external;

    function _setMouth(
        uint16[6][] calldata mouth,
        string memory mouth_trait,
        uint256 index
    ) external;
}
