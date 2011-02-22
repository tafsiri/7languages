import scala.util.Random

class Game{
  
  val board = Array(Array("_", "_", "_"),
                    Array("_", "_", "_"),
                    Array("_", "_", "_"))

  var currentPlayer = "X"
  
  //play a turn. takes a mark (X or O) and a tuple indicating the 
  //row & column of the play
  def play(mark: String, pos : List[Int]) : Boolean = {
    if(mark == currentPlayer && board(pos(0))(pos(1)) == "_"){
      board(pos(0))(pos(1)) = mark
      //swap the current player
      if(currentPlayer == "X") { currentPlayer = "O"} else { currentPlayer = "X"}
      
      return true
    }
    else {
      return false
    }
  }
  
  /*
    Returns the status of the game. Checks if there is a winner, draw or no winner.
  */
  def status : String = {
    //some nested helper functions
    def row(index : Int) = {
      board(index)
    }
  
    def col(index : Int) = {
      board.map { row => row(index)}
    }
    
    //is this line (row, col or diag) a winning line
    def winner(line : Array[String]) = {
      if(!line(0).equals("_") && line(0).equals(line(1)) && line(1).equals(line(2))){
        true
      }
      else {
       false
      }
    }
  
    def boardIsFull() : Boolean = {
      board.foreach { row =>
          row.foreach { element => if(element == "_")
           return false
          }
      }
      return true
    }
  
    //get the rows, columns and diagonals from the board array into arrays
    //of three elements each
    val rows = (0 to board.size-1).map { index => row(index)}
    val cols = (0 to board.size-1).map { index => col(index)}
    val diag1 = Array(board(0)(0), board(1)(1), board(2)(2))
    val diag2 = Array(board(0)(2), board(1)(1), board(2)(0))
  
    val lines = rows ++ cols ++ Array(diag1, diag2)
    
    //Check the status of the board
    
    //Check for a winner
    lines.foreach { line =>
      if(winner(line)) {
        return "WINNER is " + line(0)
      }
    }
  
    //If the board is full it is a tie
    if(boardIsFull()){
      return "TIE"
    }

    return "UNFINISHED"
  }

  def printBoard = {
    board.foreach { row => println("" + row(0) + " | "
                                      + row(1) + " | "
                                      + row(2) )}
  }
}

val rand = new Random
val game = new Game

while(game.status == "UNFINISHED"){
  game.printBoard
  println(game.currentPlayer + "'s turn.\n")
  var valid = false
  do {
    val row = rand.nextInt(3)
    val col = rand.nextInt(3)
    valid = game.play(game.currentPlayer , List(row,col))
  } while(valid == false)
}

//print final state.
game.printBoard
println(game.status)