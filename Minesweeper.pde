import de.bezier.guido.*;

private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private final static int NUM_MINES = 5;

private MSButton[][] buttons = new MSButton [NUM_ROWS][NUM_COLS];; 
private ArrayList <MSButton> mines = new ArrayList(); 

void setup ()
{
    size(400, 470);
    textAlign(CENTER,CENTER);
    
    Interactive.make(this);

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
    int minesLeft = mines.size();

    background(0);

    stroke(255);
    rect(5, 405, 390, 60);

    for(int r = 0; r < buttons.length; r++)
        for(int c = 0; c < buttons[r].length; c++)
            if(buttons[r][c].isFlagged())
                minesLeft--;

    stroke(0);
    fill(255);
    textSize(15);

    text("Number of Mines: " + mines.size(), 90, 420);
    text("Number of Mines Left: " + minesLeft, 290, 420);

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
    for(int i = 0; i < mines.size(); i++)
        mines.get(i).setClicked(true);

    fill(255);
    textSize(20);

    text("You Lose!", 200, 450);
    textSize(15);
}

public void displayWinningMessage()
{
    fill(255);
    textSize(20);

    text("You Win!", 200, 450);

    textSize(15);
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

public boolean isValid(int row, int col)
{
  if(row >= 0 && row < NUM_ROWS && col >= 0 && col < NUM_COLS)
    return true;

  return false;
}

public void keyPressed()
{
    for(int r = 0; r < buttons.length; r++)
        for(int c = 0; c < buttons[r].length; c++)
        {
            buttons[r][c].setFlagged(false);
            buttons[r][c].setClicked(false);
            buttons[r][c].setLabel("");
        }

    for(int i = mines.size() - 1; i >= 0; i--)
        mines.remove(i);

    setMines();

    loop();
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

        Interactive.add(this); 
    }

    public void mousePressed() 
    {
        if(mouseButton == LEFT && !flagged)
            clicked = true;

        if(mouseButton == RIGHT && !clicked)
            flagged = !flagged;
        else if(!flagged && mines.contains(this))
        {
            for(int r = 0; r < buttons.length; r++)
                for(int c = 0; c < buttons[r].length; c++)
                    buttons[r][c].setFlagged(false);

            displayLosingMessage();

            noLoop();
        }
        else if(clicked && countMines(myRow, myCol) > 0)
           setLabel(countMines(myRow, myCol));
        else
        {
            if(!flagged)
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
            fill(255, 0, 0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(myLabel, x + width / 2, y + height / 2);
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

    public void setFlagged(boolean newFlag)
    {
        flagged = newFlag;
    }

    public void setClicked(boolean newClick)
    {
        clicked = newClick;
    }
}


