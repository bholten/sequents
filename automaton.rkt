#lang racket

(provide automaton
         defautomaton)

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

(define-syntax defautomaton
  (syntax-rules ()
    [(defautomaton name body body* ...)
     (define name (automaton body body* ...))]))
