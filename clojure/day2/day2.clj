(ns day2)

;Q1 Implement unless (example given in the book) but add an 'else' clause

; & is used to define optional params
(defmacro unless [test truebody &[falsebody]]
  (list 'if test falsebody truebody))

; this is another way to support optional params
(defmacro unless 
  ([test truebody] (list 'if (list 'not test) truebody))
  ([test truebody falsebody] (list 'if test falsebody truebody)))  
  
(unless (> 1 3) (println "t1: not greater than"))
(unless (> 1 3) (println "t2: not greater than") (println "t2: greater than"))
(unless (> 5 3) (println "t3: not greater than") (println "t3: greater than"))

;A function definition can invoke the function with a different argument list
;A way of providing default params (or supporting optional params)
;so far i cant seem to do this with macros (but i haven't tried very hard)
(defn echo
  ([] (echo "echo"))
  ([stuff] (concat (take 3 (repeat stuff)))))

(println (echo))
(println (echo "hi"))

;Q1 Write a type with defrecord and protocol

(defprotocol Performer 
  "Performers come in all forms"
  (perform [this] "Perform your talent")
  (demand  [this] "Make a demand")
  (act-out [this] "Act out in dramatic fashion")
)

(defrecord RealityStar []
  Performer
  (perform [_] (println "I already am!"))
  (demand  [_] (println "I demand you keep me on this show"))
  (act-out [_] (println "Gonna hoard all the tp in this house!"))
  )

(defrecord RockStar []
  Performer
  (perform [_] (println "Party like a rock—Party like a rockstar!"))
  (demand  [_] (println "Bring me an empanada from that old Columbian lady in Staten Island. You know who i mean"))
  (act-out [_] (println "I'm shutting down the studio!"))
  )
  
;usage

;create values of the two record types
(def tyree (RealityStar. ))
(def tron (RockStar. ))

;call functions with the values. The correct implementation will be selected based on type
(demand tyree)
(demand tron)

(act-out tyree)
(act-out tron)