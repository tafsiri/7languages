magic_square(Puzzle, Solution) :-
  Puzzle = [S11, S12, S13,
            S21, S22, S23,
            S31, S32, S33],

  fd_all_different(Puzzle),
  fd_domain(Puzzle, 1, 9),
  fd_labeling(Puzzle),   /* This line is very important to actually seeing the answers*/
  
  R1 = [S11, S12, S13],
  R2 = [S21, S22, S23],
  R3 = [S31, S32, S33],
  
  C1 = [S11, S21, S31],
  C2 = [S12, S22, S32],
  C3 = [S13, S23, S33],
  
  Diag1 = [S11, S22, S33],
  Diag2 = [S13, S22, S31],

  sum_list(R1, Sum1),
  sum_list(R2, Sum2),
  sum_list(R3, Sum3),
  sum_list(C1, Sum4),
  sum_list(C2, Sum5),
  sum_list(C3, Sum6),
  sum_list(Diag1, Sum7),
  sum_list(Diag2, Sum8),
  
  Sum1 = Sum2,
  Sum2 = Sum3,
  Sum3 = Sum4,
  Sum4 = Sum5,
  Sum5 = Sum6,
  Sum6 = Sum7,
  Sum7 = Sum8,

  Solution = Puzzle.