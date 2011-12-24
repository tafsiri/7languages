(ns day-3
  (:use clojure.contrib.pprint))

;Q1 use refs to create a vector of accounts in memory. Create debit and credit
;   functions to change the balance of an account
;   Note: I'm going to use a map instead of a vector so that accounts can have names

(def bank (ref { }))

(defn make-account [bank account-name balance]
  (dosync 
    (alter bank (conj {account-name, balance})))) 

;Note: alter calls 'apply fn @ref args'
;      so these next two definitions do not work because they
;      result in '(merge-with @bank - {account-name, amount})'
(defn debit-account-incorrect [bank account-name amount]
  (dosync 
    (alter bank merge-with - {account-name, amount})))

(defn credit-account-incorrect [bank account-name amount]
  (dosync 
    (alter bank merge-with + {account-name, amount})))

;Use a let binding to hold the newly calculated balance before altering the ref
(defn debit-account [bank account-name amount]
  (dosync
    (let 
      [new-balance (- (get @bank account-name) amount)]
      (alter bank assoc account-name new-balance))))

(defn credit-account [bank account-name amount]
  (dosync
    (let 
      [new-balance (+ (get @bank account-name) amount)]
      (alter bank assoc account-name new-balance))))


;Create some accounts  
(add-account bank "nick" 10)
(add-account bank "nicole" 10)
(println (pprint bank))  ;not entirely sure how to get pprint to work how i want (still need a print)

;Apply some transactions
(debit-account bank "nick" 3)
(credit-account bank "nicole" 2)
(println (pprint bank))