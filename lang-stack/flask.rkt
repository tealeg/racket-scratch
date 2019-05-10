#lang racket

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (read src-lines))
  (define module-datum `(module flask-mod "flask.rkt" ,@src-lines))
  (datum->syntax #f module-datum))

(define-syntax (flask-module-begin stx)
  #'(#%module-begin stx))
  ;; (syntax-parse stx
  ;;   [(id SERVICE-EXPR ...)
  ;;    #'(#%module-begin
  ;;       'SERVICE-EXPR ...
  ;;       )]
  ;;   [else (raise-syntax-error (error-source "flask-module-begin") "invalid serivce expression" (syntax->datum SERVICE-EXPR))]
    ;; ))

(provide (rename-out [flask-module-begin #%module-begin]))
