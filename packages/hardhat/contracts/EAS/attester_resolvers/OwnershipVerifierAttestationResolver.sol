// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import { SchemaResolver } from "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";

import { IEAS, Attestation } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";

contract OwnershipVerifierAttestationResolver is SchemaResolver {
	address[] public targetAttesters;

	constructor(IEAS eas) SchemaResolver(eas) {}

	function addTargetAttester(address attester) public {
		targetAttesters.push(attester);
	}

	function onAttest(
		Attestation calldata attestation,
		uint256 /*value*/
	) internal view override returns (bool) {
		// TODO: use merkle proof to check attester address against targetAttesters.
		for (uint256 i = 0; i < targetAttesters.length; i++) {
			if (attestation.attester == targetAttesters[i]) {
				return true;
			}
		}
		return false;
	}

	function onRevoke(
		Attestation calldata /*attestation*/,
		uint256 /*value*/
	) internal pure override returns (bool) {
		return true;
	}
}
