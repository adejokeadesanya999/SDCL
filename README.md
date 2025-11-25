Self-Documenting Contract Language (SDCL)

Overview

Self-Documenting Contract Language (SDCL) is a Clarity smart contract designed to store human-readable documentation for its functions directly on-chain. This allows for transparency, auditability, and easier understanding of smart contract behavior, especially for third-party auditors, developers, or end-users.

Features

On-Chain Function Documentation

Each function has associated metadata including:

Description: What the function does.

Parameters: What arguments it takes.

Returns: Output of the function.

Example Usage: How to call the function.

Dynamic Documentation

The contract owner can add or update documentation for any function at any time, creating a living, evolving on-chain documentation system.

Read-Only Documentation Access

Anyone can query:

Documentation for a specific function.

Total number of documented functions.

A high-level overview of the contract.

Example Application Function

increment-counter demonstrates a simple state-changing function.

get-counter demonstrates a read-only function.

Contract Storage

function-docs (map): Stores the documentation for each function.

counter (data-var): Simple counter to demonstrate documented functionality.

total-documented-functions (data-var): Tracks how many functions have been documented.

Functions
Owner-Only Functions

add-function-docs

Adds or updates documentation for any function.

Parameters: function name, description, parameters, return value, example usage.

Returns: ok true if successful, err-owner-only if caller is not owner.

Read-Only Functions

get-function-docs

Retrieves the complete documentation for a specific function.

get-total-documented-functions

Returns the number of documented functions.

get-contract-overview

Returns a summary of the contract including purpose, owner, and number of documented functions.

get-counter

Returns the current value of the counter.

Application Functions

increment-counter

Increments the counter by 1.

Demonstrates a simple documented state-changing function.

Initialization

Upon deployment, the contract initializes documentation for all included functions using init-documentation, setting up initial metadata for:

increment-counter

get-counter

add-function-docs

get-function-docs

get-total-documented-functions

Example Usage
;; Increment counter
(contract-call? .SDCL increment-counter)

;; Read counter value
(contract-call? .SDCL get-counter)

;; Read documentation for increment-counter
(contract-call? .SDCL get-function-docs "increment-counter")

;; Add or update documentation (owner only)
(contract-call? .SDCL add-function-docs 
  "new-function" 
  "This is a new function." 
  "param1: uint" 
  "Returns true if successful." 
  "Call (contract-call? .SDCL new-function 42)")

Benefits

Enhances auditability and transparency of smart contracts.

Provides a living documentation system that evolves with contract updates.

Supports human-readable explanations directly on-chain, reducing reliance on external documentation.