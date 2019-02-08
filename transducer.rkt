#lang racket

;; Transducers

(define sequents
  (λ (xf)
    (λ (rf)
      (case-lambda
        [() (xf)]
        [(result) (xf result)]
        [(result input)
         (if (xf input)
             (rf result input)
             result)]))))
