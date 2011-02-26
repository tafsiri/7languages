//Experimenting with traits. 
trait Volume {
  //define some methods we need to use to implement the functionality of 
  //this trait, the class using this trait will need to implement these methods
  //concretely.
  def area() : Int
  def height : Int //this can also be a val

  //the functionality provided by this trait
  def volume() = {
    area() * height
  }
}

trait Shippable {
  def volume: Int
  
  //traits can also define their own concrete data
  def cost_per_unit_volume = 3.55
  
  def shipping_cost() = {
    volume * cost_per_unit_volume
  }
}

class Widget extends Volume with Shippable{
  val description = "I am a widget"
  val width = 5
  val length = 8
  val height = 10
  
  def area() = {
    width * length
  }
}

val w = new Widget
println(w.area())
println(w.volume())
println(w.shipping_cost())
