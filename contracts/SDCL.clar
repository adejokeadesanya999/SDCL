;; Self-Documenting Contract Language (SDCL)
;; A Clarity contract that stores plain-language explanations of its functions on-chain
;; for human auditability and transparency

;; ========================================
;; CONSTANTS
;; ========================================

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))

;; ========================================
;; DATA STORAGE
;; ========================================

;; Store function documentation: function-name -> plain-language explanation
(define-map function-docs
    { function-name: (string-ascii 50) }
    {
        description: (string-utf8 500),
        parameters: (string-utf8 300),
        returns: (string-utf8 200),
        example-usage: (string-utf8 300)
    }
)

;; Store a simple counter to demonstrate documented functionality
(define-data-var counter uint u0)

;; Track documentation updates
(define-data-var total-documented-functions uint u0)

;; ========================================
;; SELF-DOCUMENTATION FUNCTIONS
;; ========================================

;; Initialize the contract with documentation for all functions
(define-private (init-documentation)
    (begin
        ;; Document the increment-counter function
        (map-set function-docs
            { function-name: "increment-counter" }
            {
                description: u"Increases the counter by 1. This function demonstrates a simple state change that anyone can perform.",
                parameters: u"None - this function takes no parameters",
                returns: u"Returns 'ok true' on success",
                example-usage: u"Call (contract-call? .SDCL increment-counter) to increase the counter"
            }
        )

        ;; Document the get-counter function
        (map-set function-docs
            { function-name: "get-counter" }
            {
                description: u"Retrieves the current value of the counter. This is a read-only function that costs no gas to call.",
                parameters: u"None - this function takes no parameters",
                returns: u"Returns the current counter value as an unsigned integer",
                example-usage: u"Call (contract-call? .SDCL get-counter) to view the current count"
            }
        )

        ;; Document the add-function-docs function
        (map-set function-docs
            { function-name: "add-function-docs" }
            {
                description: u"Allows the contract owner to add or update documentation for any function. This enables living documentation that evolves with the contract.",
                parameters: u"function-name: string (max 50 chars), description: string (max 500 chars), parameters: string (max 300 chars), returns: string (max 200 chars), example-usage: string (max 300 chars)",
                returns: u"Returns 'ok true' if documentation was added successfully, or err-owner-only if caller is not the owner",
                example-usage: u"Contract owner calls with function name and all documentation fields"
            }
        )

        ;; Document the get-function-docs function
        (map-set function-docs
            { function-name: "get-function-docs" }
            {
                description: u"Retrieves the complete documentation for a specific function. Returns all fields: description, parameters, return value, and usage examples.",
                parameters: u"function-name: string (max 50 chars) - the name of the function to look up",
                returns: u"Returns an optional tuple containing all documentation fields, or none if function not documented",
                example-usage: u"Call (contract-call? .SDCL get-function-docs \"increment-counter\") to read documentation"
            }
        )

        ;; Document the get-total-documented-functions function
        (map-set function-docs
            { function-name: "get-total-documented-functions" }
            {
                description: u"Returns the total number of functions that have been documented in this contract. Useful for auditing completeness.",
                parameters: u"None - this function takes no parameters",
                returns: u"Returns the count of documented functions as an unsigned integer",
                example-usage: u"Call (contract-call? .SDCL get-total-documented-functions) to see documentation coverage"
            }
        )

        (var-set total-documented-functions u5)
        true
    )
)

;; Add or update documentation for a function (owner only)
(define-public (add-function-docs
    (function-name (string-ascii 50))
    (description (string-utf8 500))
    (parameters (string-utf8 300))
    (returns (string-utf8 200))
    (example-usage (string-utf8 300)))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)

        ;; Check if this is a new function being documented
        (if (is-none (map-get? function-docs { function-name: function-name }))
            (var-set total-documented-functions (+ (var-get total-documented-functions) u1))
            true
        )

        (map-set function-docs
            { function-name: function-name }
            {
                description: description,
                parameters: parameters,
                returns: returns,
                example-usage: example-usage
            }
        )
        (ok true)
    )
)

;; ========================================
;; READ-ONLY DOCUMENTATION FUNCTIONS
;; ========================================

;; Get documentation for a specific function
(define-read-only (get-function-docs (function-name (string-ascii 50)))
    (map-get? function-docs { function-name: function-name })
)

;; Get the total number of documented functions
(define-read-only (get-total-documented-functions)
    (var-get total-documented-functions)
)

;; Get a human-readable contract overview
(define-read-only (get-contract-overview)
    {
        name: "Self-Documenting Contract Language (SDCL)",
        purpose: u"Demonstrates on-chain function documentation for human auditability and transparency",
        total-functions-documented: (var-get total-documented-functions),
        owner: contract-owner
    }
)

;; ========================================
;; EXAMPLE APPLICATION FUNCTIONS
;; ========================================

;; Increment the counter (demonstrates a simple documented function)
(define-public (increment-counter)
    (begin
        (var-set counter (+ (var-get counter) u1))
        (ok true)
    )
)

;; Get the current counter value
(define-read-only (get-counter)
    (var-get counter)
)

;; ========================================
;; CONTRACT INITIALIZATION
;; ========================================

;; Initialize documentation when contract is deployed
(init-documentation)
