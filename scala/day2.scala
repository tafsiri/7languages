val words = List("this", "is", "a", "list", "of", "strings")

//foldLeft function (currried)
var size = words.foldLeft(0)((sum, word) => sum + 1)
var charCount = words.foldLeft(0)((sum, word) => sum + word.length())

println(size)
println(charCount)

//foldleft operator
//I definitely prefer the curried function form, why do we need curly braces around this code
//block? Other function take code blocks without curly braces. Tate text doesn't explain
//what these variations arise from, which irks me somewhat.
charCount = (0 /: words) {(sum, word) => sum + word.length()} 
println(charCount)

object Censor{
  val defaultReplacements = Map("shoot" -> "pucky", "darn" -> "beans")
  
  def replace(input:String):String = {
    replace(input, defaultReplacements)
  }
  
  def replace2(input:String):String = {
    replaceWithPattern(input, defaultReplacements)
  }
  
  def replace3(input:String):String = {
    replaceWithBuiltin(input, defaultReplacements)
  }
  
  //A bit fragile in terms of splitting the string. also not dealing with case issues
  def replace(input:String, replacements:Map[String,String]):String = {
    input.split(" ").map(word => {
      if(replacements.get(word) == None) {
        word
      } else {
        replacements.get(word).get //get value from option
      }
    }).reduceLeft((result, word) => result + " " + word) //use reduceleft instead of foldleft to init it with first element of collection
  }
  
  //Use pattern matching to more elegantly handle the returned Option from Map.get
  def replaceWithPattern(input:String, replacements:Map[String,String]):String = {
    input.split(" ").map(word => replacements.get(word) match { // is match a method call or special form?
      case None => word
      case Some(x) => x
    }).reduceLeft((result, word) => result + " " + word)
  }
  
  //Try out the built in replaceAll on String
  def replaceWithBuiltin(input:String, replacements:Map[String,String]):String = {
    var result = input
    replacements.foreach(replacement_tuple => 
      result = result.replaceAll(replacement_tuple._1, replacement_tuple._2)
    )
    result
  }
}

val sentence = "This darn sentence has the word shoot"

println(Censor.replace(sentence))
println(Censor.replace2(sentence))
println(Censor.replace3(sentence))

//load replacements from a file.
import scala.io.Source
import scala.collection.mutable

val replacements = Source.fromFile("replacements.txt").getLines
                         .foldLeft(new mutable.HashMap[String, String])((map, line) => {
                            val pair = line.split(' ')
                            map += pair(0) -> pair(1)
                         }).toMap 
                         //why do i need to call toMap? HashMap extends Map right. 
                         //This is why http://scala-programming-language.1934581.n4.nabble.com/scala-HashMap-isn-t-a-Map-huh-td1987371.html

println(replacements)
println(Censor.replace(sentence, replacements)) 