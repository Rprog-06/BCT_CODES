// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title BCT_Bank
 * @notice Simple bank contract where users can deposit, withdraw and check their balance.
 * - Each Ethereum address has its own balance tracked in the contract.
 * - Deposits can be made via `deposit()` or by sending ETH to the contract (receive/fallback).
 * - Withdrawals send ETH back to the caller, with a safety check for sufficient balance.
 */
contract BCT_Bank {
	mapping(address => uint256) private balances;

	/// Emitted when `account` deposits `amount` wei.
	event Deposit(address indexed account, uint256 amount);

	/// Emitted when `account` withdraws `amount` wei.
	event Withdraw(address indexed account, uint256 amount);

	/// Receive function: credits sender's balance when contract receives ETH with empty calldata.
	receive() external payable {
		require(msg.value > 0, "Receive: no ETH sent");
		balances[msg.sender] += msg.value;
		emit Deposit(msg.sender, msg.value);
	}

	/// Fallback function: credits sender if ETH is sent with non-empty calldata.
	fallback() external payable {
		if (msg.value > 0) {
			balances[msg.sender] += msg.value;
			emit Deposit(msg.sender, msg.value);
		}
	}

	/**
	 * @notice Deposit ETH into the caller's bank account balance.
	 * @dev Use `msg.value` to specify deposit amount.
	 */
	function deposit() external payable {
		require(msg.value > 0, "Deposit: must send ETH");
		balances[msg.sender] += msg.value;
		emit Deposit(msg.sender, msg.value);
	}

	/**
	 * @notice Withdraw `amount` wei from the caller's bank account.
	 * @param amount Amount in wei to withdraw.
	 */
	function withdraw(uint256 amount) external {
		require(amount > 0, "Withdraw: amount must be > 0");
		uint256 bal = balances[msg.sender];
		require(bal >= amount, "Withdraw: insufficient balance");

		// Effects
		balances[msg.sender] = bal - amount;

		// Interaction (send ETH)
		(bool sent, ) = payable(msg.sender).call{value: amount}("");
		require(sent, "Withdraw: failed to send Ether");

		emit Withdraw(msg.sender, amount);
	}

	/**
	 * @notice Return the caller's balance (in wei).
	 */
	function getBalance() external view returns (uint256) {
		return balances[msg.sender];
	}

	/**
	 * @notice Return the balance of `account` (in wei).
	 * @param account Address to query.
	 */
	function getBalanceOf(address account) external view returns (uint256) {
		return balances[account];
	}
}
