(ns day1.core)


(defn big [str n]
  "Returns true if string [str] is longer than [n]
   false otherwise"
   (> (count str) n))

;usage
(big "hello" 2)
(big "hello" 8)

(defn collection-type [col]
  "Returns :list, :map, :vector based on the
   type of collection [col]"
  (if (list? col) :list
    (if (map? col) :map
      (if (vector? col) :vector
        "None of the above"))))

(defn collection-type-cond [col]
  "Returns :list, :map, :vector based on the
   type of collection [col]"
  (cond
    (list? col) :list
    (map? col) :map
    (vector? col) :vector
    :else "None of the above"))


;usage
(collection-type [1,2,3])
(collection-type '(1,2,3))
(collection-type {:one 1, :two 2, :three 3})
(collection-type "huh")

(collection-type-cond [1,2,3])
(collection-type-cond '(1,2,3))
(collection-type-cond {:one 1, :two 2, :three 3})
(collection-type-cond "huh")

;standard stack consuming fib

(defn fib [n]
  (cond
    (= 0 n) 0
    (= 1 n) 1
    :else (+ (fib (- n 1)) (fib (- n 2)))))

;tail recursive fib using loop-recur
;loop-recur allow you to rebind variables each
;pass through. According to the docs it is the only non stack-consuming
;looping method in closure.
(defn fib-tail [n]
  (loop [num n, a1 0, a2 1]
    (if (= 0 num) a1
        (recur (- num 1), a2, (+ a1 a2)))))