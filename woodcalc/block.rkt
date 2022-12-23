#lang racket/base

(struct block (length width height x y z colour))
(provide (struct-out block))

(define (rotate-90-degrees source)
  (struct-copy block source
               [length (block-width source)]
               [width (block-length source)]))
(provide rotate-90-degrees)

