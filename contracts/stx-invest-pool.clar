;; ==========================================================
;;  STX Investment Pool Smart Contract
;;  Filename: stx-invest-pool.clar
;;  Description:
;;     A decentralized investment pool for collecting STX
;;     from multiple investors, managing funds, and 
;;     distributing profits proportionally.
;;
;;  Author: Muhammad Miftahu
;;  ==========================================================

;; ============= ERRORS ======================
(define-constant ERR-NOT-ADMIN (err u100))
(define-constant ERR-NO-INVESTMENT (err u101))
(define-constant ERR-INSUFFICIENT-FUNDS (err u102))
(define-constant ERR-ALREADY-INVESTOR (err u103))
(define-constant ERR-NOT-INVESTOR (err u104))
(define-constant ERR-ZERO-INVESTMENT (err u105))

;; ============= STATE VARIABLES ==============
(define-data-var admin principal tx-sender)
(define-data-var total-invested uint u0)
(define-data-var pool-open bool true)

;; Map of investor -> amount invested
(define-map investors
  {investor: principal}
  {amount: uint}
)

;; ============= ADMIN FUNCTIONS ==============

;; Close investment (no new investors allowed)
(define-public (close-pool)
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-ADMIN)
    (var-set pool-open false)
    (ok "Investment pool closed")
  )
)

;; Reopen pool for investment
(define-public (open-pool)
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-ADMIN)
    (var-set pool-open true)
    (ok "Investment pool reopened")
  )
)

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-ADMIN)
    (asserts! (not (is-eq new-admin tx-sender)) (err u106))
    (var-set admin new-admin)
    (ok "Admin transferred")
  )
)

;; Distribute profits proportionally to investors
;; Note: This is a simplified version. Manual distribution per investor is recommended.
(define-public (distribute-profit (profit uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-ADMIN)
    (let ((total (var-get total-invested)))
      (if (is-eq total u0)
          (err u200)
          (ok "Profit distribution initiated")
      )
    )
  )
)

;; ============= INVESTOR FUNCTIONS ===========

;; Invest STX into pool
(define-public (invest (amount uint))
  (begin
    (if (not (var-get pool-open))
        (err u201)
        (if (<= amount u0)
            ERR-ZERO-INVESTMENT
            (begin
              (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
              (if (is-some (map-get? investors {investor: tx-sender}))
                  (let ((current (unwrap-panic (map-get? investors {investor: tx-sender}))))
                    (map-set investors {investor: tx-sender}
                      {amount: (+ (get amount current) amount)})
                  )
                  (map-set investors {investor: tx-sender} {amount: amount})
              )
              (var-set total-invested (+ (var-get total-invested) amount))
              (ok (tuple (investor tx-sender) (invested amount)))
            )
        )
    )
  )
)

;; Withdraw your investment (admin must keep pool solvent)
(define-public (withdraw (amount uint))
  (let ((inv-data (map-get? investors {investor: tx-sender})))
    (match inv-data
      some-data
      (if (> amount (get amount some-data))
        ERR-INSUFFICIENT-FUNDS
        (begin
          (try! (as-contract (stx-transfer? amount (as-contract tx-sender) tx-sender)))
          (map-set investors {investor: tx-sender}
            {amount: (- (get amount some-data) amount)})
          (var-set total-invested (- (var-get total-invested) amount))
          (ok (tuple (withdrawn amount) (remaining (- (get amount some-data) amount))))
        )
      )
      ERR-NOT-INVESTOR
    )
  )
)

;; ============= READ-ONLY FUNCTIONS ===========

;; Get admin
(define-read-only (get-admin)
  (ok (var-get admin))
)

;; Get total STX in pool
(define-read-only (get-pool-balance)
  (ok (stx-get-balance (as-contract tx-sender)))
)

;; Get total invested amount
(define-read-only (get-total-invested)
  (ok (var-get total-invested))
)

;; Get investor info
(define-read-only (get-investor (who principal))
  (map-get? investors {investor: who})
)

;; Check if pool open
(define-read-only (is-pool-open)
  (ok (var-get pool-open))
)
