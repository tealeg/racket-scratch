#lang racket/base
;; ls is a program that lists the contents of a directory.  If no path
;; is provided on the command line, it operates on the current working
;; directory.

;; In a really simple program like this, it's quite nice to use this
;; "only-in" form of the require-spec, so we can see exactly what
;; we're bringing in from each library.
(require (only-in racket/cmdline command-line))
(require (only-in racket/format ~a))
(require (only-in racket/path file-name-from-path))
(require (only-in racket/list last))


(define (list-directory-all cpath)
  (directory-list cpath #:build? #f))

(define (directory? p)
  (let ([t (file-or-directory-type p #t)])
    (eq? t 'directory)))

(provide directory?)

(define (format-list-item start-pos path)
  (values  (string-append-immutable
                                    (path->string (last (explode-path path)))
                                    (if (directory? path)
                                        " *"
                                        "")
                                    (~a #\newline))
          0))
  
(define (format-directory-list p ls)
  (let [(cpath (path->complete-path p (current-directory)))
        (indent 0)]
    (foldl (lambda (item result)
             (let [(citem (path->complete-path item cpath))]
               (let-values ([(str pos) (format-list-item indent citem)])
                 (set! indent pos)
                 (string-append-immutable result str))))
           ""
           (ls cpath))))



;; ls-path will hold the String form of the user-provided path. 
(define ls-path (make-parameter "."))

;; Entrance Point
;; --------------
;; This is now the "main" part of the program.

;; parse the command-line arguments to ls
(command-line #:program "ls" 
              #:args ls-paths (when (> (length ls-paths) 0)
                                  (ls-path (car ls-paths))))



(display (format-directory-list (string->path (ls-path))
                                list-directory-all
                                ))
