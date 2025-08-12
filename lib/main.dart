import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Tic Tac Toe',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Arial'),
      home: TicTacToeGame(), 
      debugShowCheckedModeBanner: false, 
    );
  }
}

// Main game widget - This holds all the game logic and UI
class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  TicTacToeGameState createState() => TicTacToeGameState();
}

class TicTacToeGameState extends State<TicTacToeGame> {
  // Game state variables
  List<String> board = List.filled(9, ''); // 9 empty cells for the board
  String currentPlayer = 'X'; // Who's turn it is (X starts first)
  String winner = ''; // Stores the winner ('X', 'O', or 'Draw')
  bool isGameOver = false; // Flag to check if game has ended

  // Score tracking
  int xWins = 0; 
  int oWins = 0;
  int draws = 0;

  // This function handles when a player taps on a cell
  void makeMove(int cellIndex) {
    // Only allow move if cell is empty and game is not over
    if (board[cellIndex] == '' && !isGameOver) {
      setState(() {
        // Place current player's symbol in the cell
        board[cellIndex] = currentPlayer;

        // Check if current player won
        if (checkForWinner()) {
          winner = currentPlayer;
          isGameOver = true;
          // Update score
          if (currentPlayer == 'X') {
            xWins++;
          } else {
            oWins++;
          }
        }
        // Check if it's a draw (all cells filled, no winner)
        else if (board.every((cell) => cell != '')) {
          winner = 'Draw';
          isGameOver = true;
          draws++;
        }
        // Continue game - switch to other player
        else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  // Function to check if someone won the game
  bool checkForWinner() {
    // All possible winning combinations (rows, columns, diagonals)
    List<List<int>> winningPatterns = [
      // Rows
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      // Columns
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      // Diagonals
      [0, 4, 8], [2, 4, 6],
    ];

    // Check each winning pattern
    for (List<int> pattern in winningPatterns) {
      // If all three positions have the same non-empty symbol
      if (board[pattern[0]] != '' &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        return true; // We have a winner!
      }
    }
    return false; // No winner yet
  }

  // Reset the game board for a new game
  void startNewGame() {
    setState(() {
      board = List.filled(9, ''); // Clear all cells
      currentPlayer = 'X'; // X always starts
      winner = '';
      isGameOver = false;
    });
  }

  // Reset all scores to zero
  void resetAllScores() {
    setState(() {
      xWins = 0;
      oWins = 0;
      draws = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Score display section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // X player score
                  Column(
                    children: [
                      Text('Player X', style: TextStyle(fontSize: 16)),
                      Text(
                        '$xWins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Draw score
                  Column(
                    children: [
                      Text('Draws', style: TextStyle(fontSize: 16)),
                      Text(
                        '$draws',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // O player score
                  Column(
                    children: [
                      Text('Player O', style: TextStyle(fontSize: 16)),
                      Text(
                        '$oWins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20), // Space between sections
            // Game status display
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isGameOver
                    ? (winner == 'Draw' ? Colors.orange : Colors.green)
                    : Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                // Display appropriate message based on game state
                isGameOver
                    ? (winner == 'Draw'
                          ? "It's a Draw!"
                          : "Player $winner Wins! 🎉")
                    : "Player $currentPlayer's Turn",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 20),

            // The game board - 3x3 grid
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0, // Square shape
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 columns
                    crossAxisSpacing: 4, // Space between columns
                    mainAxisSpacing: 4, // Space between rows
                  ),
                  itemCount: 9, // 9 cells total
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => makeMove(index), // Handle tap on cell
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            board[index], // Show X, O, or empty
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: board[index] == 'X'
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 20),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // New Game button
                ElevatedButton(
                  onPressed: startNewGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text('New Game'),
                ),

                // Reset Scores button
                ElevatedButton(
                  onPressed: resetAllScores,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text('Reset Scores'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
