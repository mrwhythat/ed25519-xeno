(uiop:define-package :ed25519/core/low-level
    (:use :cl)
  (:export
   ;; data
   #:int8
   #:int32
   #:int64
   #:bytes
   ;; operations
   #:<<
   #:>>
   #:loadint))

(in-package :ed25519/core/low-level)

(declaim (optimize (speed 3) (safety 0)))


(deftype int8 () '(signed-byte 8))

(deftype int32 () '(signed-byte 32))

(deftype int64 () 'fixnum)

(deftype bytes (size) `(simple-array (unsigned-byte 8) ,size))


(declaim (ftype (function (int8 (unsigned-byte 3)) int8) shl8))
(defun shl8 (n shift)
  (the int8 (ash n shift)))

(declaim (ftype (function (int8 (unsigned-byte 3)) int8) shr8))
(defun shr8 (n shift)
  (the int8 (ash n (- shift))))

(declaim (ftype (function (int32 (unsigned-byte 5)) int32) shl32))
(defun shl32 (n shift)
  (the int32 (ash n shift)))

(declaim (ftype (function (int32 (unsigned-byte 5)) int32) shr32))
(defun shr32 (n shift)
  (the int32 (ash n (- shift))))

(declaim (ftype (function (int64 (unsigned-byte 6)) int64) shl64))
(defun shl64 (n shift)
  (the int64 (ash n shift)))

(declaim (ftype (function (int64 (unsigned-byte 6)) int64) shr64))
(defun shr64 (n shift)
  (the int64 (ash n (- shift))))

(defmacro << (n shift width)
  (ecase width
    (8  `(shl8  ,n ,shift))
    (32 `(shl32 ,n ,shift))
    (64 `(shl64 ,n ,shift))))

(defmacro >> (n shift width)
  (ecase width
    (8  `(shr8  ,n ,shift))
    (32 `(shr32 ,n ,shift))
    (64 `(shr64 ,n ,shift))))

(declaim (ftype (function ((unsigned-byte 3) (bytes *)) int64) loadint))
(defun loadint (n in)
  (loop
     :with r :of-type int64 := 0 
     :for i :below n
     :do (setf r (logior r (<< (aref in i) (* i 8) 64)))
     :finally (return r)))
