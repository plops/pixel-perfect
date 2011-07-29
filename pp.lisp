(eval-when (:compile-toplevel)
  (setf asdf:*central-registry* '("/home/martin/0505/mma/"))
  (require :gui))
(defpackage :r
  (:use :cl :gl))

(in-package :r)

#+nil(dotimes (i 100)
  (sleep (/ 16))
  (defparameter *r* (/ i 100s0))
  (format t "~a~%" *x*))

(defparameter *x* 0)
(defparameter *y* 0)

(let ((bla nil))
 (defun draw-screen ()
   (clear :color-buffer-bit)
   (line-width 2)
   (rect (+ *x* 100) 10 (+ *x* 200) 20)
   (dotimes (j 100)
     (with-primitive :lines
       (vertex (+ *x* (* 2 j) 100) (+ 55 *y*))
       (vertex (+ *x* (* 2 j) 100) (+ *y* 100))
       (vertex (+ 55 *x*) (+ *y* (* 3 j) 100) )
       (vertex (+ *x* 100) (+ *y* (* 3 j) 100))))
   (sleep (/ 32))))

#+nil
(let ((x 700)
      (y 100))
  (sb-thread:make-thread
   #'(lambda ()
       (gui:with-gui ((- 1280 x) 700 x y)
	 (draw-screen)))
   :name "camera-display"))
