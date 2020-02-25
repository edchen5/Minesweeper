import de.bezier.guido.*;

private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private final static int NUM_MINES = 1;

private MSButton[][] buttons; 
private ArrayList <MSButton> mines = new ArrayList(); 

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    Interactive.make(this);

    buttons = new MSButton [NUM_ROWS][NUM_COLS];

    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
            buttons[r][c] = new MSButton(r, c); 

    setMines();
}

public void setMines()
{
    while(mines.size() < NUM_MINES)
    {
        int r = (int)(Math.random() * NUM_ROWS);
        int c = (int)(Math.random() * NUM_COLS);

        if(mines.contains(buttons[r][c]))
            setMines(); 
        else 
            mines.add(buttons[r][c]);

        //System.out.println(r + " " + c);
    }
}

public void draw ()
{
    background(0);

    if(isWon() == true)
    {
        noLoop();
        displayWinningMessage();
    }
}

public boolean isWon()
{
    int mineCount = 0;
    int clickCount = 0;

    for(int i = 0; i < mines.size(); i++)
        if(mines.get(i).isFlagged() == true)
            mineCount++;
    
    for(int r = 0; r < buttons.length; r++)
        for(int c = 0; c < buttons[r].length; c++)
            if(buttons[r][c].isClicked())
                clickCount++;

    if(mineCount == NUM_MINES && clickCount == (NUM_ROWS * NUM_COLS) - NUM_MINES)
        return true;

    return false;
}

public void displayLosingMessage()
{
    
}

public void displayWinningMessage()
{
    buttons[NUM_ROWS / 2][NUM_COLS / 2].setLabel("Y");
}

public int countMines(int row, int col)
{
    int numMines = 0;
  
    for(int r = row - 1; r < row + 2; r++)
        for(int c = col - 1; c < col + 2; c++)
            if(isValid(r, c) == true && mines.contains(buttons[r][c]))
                numMines++;
         
    if(mines.contains(buttons[row][col]))
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
        if(mouseButton == LEFT)
            clicked = true;
        if(mouseButton == RIGHT && !clicked)
            flagged = !flagged;
        else if (mines.contains(this))
            displayLosingMessage();
        else if(countMines(myRow, myCol) > 0)
           setLabel(countMines(myRow, myCol));
        else
        {
            for(int r = myRow - 1; r < myRow + 2; r++)
                for(int c = myCol - 1; c < myCol + 2; c++)
                    if(isValid(r, c) && !buttons[r][c].isClicked() && !buttons[r][c].isFlagged())
                        buttons[r][c].mousePressed();
        }
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

    public boolean isClicked()
    {
        return clicked;
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


