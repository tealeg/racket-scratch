#lang s-exp "python.rkt"

(import! "from flask import Flask")
(state! "app = Flask('foo')")
(render)
