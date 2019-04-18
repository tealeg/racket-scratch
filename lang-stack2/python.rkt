#lang racket

(define imports empty)
(define statements empty)

(define import! (λ (statement)
                  (set! imports (cons  statement imports))
                  imports))

(define state! (λ (statement)
                 (set! statements (cons statement statements))
                 statements))

(define render (λ ()
                 (with-output-to-file "out.py" #:mode 'text #:exists 'replace
                   (λ () 
                     (displayln "#!/usr/bin/env python")
                     
                     (for/list ([i imports])
                       (displayln  i))

                     (displayln "")
                     (displayln "")

                     (for/list ([s statements])
                       (displayln s))))
                 "Done")
  )



(provide import! state! render statements imports (all-from-out racket))
