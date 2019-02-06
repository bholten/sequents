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

;; Test
(define m/k (automaton/kanren init
                              [init : ('c -> more)]
                              [more : ('a -> more)
                                      ('d -> more)
                                      ('r -> end)]
                              [end : accept]))

;; (run 10 (q) (m/k q #f))
;; (run 1 (q) (m/k '(a c d r) q))
;; (run 1 (q)  (m/k '(c a d a d r) q))
;; (run 1 (q) (m/k '(c a d a d r) q)) ;; should be #t
