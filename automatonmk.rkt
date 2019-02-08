#lang racket
(require minikanren)

(provide automaton/mk
         defautomaton/mk)

(define-syntax automaton/mk
  (syntax-rules (:)
    [(_ init-state
        (state : response ...)
        ...)
     (let-syntax
         ([process-state
           (syntax-rules (accept ->)
             [(_ accept)
              (lambda (stm out)
                (== out #t))]
             [(_ (label -> target) (... ...))
              (lambda (stm out)
                (conde
                  [(== stm null) (== out #f)]
                  [(fresh (a b)
                     (== `(,a . ,b) stm)
                      (conde
                        [(== label a) (target b out)]
                        (... ...)))]))])])
       (letrec ([state
                 (process-state response ...)]
                ...)
         init-state))]))

(define-syntax defautomaton/mk
  (syntax-rules ()
    [(defautomaton/mk name body body* ...)
     (define name (automaton/mk body body* ...))]))
