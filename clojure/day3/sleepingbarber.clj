;The sleeping barber problem http://en.wikipedia.org/wiki/Sleeping_barber_problem
; Q. Calculate how many haircuts can be done in 10 seconds
;    One barber, one barber chair
;    Three chairs in waiting room
;    Customers arrive at random intervals 10-30ms apart
;    Haircuts take 20ms
; (ns day-3
;   (:use clojure.contrib.pprint))
  
  
;Model the chair and waiting room as vectors wrapped in refs
(def barber-chair (ref []))
(def waiting-room (ref []))
(def num-cuts (ref 0))
(def num-turnaway (ref 0))

(declare cut-hair get-next-customer)

;Sleeps for 20ms then vacates the barber-chair
;Will also check the waiting room after doing a haircut
(defn cut-hair []
  (do
    (Thread/sleep 20)
    (dosync
      (ref-set barber-chair [])
      (alter num-cuts + 1)
      (get-next-customer))))

(defn get-next-customer []
  (if (not (empty? @waiting-room)) ;i don't think this check needs to be in the transaction
    (do
    (dosync
      (let 
        [next-customer (first @waiting-room)]
        (ref-set barber-chair [next-customer])
        (alter waiting-room rest)))
     (cut-hair))))      ; note this call to cut hair in the same thread

(defn customer-arrive [customer]
  ;take the barber chair or a seat in the waiting room
  (dosync
    (if (empty? @barber-chair)
      (do
        (ref-set barber-chair [customer])     ;put the customer in the chair
        
        ;use of future-call to run this in its own thread
        ;note: this may be seem technically incorrect (or maybe unorthodox) as the cut-hair 
        ;function would use a different thread each time called from this location. 
        ;However this function will not be called if the barber is already cutting hair. i.e.
        ;it is equivalent to waking the barber up.
        ;General clojure question, do the things backing a future need to be cleaned up? they hold onto
        ;their return value until dereferenced, so if never deference the return val, then what? 
        
        (future-call cut-hair))   
      (if (< (count @waiting-room) 3)
        (alter waiting-room concat [customer])      ;put the customer in the waiting room
        (alter num-turnaway + 1)))))

;To send the customers to the barber at different intervals
;we use the future macro, this will run the body passed to the
;macro in its own thread. I believe this macro is a wrapper around future-call
(def send-customers
  (future
    (while true 
      (do
        (Thread/sleep (+ 10 (rand-int 20)))
        (customer-arrive :cust) ;they could all have unique names but whatevs
        ))))

(Thread/sleep (* 10 1000))
(println @num-cuts)
(println @num-turnaway)
(shutdown-agents)
