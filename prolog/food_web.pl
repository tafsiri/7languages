/* Facts 
  http://commons.wikimedia.org/wiki/File:Chesapeake_Waterbird_Food_Web.jpg
*/
eats(small_planktivorous_fish, phytoplankton).
eats(bivalves, phytoplankton).
eats(benthic_invertebrates, phytoplankton).

eats(bivalves, zooplankton).

eats(herbivorous_ducks, submerged_aquatic_vegetation).

eats(geese, vegetation).
eats(mute_swan, vegetation).
eats(tundra_swan, vegetation).

eats(sea_ducks, benthic_invertebrates).

eats(herbivorous_ducks, bivalves).
eats(sea_ducks, bivalves).
eats(tundra_swan, bivalves).

eats(large_piscivorous_fish, small_planktivorous_fish).
eats(wading_birds, small_planktivorous_fish).
eats(gulls, small_planktivorous_fish).
eats(terns, small_planktivorous_fish).

eats(bald_eagle, sea_ducks).
eats(bald_eagle, large_piscivorous_fish).
eats(osprey, large_piscivorous_fish).

/* define the extinct rule, so that prolog doesn't complain it doesn't
   exist for non extinct creatures */
extinct(dodo).
extinct(small_planktivorous_fish).

/* Rules */
dinner_friends(X, Y) :- eats(X, Z), eats(Y, Z), \+(X = Y).
ally(X,Y) :- eats(Z,X), eats(Z,Y), \+(X = Y), \+(eats(X,Y)).

/* Recursion: a creature has food if there is a non extinct creature 
   they eat that also has food. Add some rules at the bottom of the food 
   chain to indicate that they do not 'eat' */
has_food(phytoplankton).
has_food(vegetation).
has_food(submerged_aquatic_vegetation).
has_food(X) :- eats(X,Z), \+extinct(Z), has_food(Z).

/* If a Var is passed in, this really means, does no one have food!*/
has_no_food(X) :- \+(has_food(X)).

/* Queries */

ally(bivalve, Who).
dinner_friends(sea_ducks, Who).
/* list everyone who has food */
has_food(Who).
/* no, because of the extinction of small_planktivorous_fish */
has_food(osprey).
/* yes, they can still eat sea ducks */
has_food(bald_eagle).
