(ns day1.core)


(defn big [str n]
  "Returns true if string [str] is longer than [n]
   false otherwise"
   (> (count str) n))
  
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


(collection-type-cond [1,2,3])
(collection-type-cond '(1,2,3))
(collection-type-cond {:one 1, :two 2, :three 3})
(collection-type-cond "huh")