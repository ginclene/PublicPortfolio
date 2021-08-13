; This is a comment - your code should ignore these

; A recursive program
(define fact
  (lambda (n) ; Computes n!
     (if (< n 1)
     ; then
         1
     ; else
        (* n (fact (- n 1)))
     ); end if
   ); end lambda
); end fact

(fact 4)

; Problem 5.6 converted to scheme
(define x 0)
(define sub1 (lambda (x)
     ( ; this open paren is to _call_ sub2
         (lambda ()  ; this lambda function is sub2
          (sub3) ; this calls sub3
          ) ; this ends sub2
      ) ; this close paren ends the _call_ to sub2
     )  ;end the lambda for sub1
 ) ; end the define for sub1

(define sub3 (lambda () x)) ; returns x, whatever that is
(sub1 2)
