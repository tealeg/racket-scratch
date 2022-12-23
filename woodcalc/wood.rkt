#lang racket/base

(require "block.rkt")

(define (register-wood b)
  (display (sort (list (block-width b) (block-height b) (block-length b)) <)))
(provide register-wood)
