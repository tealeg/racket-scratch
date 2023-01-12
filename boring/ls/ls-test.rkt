#lang racket/base

(require rackunit "ls.rkt")
(require rackunit/text-ui)
(require rackunit/docs-complete)


(define ls-tests
  (test-suite "Tests for ls"
              (check-docs "ls.rkt")
              (test-case
                  "directory? identifies directories"
                (check-true (directory? (string->path "../ls")))
                (check-false (directory? (string->path "./ls.rkt")))
                )))

(run-tests ls-tests)


