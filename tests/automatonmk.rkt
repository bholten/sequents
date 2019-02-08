;; Test
(define m/k
  (automaton/mk init
                [init : ('c -> more)]
                [more : ('a -> more)
                       ('d -> more)
                       ('r -> end)]
                [end : accept]))

(run 10 (q) (m/k q #f))
(run 1 (q) (m/k '(a c d r) q))
(run 1 (q)  (m/k '(c a d a d r) q))
(run 1 (q) (m/k '(c a d a d r) q))
