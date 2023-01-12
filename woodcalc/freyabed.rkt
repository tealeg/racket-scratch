#lang racket/base



(require racket/class)


(require "block.rkt")
(require "render.rkt")
(require "wood.rkt")


(define matress-width 1400)
(define matress-length 2000)

(define floor 0)

(define centre-x (/ matress-width 2.0))
(define centre-y (/ matress-length 2.0))


(define leg-width 60)
(define leg-length 160)
(define leg-height 920)

(define (leg x y)
  (block leg-length leg-width leg-height  x y floor "yellow"))

(define cross-beam-length 60)
(define cross-beam-width 1400)
(define cross-beam-height 160)

(define (cross-beam x y)
  (block cross-beam-length cross-beam-width cross-beam-height x y leg-height "blue"))


(define main-beam-length (- matress-length 120))
(define main-beam-width 60)
(define main-beam-height 160)

(define (main-beam x y)
  (block main-beam-length main-beam-width main-beam-height x y leg-height "red"))

(define slat-length 140)
(define slat-width matress-width)
(define slat-height 23)

(define (slat x y)
  (block slat-length slat-width slat-height x y (+ leg-height main-beam-height) "green"))

(define (slat-range x y length spacing)
  (if (<= (+ y slat-length) length)
        (cons (slat x y) (slat-range x (+ y spacing slat-length) length spacing))
        '()))


(define rear-left-leg (leg 0 (- matress-length leg-length)))
(define rear-right-leg (leg 0 0))

(define front-left-leg (leg (- matress-width leg-width) (- matress-length leg-length)))
(define front-right-leg (leg (- matress-width leg-width) 0))

(define head-cross-beam (cross-beam 0 0))
(define foot-cross-beam (cross-beam 0 (- matress-length cross-beam-length)))

(define rear-main-beam (main-beam 0 cross-beam-length))
(define centre-main-beam (main-beam (- centre-x (/ main-beam-width 2.0)) cross-beam-length))
(define front-main-beam (main-beam (- matress-width main-beam-width) cross-beam-length))

(define scene (append (list
                       rear-left-leg
                       rear-right-leg
                       front-left-leg
                       front-right-leg
                       foot-cross-beam
                       rear-main-beam
                       centre-main-beam
                       front-main-beam
                       head-cross-beam
                       )
                      (slat-range 0 0 matress-length 92)
                      ))


(render-top-down 3000 3000 scene "./freya-bed-top-down.png")
(render-from-left-side 3000 3000 scene "./freya-bed-from-left.png")
(render-isometric 4000 4000 scene "./freya-bed-isometric.png")

(for ([wood scene])
  (register-wood wood))
