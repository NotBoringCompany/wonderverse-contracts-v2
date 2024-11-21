// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "@ERC721A/contracts/extensions/ERC721AQueryable.sol";
import "@ERC721A/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "../utils/Signatures.sol";

/**
 * @dev Base NFT contract which also extends the ERC721A standard.
 */
abstract contract NFTBase is ERC721AQueryable, ERC721ABurnable, Signatures {
    using MessageHashUtils for bytes32;

    /**
     * @dev Fetches the total number of tokens burned by everyone.
     */
    function totalBurned() public view returns (uint256) {
        return _totalBurned();
    }

    /**
     * @dev Gets the auxiliary data of a token (only used for whitelisting or limited quantity for minting, for example).
     */
    function getAux(address _owner) public view returns (uint64) {
        return _getAux(_owner);
    }

    /**
     * @dev Fetches the bytes32 hash for operations.
     */
    function opHash(address addr, bytes calldata salt) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(addr, salt));
    }

     /**
     * @dev Mints a new Bit into existence.
     * 
     * Requires the admin's signature to mint.
     */
    function mint(
        address to,
        // [0] - salt
        // [1] - adminSig
        bytes[2] calldata sigData
    ) external virtual {
        // ensure that the admin's signature is valid
        _checkAdminSignatureValid(
            MessageHashUtils.toEthSignedMessageHash(opHash(to, sigData[0])),
            sigData[1]
        );


        _safeMint(to, 1);
    }

    /**
     * @dev Overrides supportsInterface to resolve conflict between ERC721A and AccessControl.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}