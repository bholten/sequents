#lang racket

(require "../automaton.rkt")

; Test:
; Example from stackoverflow
; https://codereview.stackexchange.com/questions/143726/event-driven-finite-state-machine-dsl-in-kotlin
(define elevator (automaton
                  idle
                  [idle : (go-up   -> going-up)
                          (go-down -> going-down)
                          (at-destination -> done)]
                  [going-down : (halt -> idle)
                                (hit-bottom -> at-bottom)]
                  [going-up : (halt -> idle)
                              (hit-top -> at-top)]
                  [at-top : (go-down -> going-down)
                            (at-destination -> done)]
                  [at-bottom : (go-up -> going-up)
                               (at-destination -> done)]
                  [done : accept]))

(elevator '(go-up halt go-down hit-bottom at-destination)) ; true

; Test:
; match c(a|d)*r regex
(define m (automaton init
                     [init : (c -> more)]
                     [more : (a -> more)
                             (d -> more)
                             (r -> end)]
                     [end : accept]))

(m '(c a d a d r))   ; true
(m '(c a d a d r a)) ; false

                                         