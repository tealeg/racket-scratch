#lang s-exp "python.rkt"


(define service-name
  (λ (name)
    (import! "from flask import Flask")
    (state! (format "app = Flask(~v)" name))
    ))
  
(provide service-name (all-from-out "python.rkt"))
  
