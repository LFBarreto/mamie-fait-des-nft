// SPDX-License-Identifier: MIT
/**
>>>   Made with tears and confusion by LFBarreto   <<<
>> https://github.com/LFBarreto/mamie-fait-des-nft  <<
>>>           inspired by nouns.wtf                <<<
*/
pragma solidity 0.8.13;

import "base64-sol/base64.sol";

import "./ILilHackerzMetadata.sol";

contract LilHackerzMetaData is ILilHackerzMetadata {
    address private _owner;

    constructor() {
        _owner = msg.sender;
    }

    uint16[6][][] public _heads;
    uint16[6][][] public _hairs;
    uint16[6][][] public _hats;
    uint16[6][][] public _accessories;
    uint16[6][][] public _eyes;
    uint16[6][][] public _mouths;

    string[] public _heads_traits;
    string[] public _hairs_traits;
    string[] public _hats_traits;
    string[] public _accessories_traits;
    string[] public _eyes_traits;
    string[] public _mouths_traits;

    string public _p0 = "";
    string public _p1 = "";

    string public _description = "";
    string public _web_link = "";

    function _getP0() public view returns (string memory) {
        return _p0;
    }

    function _getP1() public view returns (string memory) {
        return _p1;
    }

    function _setSvgParts(string memory p0, string memory p1) public {
        require(msg.sender == _owner, "Only owner");
        _p0 = p0;
        _p1 = p1;
    }

    function _getDescription() public view returns (string memory) {
        return _description;
    }

    function _setDescription(string memory description) public {
        require(msg.sender == _owner, "Only owner");
        _description = description;
    }

    function _getWebBaseLink() public view returns (string memory) {
        return _web_link;
    }

    function _setWebBaseLink(string memory web_link) public {
        require(msg.sender == _owner, "Only owner");
        _web_link = web_link;
    }

    function _getHeads() public view returns (uint16[6][][] memory) {
        return _heads;
    }

    function _getHeadsTraits() public view returns (string[] memory) {
        return _heads_traits;
    }

    function _addHeads(
        uint16[6][][] calldata heads,
        string[] memory head_traits
    ) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < heads.length; i++) {
            _heads.push(heads[i]);
            _heads_traits.push(head_traits[i]);
        }
    }

    function _setHead(
        uint16[6][] calldata head,
        string memory head_trait,
        uint256 index
    ) public {
        require(msg.sender == _owner, "Only owner");
        _heads[index] = head;
        _heads_traits[index] = head_trait;
    }

    function _getHairs() public view returns (uint16[6][][] memory) {
        return _hairs;
    }

    function _getHairsTraits() public view returns (string[] memory) {
        return _hairs_traits;
    }

    function _addHairs(
        uint16[6][][] calldata hairs,
        string[] memory hair_traits
    ) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < hairs.length; i++) {
            _hairs.push(hairs[i]);
            _hairs_traits.push(hair_traits[i]);
        }
    }

    function _setHair(
        uint16[6][] calldata hair,
        string memory hair_trait,
        uint256 index
    ) public {
        require(msg.sender == _owner, "Only owner");
        _hairs[index] = hair;
        _hairs_traits[index] = hair_trait;
    }

    function _getHats() public view returns (uint16[6][][] memory) {
        return _hats;
    }

    function _getHatsTraits() public view returns (string[] memory) {
        return _hats_traits;
    }

    function _addHats(uint16[6][][] calldata hats, string[] memory hats_traits)
        public
    {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < hats.length; i++) {
            _hats.push(hats[i]);
            _hats_traits.push(hats_traits[i]);
        }
    }

    function _setHats(
        uint16[6][] calldata hat,
        string memory hat_traits,
        uint256 index
    ) public {
        require(msg.sender == _owner, "Only owner");
        _hats[index] = hat;
        _hats_traits[index] = hat_traits;
    }

    function _getAccessories() public view returns (uint16[6][][] memory) {
        return _accessories;
    }

    function _getAccessoriesTraits() public view returns (string[] memory) {
        return _accessories_traits;
    }

    function _addAccessories(
        uint16[6][][] calldata accessories,
        string[] memory accessories_traits
    ) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < accessories.length; i++) {
            _accessories.push(accessories[i]);
            _accessories_traits.push(accessories_traits[i]);
        }
    }

    function _setAccessory(
        uint16[6][] calldata accesory,
        string memory accessory_trait,
        uint256 index
    ) public {
        require(msg.sender == _owner, "Only owner");
        _accessories[index] = accesory;
        _accessories_traits[index] = accessory_trait;
    }

    function _getEyes() public view returns (uint16[6][][] memory) {
        return _eyes;
    }

    function _getEyesTraits() public view returns (string[] memory) {
        return _eyes_traits;
    }

    function _addEyes(uint16[6][][] calldata eyes, string[] memory eyes_traits)
        public
    {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < eyes.length; i++) {
            _eyes.push(eyes[i]);
            _eyes_traits.push(eyes_traits[i]);
        }
    }

    function _setEyes(
        uint16[6][] calldata eye,
        string memory eye_trait,
        uint256 index
    ) public {
        require(msg.sender == _owner, "Only owner");
        _eyes[index] = eye;
        _eyes_traits[index] = eye_trait;
    }

    function _getMouths() public view returns (uint16[6][][] memory) {
        return _mouths;
    }

    function _getMouthsTraits() public view returns (string[] memory) {
        return _mouths_traits;
    }

    function _addMouths(
        uint16[6][][] calldata mouths,
        string[] memory mouths_traits
    ) public {
        require(msg.sender == _owner, "Only owner");
        for (uint16 i = 0; i < mouths.length; i++) {
            _mouths.push(mouths[i]);
            _mouths_traits.push(mouths_traits[i]);
        }
    }

    function _setMouth(
        uint16[6][] calldata mouth,
        string memory mouth_trait,
        uint256 index
    ) public {
        require(msg.sender == _owner, "Only owner");
        _mouths[index] = mouth;
        _mouths_traits[index] = mouth_trait;
    }
}
