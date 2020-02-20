import de.bezier.guido.*;
int NUM_ROWS = 5;
int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );

    //your code to initialize buttons goes here
    buttons = new MSButton [NUM_ROWS][NUM_COLS];

    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
            buttons[r][c] = new MSButton(r, c); 
    
    
    setMines();
}

public void setMines()
{
    int x = (int)(Math.random() * NUM_ROWS);
    int y = (int)(Math.random() * NUM_COLS);
    if(mines.contains(buttons[x][y]))
        setMines(); 
    else 
        mines.add(buttons[x][y]);
}

public void draw ()
{
    background(0);

    if(isWon() == true)
        displayWinningMessage();
}

public boolean isWon()
{
    //your code here
    return false;
}

public void displayLosingMessage()
{
    //your code here
}

public void displayWinningMessage()
{
    //your code here
}

public int countMines(int row, int col)
{
    int numMines = 0;
  
    for(int r = row - 1; r < row + 2; r++)
        for(int c = col - 1; c < col + 2; c++)
            if(isValid(r, c) == true && buttons[r][c] == true)
                numMines++;
         
    if(buttons[row][col] == true)
        numMines--;
        
    return numMines;
}

public boolean isValid(int row, int col){
  if(row >= 0 && row < NUM_ROWS && col >= 0 && col < NUM_COLS)
    return true;

  return false;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton (int row, int col)
    {
        width = 400 / NUM_COLS;
        height = 400 / NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol * width;
        y = myRow * height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add(this); // register it with the manager
    }

    // called by manager
    public void mousePressed() 
    {
        clicked = true;
        if(mouseButton == RIGHT)
            flagged = !flagged;
            if(flagged == false)
                clicked = false;
        else if(mines.contains(this))
            displayLosingMessage();
    }

    public void draw() 
    {    
        if(flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }

    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }

    public void setLabel(int newLabel)
    {
        myLabel = "" + newLabel;
    }

    public boolean isFlagged()
    {
        return flagged;
    }
}
