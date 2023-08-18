+++
title = "Some Scheme I'm proud of"
date = 2023-08-15
draft = true
+++

```lisp
; From the book definition
(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

; Mostly me, but got help with this. SICP calls this fringe.
(define (flatten x)
  (cond ((null? x) nil)
        ((not (pair? x)) (list x))
        (else (append (flatten (car x))
                      (flatten (cdr x))))))

; All me. We love a lil deep-map action.
(define (deepmap proc x)
  (cond ((not (pair? x)) (proc x))
        ((null? (cdr x))
         (if (pair? (car x))
             (list (deepmap proc (car x)))
             (list (proc (car x)))))
        (else (append (list (deepmap proc (car x)))
                      (deepmap proc (cdr x))))))

; This is a better version that I found in the book later
(define (deepmap proc lst)
  (cond ((null? lst) nil)
        ((not (pair? lst)) (proc lst))
        (else (cons (deepmap proc (car lst))
                    (deepmap proc (cdr lst))))))

; Corollary that falls out of the above
(define (flatmap proc x)
  (map proc (flatten x)))
```