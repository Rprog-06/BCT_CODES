
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title BCT_Calculator
 * @notice Basic calculator contract demonstrating simple arithmetic functions.
 * @dev All arithmetic uses signed integers (int256) to allow negative results.
 */
contract BCT_Calculator {
	// Last operation result stored on-chain (optional)
	int256 public lastResult;
	string public lastOperation;

	event Calculated(address indexed caller, string operation, int256 a, int256 b, int256 result);

	/// Add two signed integers
	function add(int256 a, int256 b) external returns (int256) {
		int256 r = a + b;
		lastResult = r;
		lastOperation = "add";
		emit Calculated(msg.sender, "add", a, b, r);
		return r;
	}

	/// Subtract b from a
	function sub(int256 a, int256 b) external returns (int256) {
		int256 r = a - b;
		lastResult = r;
		lastOperation = "sub";
		emit Calculated(msg.sender, "sub", a, b, r);
		return r;
	}

	/// Multiply two signed integers
	function mul(int256 a, int256 b) external returns (int256) {
		int256 r = a * b;
		lastResult = r;
		lastOperation = "mul";
		emit Calculated(msg.sender, "mul", a, b, r);
		return r;
	}

	/// Divide a by b. Reverts if b == 0
	function div(int256 a, int256 b) external returns (int256) {
		require(b != 0, "division by zero");
		int256 r = a / b;
		lastResult = r;
		lastOperation = "div";
		emit Calculated(msg.sender, "div", a, b, r);
		return r;
	}

	/// Clear stored last result and operation
	function clear() external {
		lastResult = 0;
		lastOperation = "";
	}
}
