// SPDX-License-Identifier: MIT
/**
>>>   Made with tears and confusion by LFBarreto   <<<
>> https://github.com/LFBarreto/mamie-fait-des-nft  <<
>>>           inspired by nouns.wtf                <<<
*/
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";
import "./ILilHackerzMetadata.sol";

import {SVGPixels} from "./libraries/SVGPixels.sol";

contract LilHackerz is ERC721URIStorage {
    address private _owner;
    uint256 private nonce;
    uint256 public _tokenCounter;
    event CreatedLilHackerz(uint256 indexed tokenId);
    event UpdatedLilHackerz(uint256 indexed tokenId);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    ILilHackerzMetadata public metadataContract;

    uint256 public constant PRICE = 1 ether;

    mapping(uint256 => uint256) _headsIds;
    mapping(uint256 => uint256) _hairsIds;
    mapping(uint256 => uint256) _hatsIds;
    mapping(uint256 => uint256) _accessoriesIds;
    mapping(uint256 => uint256) _eyesIds;
    mapping(uint256 => uint256) _mouthsIds;

    constructor() ERC721("LIL-HACKERZ", "LilHackerz") {
        _owner = msg.sender;
        _tokenCounter = 0;
    }

    function _setMetadataContract(address _metadataContract) public {
        require(msg.sender == _owner, "Only owner");
        metadataContract = ILilHackerzMetadata(_metadataContract);
    }

    function random(uint256 max) public returns (uint256) {
        uint256 randomnumber = uint256(
            keccak256(abi.encodePacked(msg.sender, nonce))
        ) % max;
        nonce++;
        return randomnumber;
    }

    function getWeightedIndex(uint256 i, uint256 max)
        public
        pure
        returns (uint256)
    {
        return (((i % (max + 1)) + 1) % ((i % max) + 1));
    }

    function preMint(uint256 _tokenId) internal {
        _headsIds[_tokenId] = getWeightedIndex(
            random(100 + _tokenId),
            metadataContract._getHeads().length
        );
        _hairsIds[_tokenId] = getWeightedIndex(
            random(100 + _tokenId),
            metadataContract._getHairs().length
        );
        _hatsIds[_tokenId] = getWeightedIndex(
            random(100 + _tokenId),
            metadataContract._getHats().length
        );
        _accessoriesIds[_tokenId] = getWeightedIndex(
            random(100 + _tokenId),
            metadataContract._getAccessories().length
        );
        _eyesIds[_tokenId] = getWeightedIndex(
            random(100 + _tokenId),
            metadataContract._getEyes().length
        );
        _mouthsIds[_tokenId] = getWeightedIndex(
            random(100 + _tokenId),
            metadataContract._getMouths().length
        );
    }

    function mint() public payable {
        require(
            msg.sender == _owner || msg.value >= PRICE,
            "Bitch better get my money! min 1 MATIC required"
        );
        preMint(_tokenCounter);
        _safeMint(msg.sender, _tokenCounter);
        _tokenCounter++;

        emit CreatedLilHackerz(_tokenCounter);
    }

    function mintTo(address to) public payable {
        require(
            msg.sender == _owner || msg.value >= PRICE,
            "Bitch better get my money! min 1 MATIC required"
        );
        preMint(_tokenCounter);
        _safeMint(to, _tokenCounter);
        _tokenCounter++;

        emit CreatedLilHackerz(_tokenCounter);
    }

    function mintToWithTraits(
        address to,
        uint16 head,
        uint16 hair,
        uint16 hat,
        uint16 eye,
        uint16 mouth,
        uint16 accessory
    ) public payable {
        require(msg.sender == _owner, "Only owner can mint to with traits");

        _headsIds[_tokenCounter] = head;
        _hairsIds[_tokenCounter] = hair;
        _hatsIds[_tokenCounter] = hat;
        _accessoriesIds[_tokenCounter] = accessory;
        _eyesIds[_tokenCounter] = eye;
        _mouthsIds[_tokenCounter] = mouth;

        _safeMint(to, _tokenCounter);
        _tokenCounter++;

        emit CreatedLilHackerz(_tokenCounter);
    }

    function batchMint(uint256 count) public {
        require(msg.sender == _owner, "Only owner");
        for (uint256 i = 0; i < count; i++) {
            mint();
        }
    }

    function batchMintTo(address[] memory addresses) public {
        require(msg.sender == _owner, "Only owner");
        uint256 count = addresses.length;
        for (uint256 i = 0; i < count; i++) {
            mintTo(addresses[i]);
        }
    }

    function withdraw() public payable {
        require(msg.sender == _owner, "Only owner");
        payable(_owner).transfer(address(this).balance);
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == _owner, "Only owner");
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );

        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function shuffleTraits(uint256 _tokenId) public payable {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        require(msg.sender == ownerOf(_tokenId), "Only owner");
        require(
            msg.value >= PRICE,
            "Bitch better get my money! min 1 MATIC required"
        );

        preMint(_tokenId);

        emit UpdatedLilHackerz(_tokenId);
    }

    function generateSVG(uint256 targetId)
        internal
        view
        returns (string memory svg)
    {
        svg = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 320 320' shape-rendering='crispEdges'>",
                metadataContract._getP0(),
                metadataContract._getP1(),
                "<path d='M0 0 H 320 V 320 H 0 Z' fill='#fff' /><g id='main'>"
            )
        );

        svg = string(
            abi.encodePacked(
                svg,
                SVGPixels.generate(
                    [
                        metadataContract._getHeads()[_headsIds[targetId]],
                        metadataContract._getHairs()[_hairsIds[targetId]],
                        metadataContract._getMouths()[_mouthsIds[targetId]],
                        metadataContract._getAccessories()[
                            _accessoriesIds[targetId]
                        ],
                        metadataContract._getEyes()[_eyesIds[targetId]],
                        metadataContract._getHats()[_hatsIds[targetId]]
                    ]
                ),
                "</g></svg>"
            )
        );

        return svg;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory svg = generateSVG(_tokenId);

        string memory attrs = string(
            abi.encodePacked(
                '"attributes": [{"trait_type": "Head","value": "',
                metadataContract._getHeadsTraits()[_headsIds[_tokenId]],
                '"}, {"trait_type": "Hair","value": "',
                metadataContract._getHairsTraits()[_hairsIds[_tokenId]],
                '"}, {"trait_type": "Mouth","value": "',
                metadataContract._getMouthsTraits()[_mouthsIds[_tokenId]],
                '"}, {"trait_type": "Eye","value": "',
                metadataContract._getEyesTraits()[_eyesIds[_tokenId]],
                '"}, {"trait_type": "Accessorry","value": "',
                metadataContract._getAccessoriesTraits()[
                    _accessoriesIds[_tokenId]
                ],
                '"}, {"trait_type": "Hat","value": "',
                metadataContract._getHatsTraits()[_hatsIds[_tokenId]],
                '"}], "external_url": "',
                metadataContract._getWebBaseLink(),
                SVGPixels.uint2str(_tokenId),
                '"'
            )
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"LilHackerz #',
                                SVGPixels.uint2str(_tokenId),
                                '", "description":"LIL-HACKERZ Token - #',
                                SVGPixels.uint2str(_tokenId),
                                " -",
                                metadataContract._getDescription(),
                                ' ",',
                                attrs,
                                ', "background_color": "#000", "image":"data:image/svg+xml;base64,',
                                Base64.encode(bytes(svg)),
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
