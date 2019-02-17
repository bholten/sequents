#lang racket

(require "../automatonmk.rkt"
         minikanren)

; Test:
; Example from stackoverflow
; https://codereview.stackexchange.com/questions/143726/event-driven-finite-state-machine-dsl-in-kotlin
(define elevator (automaton/mk
                  idle
                  [idle : ('go-up   -> going-up)
                          ('go-down -> going-down)
                          ('at-destination -> done)]
                  [going-down : ('halt -> idle)
                                ('hit-bottom -> at-bottom)]
                  [going-up : ('halt -> idle)
                              ('hit-top -> at-top)]
                  [at-top : ('go-down -> going-down)
                            ('at-destination -> done)]
                  [at-bottom : ('go-up -> going-up)
                               ('at-destination -> done)]
                  [done : accept]))

; What's interesting about the miniKanren version is that it can generate valid sequences:
(run 10 (q) (elevator q #t))

; Test
; match: c(a|d)*r regex
(define m/k
  (automaton/mk init
                [init : ('c -> more)]
                [more : ('a -> more)
                        ('d -> more)
                        ('r -> end)]
                [end : accept]))

; Can recognize valid or invalid sequences:
(run 1 (q) (m/k '(a c d r) q))
(run 1 (q) (m/k '(c a d a d r) q))
(run 1 (q) (m/k '(c a d a d r) q))

; Can generate valid sequences
(run 10 (q) (m/k q #t))
