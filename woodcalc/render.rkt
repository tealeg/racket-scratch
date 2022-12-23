#lang racket/base


(require racket/class)
(require racket/draw)

(require "block.rkt")


(define (render-block dc x y width height colour)
    ;; (display (~a (list x y width height)))
    ;; (newline)
  (send dc set-brush colour 'solid)
  (send dc draw-rectangle x y width height)
  (send dc set-font (make-font #:size 20))
  (send dc draw-text (string-append (number->string x) "," (number->string y)) x y))

(provide render-block)  

(define (render-top-down width height blocks filename)
  (define target (make-bitmap width height))
  (define dc (new bitmap-dc% [bitmap target]))

  (for ([obj blocks])
    (render-block dc 
     (block-x obj)
     (block-y obj)
     (block-width obj)
     (block-length obj)
     (block-colour obj)))

  (send target save-file filename 'png))
(provide render-top-down)  

(define (render-from-left-side width height blocks filename)
  (define target (make-bitmap width height))
  (define dc (new bitmap-dc% [bitmap target]))

  (for ([obj blocks])
    (render-block
     dc
     (block-y obj)
     (- height (+ (block-z obj) (block-height obj)))
     (block-length obj)
     (block-height obj)
     (block-colour obj)))

  (send target save-file filename 'png))
(provide render-from-left-side)
