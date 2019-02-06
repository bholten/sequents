#lang racket

(provide automaton)

(define-syntax automaton
  (syntax-rules (:)
    [(_ init-state
        (state : response ...)
        ...)
     (let-syntax
         ([process-state
           (syntax-rules (accept ->)
             [(_ accept)
              (λ (stm)
                (cond
                  [(empty? stm) #t]
                  [else #f]))]
             [(_ (label -> target) (... ...))
              (λ (stm)
                (cond
                  [(empty? stm) #f]
                  [else
                   (case (first stm)
                     [(label) (target (rest stm))]
                     (... ...)
                     [else #f])]))])])
       (letrec ([state
                 (process-state response ...)]
                ...)
         init-state))]))

;; Test:
(define m (automaton init
                    [init : (c -> more)]
                    [more : (a -> more)
                            (d -> more)
                            (r -> end)]
                    [end : accept]))
(m '(c a d a d r))
(m '(c a d a d r a))
