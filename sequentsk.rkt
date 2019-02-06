#lang racket
(require minikanren)

(provide automaton/kanren)

(define-syntax automaton/kanren
  (syntax-rules (:)
    [(_ init-state
        (state : response ...)
        ...)
     (let-syntax
         ([process-state
           (syntax-rules (accept ->)
             [(_ accept)
              (lambda (stm out)
                (== out (null? stm)))]
             [(_ (label -> target) (... ...))
              (λ (stm out)
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

;; Test
(define m (automaton/kanren init
                            [init : ('c -> more)]
                            [more : ('a -> more)
                                  ('d -> more)
                                  ('r -> end)]
                            [end : accept]))
