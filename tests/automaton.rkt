;; Test:
(define m (automaton init
                    [init : (c -> more)]
                    [more : (a -> more)
                            (d -> more)
                            (r -> end)]
                    [end : accept]))
(m '(c a d a d r))
(m '(c a d a d r a))

(defautomaton m2
  init
  [init : (c -> more)]
  [more : (a -> more)
          (d -> more)
          (r -> end)]
  [end : accept])

(m2 '(c a d a d r))
(m2 '(c a d a d r a))
