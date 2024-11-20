// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "@ERC721A/contracts/extensions/ERC721AQueryable.sol";
import "@ERC721A/contracts/extensions/ERC721ABurnable.sol";

/**
 * @dev Extends ERC721A's functionalities, especially internal functions to make them public.
 */
abstract contract ERC721AExtended is ERC721AQueryable, ERC721ABurnable {
    // fetches the total number of tokens burned by everyone
    function totalBurned() public view returns (uint256) {
        return _totalBurned();
    }

    // gets the auxiliary data of a token (only used for whitelisting or quantity-based minting events)
    function getAux(address _owner) public view returns (uint64) {
        return _getAux(_owner);
    }
}