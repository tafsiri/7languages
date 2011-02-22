def checkBoard(board : Array[Array[String]]) : String = {
  
  def row(board : Array[Array[String]], index : Int) = {
    board(index)
  }
  
  def col(board : Array[Array[String]], index : Int) = {
    board.map { row => row(index)}
  }
  
  def winner(line : Array[String]) = {
    if(!line(0).equals("_") && line(0).equals(line(1)) && line(1).equals(line(2))){
      true
    }
    else {
     false
    }
  }
  
  def boardIsFull(board : Array[Array[String]]) : Boolean = {
    board.foreach { row =>
        row.foreach { element => if(element == "_")
         return false
        }
    }
    return true
  }
  
  val rows = (0 to board.size-1).map { index => row(board, index)}
  val cols = (0 to board.size-1).map { index => col(board, index)}
  val diag1 = Array(board(0)(0), board(1)(1), board(2)(2))
  val diag2 = Array(board(0)(2), board(1)(1), board(2)(0))
  
  val lines = rows ++ cols ++ Array(diag1, diag2)
  //check for winner
  lines.foreach { line =>
    if(winner(line)) {
      return "WINNER"
    }
  }
  
  //check if it is a tie. if the board is full its a tie
  if(boardIsFull(board)){
    return "TIE"
  }
  
  return "no winner"
}

def printBoard(board : Array[Array[String]]) = {
  board.foreach { row => println("" + row(0) + " | "
                                    + row(1) + " | "
                                    + row(2) )}
}

def play(mark: String, pos : List[Int], board : Array[Array[String]]) = {
  board(pos(0))(pos(1)) = mark
}

var board = Array(Array("_", "_", "_"),
                  Array("_", "_", "_"),
                  Array("_", "_", "_")
                 )

printBoard(board)

play("X", List(1,1), board)
println(checkBoard(board))
printBoard(board)

play("X", List(0,0), board)
println(checkBoard(board))
printBoard(board)

play("X", List(2,2), board)
println(checkBoard(board))
printBoard(board)