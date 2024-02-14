//Javier Escobedo
//CS 3310
//Professor Ling Xu
//Game: Automata Architect

import java.awt.Point;
import java.util.Arrays;
import java.lang.Math.*;

//GENERAL
int[] rule = new int[8];// Stores the rule set; 256 possible rules
int[] rule1 = new int[8];// Rule Set for the levles
int size = 512;// Stores the size of matrix that will store the automata.
ArrayList<ArrayList<Cell>> auto = new ArrayList<ArrayList<Cell>>();// Stores Main automata structure
int[] gameModes = {0,0,0,1,0,0};//{sandbox, levels, main menu, title, infinite levels, tutorial}
int winX = 1500, winY = 900;// Pixel Size of the window that displays the automata
ArrayList<Integer> renderLines = new ArrayList<Integer>();// Stores the rows that are calculated for line by line rendering
int lineSpeed = 1;// The number of rows that are calculated in line by line rendering
Point controlCell = new Point(size,1);// The point for the cell highlight
boolean showControl = true;// To draw cell highlight

//MENU
boolean menuTitleFoward = true;// For menu title animation
boolean showJustBackground = false;// To show background only

//LEVELS
ArrayList<ArrayList<Cell>> auto1 = new ArrayList<ArrayList<Cell>>();// Automata for levels
int wait = 0;// in frames
//Usable rules for levels and randomizing
int[][] levelRules = {{2, 6, 14, 4, 16, 20, 84, 1, 5, 3, 17, 19, 18, 22, 30, 86, 9, 73, 75, 99, 129, 225, 201, 135, 151, 133, 94, 78, 126, 110},
                      {7, 11, 13, 15, 21, 23, 25, 27, 28, 29, 37, 39, 41, 45, 47, 50, 51, 53, 54, 57, 59, 60, 61, 62, 65, 67, 69, 70, 71, 77, 79},
                      {81, 83, 85, 89, 91, 92, 93, 97, 101, 102, 103, 105, 107, 109, 111, 115, 117, 118, 121, 123, 124, 125, 131, 137, 139, 141, 143, 145, 147, 149},
                      {150, 153, 155, 157, 158, 163, 165, 167, 169, 173, 175, 177, 179, 181, 182, 185, 187, 188, 189, 190, 193, 195, 197, 199, 203, 205, 206, 207, 209, 211, 213, 214, 217, 219, 220, 221, 222, 227, 229, 230, 231, 233, 235, 237, 239, 243, 245, 246, 249, 251, 253}};
int level = 0;// Current Level
int stage = 0;// Current Section of levels
boolean showLevels = true;// To Draw level selection
int moves = 0;// Num of moves for levels
int lastMove = -1;// Index of rule of last move
int[][] levelCompleted = new int[3][30];// To keep track of levels completed
boolean allLevelsComplete = false;
ArrayList<Integer> allRules = new ArrayList<Integer>(); // Stores all useable rule
int infLevelsComplete = 0;// For indefinite levels
int infBatchesComplete = 0;
int infCells = 5;// Number of random cells for indefinite levels
int infSize = 32;// Automata size for indefinite levels 

//SANDBOX
int sizeDiff = 4;// SizeDiff is the difference when adjusting the size of the matrix
ArrayList<Point> pCells = new ArrayList<Point>();// Stores persistent cells, will not be overwritten
ArrayList<Point> renderPoints = new ArrayList<Point>();// Stores the points that are calculated for cell by cell rendering
int[] renderModes = {0, 1, 0};//{automatic, line by line, cell by cell}
Point zoom = new Point(size/2, 0), zoom1 = new Point(size*3/2-1, size/2); // Points to enable zooming functionality
float zoomFactor = 1.0;// Zooming scale
boolean showCells = true;// To draw cells
boolean showBranches = false;// To draw branches
int tutorialState = 0;// To step through the tutorial
int cX = 70, cY = 75;// For tutorial animation
int mX = 0, mY = 0;// For stabalizing zooming out

//TITLE
int titleStep = 0;// To step through title animation
//Stores Title
int[][] titleSteps = {{0, 0,1,2,3,0, 0,0, 1,0,0,0,15,0,0, 1,2,3,4,5, 0,0, 0,1,2,3,0, 0,0,0, 1,0,0,0,5, 0,0, 0,1,2,3,0, 0,0, 1,2,3,4,5, 0,0, 0,1,2,3,0, 0},
                      {0, 2,0,0,0,4, 0,0, 2,0,0,0,14,0,0, 0,0,3,0,0, 0,0, 2,0,0,0,4, 0,0,0, 2,2,0,4,5, 0,0, 2,0,0,0,4, 0,0, 0,0,3,0,0, 0,0, 2,0,0,0,4, 0},
                      {0, 3,0,0,0,5, 0,0, 3,0,0,0,13,0,0, 0,0,4,0,0, 0,0, 3,0,0,0,5, 0,0,0, 3,0,3,0,5, 0,0, 3,0,0,0,5, 0,0, 0,0,4,0,0, 0,0, 3,0,0,0,5, 0},
                      {0, 4,0,0,0,6, 0,0, 4,0,0,0,12,0,0, 0,0,5,0,0, 0,0, 4,0,0,0,6, 0,0,0, 4,0,0,0,6, 0,0, 4,0,0,0,6, 0,0, 0,0,5,0,0, 0,0, 4,0,0,0,6, 0},
                      {0, 5,5,6,7,7, 0,0, 5,0,0,0,11,0,0, 0,0,6,0,0, 0,0, 5,0,0,0,7, 0,0,0, 5,0,0,0,7, 0,0, 5,5,6,7,7, 0,0, 0,0,6,0,0, 0,0, 5,5,6,7,7, 0},
                      {0, 6,0,0,0,8, 0,0, 6,0,0,0,10,0,0, 0,0,7,0,0, 0,0, 6,0,0,0,8, 0,0,0, 6,0,0,0,8, 0,0, 6,0,0,0,8, 0,0, 0,0,7,0,0, 0,0, 6,0,0,0,8, 0},
                      {0, 7,0,0,0,9, 0,0, 0,7,8,9,0, 0,0, 0,0,8,0,0, 0,0, 0,7,8,9,0, 0,0,0, 7,0,0,0,9, 0,0, 7,0,0,0,9, 0,0, 0,0,8,0,0, 0,0, 7,0,0,0,9, 0},
                      
                      {0,0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0, 0,0,0,0},
                      {0,0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0, 0,0,0,0,0, 0,0, 0,0,0,0},
                      
                      {0,1,2,3,0, 0,0, 1,2,3,4,0, 0,0, 0,1,2,3,0, 0,0, 1,0,0,0,9, 0,0, 1, 0,0, 1,2,3,4,5, 0,0, 1,2,3,4,5, 0,0, 0,1,2,3,0, 0,0, 1,2,3,4,5},
                      {2,0,0,0,4, 0,0, 2,0,0,0,5, 0,0, 2,0,0,0,0, 0,0, 2,0,0,0,8, 0,0, 2, 0,0, 0,0,3,0,0, 0,0, 2,0,0,0,0, 0,0, 2,0,0,0,0, 0,0, 0,0,3,0,0},
                      {3,0,0,0,5, 0,0, 3,0,0,0,6, 0,0, 3,0,0,0,0, 0,0, 3,0,0,0,7, 0,0, 3, 0,0, 0,0,4,0,0, 0,0, 3,0,0,0,0, 0,0, 3,0,0,0,0, 0,0, 0,0,4,0,0},
                      {4,0,0,0,6, 0,0, 4,0,0,0,7, 0,0, 4,0,0,0,0, 0,0, 4,4,5,6,7, 0,0, 4, 0,0, 0,0,5,0,0, 0,0, 4,4,5,6,7, 0,0, 4,0,0,0,0, 0,0, 0,0,5,0,0},
                      {5,5,6,7,7, 0,0, 5,5,6,7,0, 0,0, 5,0,0,0,0, 0,0, 5,0,0,0,7, 0,0, 5, 0,0, 0,0,6,0,0, 0,0, 5,0,0,0,0, 0,0, 5,0,0,0,0, 0,0, 0,0,6,0,0},
                      {6,0,0,0,8, 0,0, 6,0,0,0,8, 0,0, 6,0,0,0,0, 0,0, 6,0,0,0,8, 0,0, 6, 0,0, 0,0,7,0,0, 0,0, 6,0,0,0,0, 0,0, 6,0,0,0,0, 0,0, 0,0,7,0,0},
                      {7,0,0,0,9, 0,0, 7,0,0,0,9, 0,0, 0,7,8,9,0, 0,0, 7,0,0,0,9, 0,0, 7, 0,0, 0,0,8,0,0, 0,0, 7,7,8,9,10,0,0, 0,7,8,9,0, 0,0, 0,0,8,0,0}};



    
// Initialization of program, runs only once
void setup()
{
  size(1900, 1068);// Sets the size of the program window

  //Put all useful rules into an array list
  for(int y = 0; y < levelRules.length; y++)
    for(int x = 0; x < levelRules[y].length; x++)
      allRules.add(levelRules[y][x]);

  //Properly size the 2D array lists that store the automata
  resetAuto(size);
  resetAuto1(32);
  
  //Set the middle cell of the top row to 1
  auto.get(0).get(size).type = 1;
  auto1.get(0).get(size).type = 1;
  
  //Set up level 1
  rule1 = getRule(stage, level);
  auto1 = calculateAuto(auto1, rule1);
  
  //Intitialize array lists for rendering
  renderLines.add(1);
  if(renderModes[2] == 1)
    renderPoints.add(new Point(0,1));
}

// Runs the whole game; draws 1 frame
void draw()
{
  //Sandbox
  if(gameModes[0] == 1)
    drawMain();
  
  //Levels
  if(gameModes[1] == 1)
  {
    if(showLevels)// Draws Level selection
    {
      drawBackgroundAutomata();
      drawLevels();
    }
    else// Draws a level
    {
      //Waiting is done
      if(wait > 0 && frameCount >= wait)
      {
        wait = 0;
        
        if(level+1 < 30)
          level++;
        else if(stage+1 < 4)
        {
          stage++;
          level = 0;
        }
        if(stage == 2)
        {
          //clearTopRow1();
          randomInitialConditions1(5);
        }

        rule = new int[8];
        resetAuto(32);
        if(stage < 2)
          auto.get(0).get(size).type = 1;
        else
          auto.set(0,auto1.get(0));
        moves = 0;
        lastMove = -1;
        rule1 = getRule(stage, level);
        auto1 = calculateAuto(auto1, rule1);
        
        if(stage == 3)
        {
          showLevels = true;
          stage = 2;
          lastMove = -1;
          moves = 0;
          rule = getRandomRule();
          resetAuto(512);
          randomInitialConditions();
        }
      }
      
      //Level Complete, Waiting Begins
      if(Arrays.equals(rule, rule1) && wait == 0)
      {
        drawMain();
        drawLevelInfo();
        if(moves == numberOfOnes(rule1))
          levelCompleted[stage][level] = 2;
        else
          levelCompleted[stage][level] = 1;
        wait = frameCount+60;
      }
      
      // Continues drawing after level is completed
      if(wait > 0)
      {
        println(renderLines.size());
        drawMain();
        drawLevelInfo();
      }
        
      //Main Gameplay, No Waiting
      if(wait == 0 && !showLevels)
      {
        rule1 = getRule(stage, level);
        auto1 = calculateAuto(auto1, rule1);
        drawMain();
        drawLevelInfo();
      }
    }
  }
  
  //Main Menu
  if(gameModes[2] == 1)
    if(showJustBackground)
      drawBackgroundAutomata();
    else
      drawMenu();
    
  //Title
  if(gameModes[3] == 1)
  {
    if(titleStep == 0)//Sets up background
    {
      rule = getRandomRule();
      renderLines.add(1);
      randomInitialConditions();
      titleStep++;
    }
    drawBackgroundAutomata();
    
    if(titleStep <= 23)// Title animation
      drawTitle();
    else
    {
      gameModes[3] = 0;
      gameModes[2] = 1;
    }
  }
  
  //Infinite Levels
  if(gameModes[4] == 1)
  {
    /*
    if(infLevelsComplete == -1)
    {
      rule1 = getRandomRule();
      randomInitialConditions1(infCells);
      auto1 = calculateAuto(auto1, rule1);
      infLevelsComplete++;
      stage = 1;
    }*/
    //Waiting is done
    if(wait > 0 && frameCount >= wait)
    {
      wait = 0;
      if(moves == numberOfOnes(rule1))
        infLevelsComplete++;
      if(infLevelsComplete%2 == 0)
        infCells++;
      moves = 0;
      lastMove = -1;
      infSize += 2;
      resetAuto(infSize);
      resetAuto1(infSize);
      rule = new int[8];
      rule1 = getRandomRule();
      zoom = new Point(size/2, 0);
      zoom1 = new Point(size*3/2-1, size/2);
      randomInitialConditions1(infCells);
      auto1 = calculateAuto(auto1, rule1);
    }
    
    //Level Complete, Waiting Begins
    if(Arrays.equals(rule, rule1) && wait == 0)
    {
      drawMain();
      drawInfiniteLevels();
      drawLevelInfo();
      //rule = new int[8];
      wait = frameCount+60;

    }
    else if (Arrays.equals(rule, rule1) && wait > 0)
    {
      drawMain();
      drawInfiniteLevels();
      drawLevelInfo();
    }
    
    //Main Gameplay, No Waiting
    if(wait == 0)
    {
      //rule1 = getRandomRule();
      //auto1 = calculateAuto(auto1, rule1);
      drawMain();
      drawInfiniteLevels();
      drawLevelInfo();
    }
  }
  
  //Tutorial
  if(gameModes[5] == 1)
  {
    
    int n = 6;
    if(tutorialState == 0)
    {
      drawMain();
      fill(255);
      stroke(0);
      rect(480,300, 700, 200);
      textSize(50);
      fill(0);
      text("Welcome to Automata Architect", 500, 350);
      textSize(30);
      text("Press Enter to continue", 685, 430);
      text((tutorialState+1)+"/"+n, 490, 490);
      drawList(auto,0,0,0,255);
    }
    
    if(tutorialState == 1)
    {
      drawMain();
      fill(255);
      stroke(0);
      rect(480,300, 700, 200);
      textSize(30);
      fill(0);
      text("The basis of Automata Architect is something called\nelementary cellular automata or 1D automata.", 500, 350);
      text("Press Enter to continue", 685, 460);
      text((tutorialState+1)+"/"+n, 490, 490);
      drawList(auto,0,0,0,255);
    }
    
    if(tutorialState == 2)
    {
      drawMain();
      drawList(auto,0,0,0,255);
      fill(255);
      stroke(0);
      rect(100,100, 1300, 700);
      textSize(30);
      fill(0);
      text("Each cell can either be on (black) or off (white) which is determined by the set of rules. The rules look\nat the cell's previous state as well as its neighbor's states, hence the T-block shapes.", 120, 145);
      text("Press Enter to continue", 615, 750);
      text((tutorialState+1)+"/"+n, 110, 790); 
      fill(255);
      rect(675, 300, 150, 150);
      rect(525, 300, 150, 150);
      rect(825, 300, 150, 150);
      rect(675, 450, 150, 150);  
      textSize(20);
      fill(0);
      text("Left Neighbor\nPrevious State", 540,365);
      text("Previous State", 690,380);
      text("Right Neighbor\nPrevious State", 840,365);
      text("Current State", 695,530);
    }
    
    if(tutorialState == 3)
    {
      rule = new int[8];
      rule[1] = 1;
      rule[2] = 1;
      rule[3] = 1;
      rule[4] = 1;
      drawMain();
      fill(255);
      stroke(0);
      rect(480,910, 700, 150);
      textSize(30);
      fill(0);
      text("Above is a cell by cell rendition of Rule 30.", 570, 945);
      text("Press Enter to continue", 685, 1040);
      text((tutorialState+1)+"/"+n, 490, 1053);
      
      //println(mouseX+" "+mouseY);
      drawList(auto,0,0,0,255);
      drawControlCell(cX, cY);
      
      int distX = Math.abs(zoom1.x-zoom.x)+1, distY = Math.abs(zoom1.y-zoom.y)+1;
      int y = cY*distY/winY + zoom.y, x = cX*distX/winX + zoom.x;
      if(x == zoom.x+1)
        calculateOneCell(x-1, y);    
      if(x == zoom1.x-1)
        calculateOneCell(x+1, y);
      if(cY > 70)
        calculateOneCell(x, y);
      
      if(cX+winX/distX/4 < winX)
        cX += winX/distX/4;
      else
      {
        cX = 70;
        if(cY+winY/distY < winY)
          cY += winY/distY;
        else
        {
          cY = 75;
          auto.clear();
          for (int y1 = 0; y1 <= size/2; y1++)
          {
            auto.add(new ArrayList<Cell>());
            for (int x1 = -size/2; x1 <= size*3/2; x1++)
              auto.get(y1).add(new Cell(x1, y1, 0));
          }
          auto.get(0).get(size).type = 1;
        }
      }  
    }
    
    if(tutorialState == 4)
    {
      drawMain();
      setRenderMode(1);
      drawList(auto,0,0,0,255);
      fill(255);
      stroke(0);
      rect(1250, 910, 600, 150);
      textSize(30);
      fill(0);
      text("Click the boxes above to change the rule", 1297, 945);
      text("Press Enter to continue", 1420, 1040);
      text((tutorialState+1)+"/"+n, 1260, 1053);
    }
    
    if(tutorialState == 5)
    {
      drawMain();
      //setRenderMode(1);
      drawList(auto,0,0,0,255);
      fill(255,230);
      stroke(255);
      rect(1255, 905, 605, 155);
      stroke(0);
      rect(400, 100, 700, 700);
      textSize(30);
      fill(0);
      text("That is Automata Architect in a nutshell. There a two\nmain game modes, levels and sandbox. In levels you\nmatch your pattern to the target pattern by changing\nthe rule. In sandbox you manipulate the automata to\nyour hearts content.", 420, 140);
      text("Press Enter to go back to Main Menu", 520, 700);
      text((tutorialState+1)+"/"+n, 410, 792);
    }
    
    if(tutorialState == 6)
    {
      gameModes[5] = 0;
      gameModes[2] = 1;
      
      //Reset Everything
      rule = getRandomRule();
      resetAuto(512);
      randomInitialConditions();
      renderLines.add(1);
    }
    fill(255);
    stroke(0);
    rect(34,934, 100, 100);
    drawBackArrow(55,971);
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DRAWING FUNCTIONS
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Calculates and draws several components for the levels and sandbox modes
void drawMain()
{
  background(255);// Sets the background color to white
  fill(0);// Sets the color of shpaes to black
  stroke(0);

  line(0, winY, winX, winY);//Lines to define the automata window
  line(winX, 0, winX, winY);

  drawRules();// Draws the rule set along with active rules

  if(renderModes[0] == 1 && gameModes[5] == 0)
    auto = calculateAuto(auto, rule);
  if(renderLines.size() > 0 && renderModes[1] == 1)
    lineAuto();
  if(renderPoints.size() > 0 && renderModes[2] == 1)
    pointAuto();
    
  if(gameModes[1] == 1||gameModes[4] == 1)
  {  
    drawUnion();
  }
  if(gameModes[0] == 1)
  {
    if(showCells)
      drawGrid();
    if(showBranches)
      drawBranches();
    drawInfo();
  }
  drawOtherStuff();
  if(gameModes[0] == 1||(gameModes[1] == 1&&!showLevels))
    drawControlCell(mouseX, mouseY);
  stroke(0);
  fill(0);
  drawBackArrow(55,971); 
}

//Draws its 2D ArrayList Cells given its color perameters
void drawList(ArrayList<ArrayList<Cell>> auto, int r, int g, int b, int t)
{
  stroke(0);
  for (int y = 0; y < auto.size(); y++)//Fits Matrix in a box
  {
    for (int x = auto.get(y).size()/4; x < auto.get(y).size()*3/4; x++)
    {
      if (auto.get(y).get(x).type == 1)
      {
        fill(r,g,b,t);
        rect(auto.get(y).get(x).x*winX/(auto.get(y).size()/2), auto.get(y).get(x).y*winY/(auto.size()), winX/(auto.get(y).size()/2), winY/auto.size());
      }
      if (isPersistent(auto.get(y).get(x).y, auto.get(y).get(x).x) && auto.get(y).get(x).type == 0)
      {
        fill(255);
        rect(auto.get(y).get(x).x*winX/(auto.get(y).size()/2), auto.get(y).get(x).y*winY/auto.size(), winX/(auto.get(y).size()/2), winY/auto.size());
      }
    }
  }
}

//Draws a section of a 2D ArrayList of Cells for Zooming
void drawGrid()
{
  int distX = Math.abs(zoom1.x-zoom.x)+1, distY = Math.abs(zoom1.y-zoom.y)+1;
  stroke(0);
  for (int y = zoom.y; y <= zoom1.y; y++)//Fits Matrix in a box
  {
    for (int x = zoom.x; x <= zoom1.x; x++)
    {
      if(auto.get(y).get(x).type == 1)
      {
        fill(0);
        rect( (auto.get(y).get(x).x-auto.get(y).get(zoom.x).x) * winX / (distX), (y-zoom.y) * winY / (distY), winX/(distX), winY/distY);
      }
      if (isPersistent(y, auto.get(y).get(x).x) && auto.get(y).get(x).type == 0)
      {
        fill(255);
        rect( (auto.get(y).get(x).x-auto.get(y).get(zoom.x).x) * winX / (distX), (y-zoom.y) * winY / (distY), winX/distX, winY/distY);
      }
    }
  }
}

//Draws connections between cells
void drawBranches()
{
  int distX = Math.abs(zoom1.x-zoom.x)+1, distY = Math.abs(zoom1.y-zoom.y)+1;
  stroke(255,0,0);
  int zY = zoom.y;
  if(zY-1 > 0)
    zY--;
  for (int y = zY; y <= zoom1.y && y < auto.size()-1; y++)//Fits Matrix in a box
  {
    for (int x = zoom.x-1; x <= zoom1.x; x++)
    {
      if (auto.get(y).get(x).type == 1)
      {
        if (auto.get(y+1).get(x-1).type == 1 && auto.get(y).get(x-1).type == 0)
        {
          if(y == zoom1.y)
            line((auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y-zoom.y)*winY/(distY) + winY/distY/2, (auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX), (y+1-zoom.y)*winY/(distY));
          else
            line((auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y-zoom.y)*winY/(distY) + winY/distY/2, (auto.get(y).get(x-1).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y+1-zoom.y)*winY/(distY) + winY/distY/2);
        }
          
        if (auto.get(y+1).get(x).type == 1)
        {
          if(y == zoom1.y)
            line((auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y-zoom.y)*winY/(distY) + winY/distY/2, (auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, winY);
          else
            line((auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y-zoom.y)*winY/(distY) + winY/distY/2, (auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y+1-zoom.y)*winY/(distY) + winY/distY/2);
        }
        
        if (auto.get(y+1).get(x+1).type == 1 && auto.get(y).get(x+1).type == 0)
        {
          if(y == zoom1.y||x == zoom1.x)
            line((auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y-zoom.y)*winY/(distY) + winY/distY/2, (auto.get(y).get(x+1).x-auto.get(y).get(zoom.x).x)*winX/(distX), (y+1-zoom.y)*winY/(distY));
          else
            line((auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y-zoom.y)*winY/(distY) + winY/distY/2, (auto.get(y).get(x+1).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y+1-zoom.y)*winY/(distY) + winY/distY/2);
        }
        
        if(y > 0 && x == zoom1.x && auto.get(y-1).get(x).type == 0 && auto.get(y-1).get(x+1).type == 1)
          line((auto.get(y).get(x).x-auto.get(y).get(zoom.x).x)*winX/(distX) + winX/distX/2, (y-zoom.y)*winY/(distY) + winY/distY/2, (auto.get(y).get(x+1).x-auto.get(y).get(zoom.x).x)*winX/(distX), (y-zoom.y)*winY/(distY));
          
      }
    }
  }
}

//Draw an 2 2D Arraylists overlayed over each other for levels
void drawUnion()
{
  for (int y = 0; y < auto.size(); y++)//Fits Matrix in a box
  {
    for (int x = auto.get(y).size()/4; x < auto.get(y).size()*3/4; x++)
    {
      if (auto.get(y).get(x).type == 1)
      {
        fill(200);
        stroke(200);
        rect(auto.get(y).get(x).x*winX/(auto.get(y).size()/2), auto.get(y).get(x).y*winY/(auto.size()), winX/(auto.get(y).size()/2), winY/auto.size());
      }
      if (auto1.get(y).get(x).type == 1)
      {
        stroke(100);
        fill(100);
        rect(auto.get(y).get(x).x*winX/(auto.get(y).size()/2), auto.get(y).get(x).y*winY/(auto.size()), winX/(auto.get(y).size()/2), winY/auto.size());
      }
      if (auto.get(y).get(x).type == 1 && auto1.get(y).get(x).type == 1)
      {
        stroke(0);
        fill(0);
        rect(auto.get(y).get(x).x*winX/(auto.get(y).size()/2), auto.get(y).get(x).y*winY/(auto.size()), winX/(auto.get(y).size()/2), winY/auto.size());
      }
    }
  }
}

//Draws Cell by Cell indecator and Sandbox buttons, icons, & text
void drawOtherStuff()
{
  stroke(255, 0, 0);
   fill(255,0);
  if(renderModes[2] == 1)
  {
    for (int i = 0; i < renderPoints.size(); i++)
    {
      int x = renderPoints.get(i).x, y = renderPoints.get(i).y;
      if(x > auto.get(y).size()/4 && x < auto.get(y).size()*3/4)
        rect(auto.get(y).get(x).x*winX/(auto.get(y).size()/2), auto.get(y).get(x).y*winY/(auto.size()), winX/(auto.get(y).size()/2), winY/auto.size());
    }
  }
  stroke(0);

  if(gameModes[0] == 1)
  {
    fill(255);
    rect(34,934, 100, 100);
    
    if(showCells)
      fill(0);
    else
      fill(255);
    rect(168, 912, 68, 68);//Toggle Cells
    if(showCells)
      fill(255);
    else
      fill(0);
    rect(195, 925, 14, 19);
    rect(181, 944, 14, 19);
    rect(209, 944, 14, 19);
    fill(255);
    
    if(renderModes[0] == 1)
      fill(0);
    else
      fill(255);
    rect(168, 992, 68, 68);//Automatic Render
    fill(255);
    rect(195, 998, 14, 19);
    rect(181, 998, 14, 19);
    rect(209, 998, 14, 19);
    rect(195, 1017, 14, 19);
    rect(181, 1017, 14, 19);
    rect(209, 1017, 14, 19);
    rect(195, 1036, 14, 19);
    rect(181, 1036, 14, 19);
    rect(209, 1036, 14, 19);    
    
    if(showBranches)
      fill(0);
    else
      fill(255);
    rect(248, 912, 68, 68);//Toggle Branches
    stroke(255,0,0);
    line(282,917,282,957);
    line(282,957,265,974);
    line(282,940,299,959);
    line(299,959,299,974);
    stroke(0);
 
    if(renderModes[1] == 1)
      fill(0);
    else
      fill(255);
    rect(248, 992, 68, 68);//Line by line render
    fill(255);
    rect(275, 1017, 14, 19);
    rect(261, 1017, 14, 19);
    rect(289, 1017, 14, 19);
    
    if(showControl)
      fill(0);
    else
      fill(255);
    rect(328, 912, 68, 68);// Cell Control
    stroke(255,0,0);
    rect(355, 925, 14, 19);
    rect(341, 925, 14, 19);
    rect(369, 925, 14, 19);
    rect(355, 944, 14, 19);
    stroke(0);
    
    if(renderModes[2] == 1)
      fill(0);
    else
      fill(255);
    rect(328, 992, 68, 68);//Cell by cell render
    fill(255);
    rect(355, 1017, 14, 19);
    //drawBackArrow(55,971);
    
    rect(1420, 912, 68, 68);//Random Initial Conditions
    fill(0);
    textSize(40);
    text("?", 1445,970);
    fill(255);
    rect(1429, 915, 10, 15);
    fill(0);
    rect(1439, 915, 10, 15);
    fill(255);
    rect(1449, 915, 10, 15);
    rect(1459, 915, 10, 15);
    fill(0);
    rect(1469, 915, 10, 15);
    fill(255);
    
    rect(1420, 992, 68, 68);//Random Rule
    fill(0);
    textSize(40);
    text("?", 1445,1040);
    fill(0);
    rect(1469, 998, 7, 7);
    fill(255);
    rect(1469, 1005, 7, 7);
    fill(0);
    rect(1469, 1012, 7, 7);
    rect(1469, 1019, 7, 7);
    fill(255);
    rect(1469, 1026, 7, 7);
    fill(0);
    rect(1469, 1033, 7, 7);
    fill(255);
    rect(1469, 1040, 7, 7);
    rect(1469, 1047, 7, 7);
    
    
    rect(1340, 912, 68, 68);//Clear Automata
    rect(1348, 920, 52, 52);
    
    rect(1340, 992, 68, 68);//Reset Size
    fill(0);
    circle(1374,1026,52);
    fill(255);
    circle(1374,1026,22);
    
    fill(0);
    textSize(50);
    text("Size: "+size, 1520,960);
    text("Zoom: "+nf(1/zoomFactor, 0, 2), 1520,1040);
    
  }
}

//Draws the main menu
void drawMenu()
{
  drawBackgroundAutomata();
  drawMenuTitle();
  fill(0);
  stroke(0);
  textSize(30);
  text("By Javier Escobedo", 1200, 130);
  
  if(mouseX > 650 && mouseX < 1250 && mouseY > 150 && mouseY < 300)
    fill(0,230);
  else
    fill(255,230);
  rect(650, 150, 600, 150);
  
  if(mouseX > 650 && mouseX < 1250 && mouseY > 330 && mouseY < 480)
    fill(0,230);
  else
    fill(255,230);
  rect(650, 330, 600, 150);
  
  if(mouseX > 650 && mouseX < 1250 && mouseY > 510 && mouseY < 660)
    fill(0,230);
  else
    fill(255,230);
  rect(650, 510, 600, 150);
  
  if(mouseX > 650 && mouseX < 1250 && mouseY > 690 && mouseY < 840)
    fill(0,230);
  else
    fill(255,230);
  rect(650, 690, 600, 150);
  
  if(allLevelsComplete)
  {
    if(mouseX > 650 && mouseX < 1250 && mouseY > 870 && mouseY < 1020)
      fill(0,230);
    else
      fill(255,230);
    rect(650, 870, 600, 150);
  }
  
  textSize(50);
  
  if(mouseX > 650 && mouseX < 1250 && mouseY > 150 && mouseY < 300)
    fill(255);
  else
    fill(0);
  text("Tutorial", 870, 240);
  
  if(mouseX > 650 && mouseX < 1250 && mouseY > 330 && mouseY < 480)
    fill(255);
  else
    fill(0);
  text("Levels", 880, 420);
  
  if(allLevelsComplete)
  {
    if(mouseX > 650 && mouseX < 1250 && mouseY > 510 && mouseY < 660)
      fill(255);
    else
      fill(0);
    text("Indefinite Levels", 780, 600);
    
    if(mouseX > 650 && mouseX < 1250 && mouseY > 690 && mouseY < 840)
      fill(255);
    else
      fill(0);
    text("Sandbox", 855, 780);
    
    if(mouseX > 650 && mouseX < 1250 && mouseY > 870 && mouseY < 1020)
      fill(255);
    else
      fill(0);
    text("Quit", 900, 960);
  }
  else
  {
    if(mouseX > 650 && mouseX < 1250 && mouseY > 510 && mouseY < 660)
      fill(255);
    else
      fill(0);
    text("Sandbox", 855, 600);
    
    if(mouseX > 650 && mouseX < 1250 && mouseY > 690 && mouseY < 840)
      fill(255);
    else
      fill(0);
    text("Quit", 900, 780);
  } 
}

//Draws the background animation for 1 frame
void drawBackgroundAutomata()
{
  background(255);
  
  if(renderLines.size() > 0)
    lineAuto();
  stroke(50);
  for (int y = 0; y < auto.size(); y++)//Fits Matrix in a box
  {
    for (int x = auto.get(y).size()/4; x < auto.get(y).size()*3/4; x++)
    {
      if (auto.get(y).get(x).type == 1)
      {
        fill(50);
        rect(auto.get(y).get(x).x*width/(auto.get(y).size()/2), auto.get(y).get(x).y*height/(auto.size()), width/(auto.get(y).size()/2), height/auto.size());
      }
    }
  }
  
  if(frameCount%128 == 0)
  {
    rule = getRandomRule();
    renderLines.add(1);
    randomInitialConditions();
  }
  
  if(showJustBackground && mouseX > 650 && mouseX < 1250 && mouseY > 510 && mouseY < 660)
  {
    fill(255,230);
    rect(650, 510, 600, 150);
    textSize(50);
    fill(0);
    text("Open in Sandbox", 775, 600);
  }
}

//Draws main title sequence
void drawTitle()
{
    stroke(255);
    int titleWidth = 1700, titleHeight = 900, titleX = 100, titleY = 100;
    for (int y = 0; y < titleSteps.length; y++)//Fits Matrix in a box
    {
      for (int x = 0; x < titleSteps[y].length; x++)
      {
        if (titleSteps[y][x] <= titleStep && titleSteps[y][x] > 0)
        {
          fill(0);
          rect(x*titleWidth/(titleSteps[y].length) + titleX, y*titleHeight/(titleSteps.length) + titleY, titleWidth/(titleSteps[y].length), titleHeight/titleSteps.length);
        }
      }
    }
    
    if(frameCount%8 == 0)
      titleStep++;
}

//Draws the title for the main menu
void drawMenuTitle()
{
    stroke(255);
    int titleWidth = 800, titleHeight = 200, titleX = 110, titleY = 20;
    for (int y = 0; y < titleSteps.length; y++)//Fits Matrix in a box
    {
      for (int x = 0; x < titleSteps[y].length; x++)
      {
        if(titleSteps[y][x] <= titleStep && titleSteps[y][x] > 0)
        {
          if (y < 7)
          {
            fill(0);
            rect(x*titleWidth/(titleSteps[y].length) + titleX, y*titleHeight/(titleSteps.length) + titleY, titleWidth/(titleSteps[y].length), titleHeight/titleSteps.length);
          }
          if(y > 8)
          {
            fill(0);
            rect((x+titleSteps[y].length+4)*titleWidth/(titleSteps[y].length) + titleX, (y-9)*titleHeight/(titleSteps.length) + titleY, titleWidth/(titleSteps[y].length), titleHeight/titleSteps.length);
          }
        }
      }
      if(y == 7)
        y = 8;
    }
    
    if(frameCount%8 == 0 && menuTitleFoward && titleStep+1 < 16)
      titleStep++;
    if(frameCount%8 == 0 && !menuTitleFoward && titleStep-1 > 0)
      titleStep--;
    if(mouseX > 110 && mouseX < 1710 && mouseY > 20 && mouseY < 130)
      menuTitleFoward = false;
    else
      menuTitleFoward = true;
}

//Draws the level selection menu
void drawLevels()
{
  textSize(70);
  stroke(0);
  
  //Levels
  int levelNum = stage*30 + 1;
  for(int y = 0; y < 6; y++)
  {
    for(int x = 0; x < 5; x++)
    {
      if(stage < 3)
      {
        if(levelCompleted[stage][(levelNum-1)%30] == 2)
          fill(0);
        else if(levelCompleted[stage][(levelNum-1)%30] == 1)
          fill(128);
        else
          fill(255);
          
        rect(550+x*150, 84+y*150, 130,130);
        
        if(levelCompleted[stage][(levelNum-1)%30] >= 1)
          fill(255);
        else
          fill(0);
      
        if(levelNum < 10)
          text(""+levelNum, 600+x*150, 174+y*150);
        if(levelNum >= 10)
          text(""+levelNum, 580+x*150, 174+y*150);
        levelNum++;
      }
    }
  }
  
  //Back To Menu Button
  fill(255);
  rect(0,0,100,100);
  pushMatrix();
    fill(0);
    rect(30,40,60,20);
    translate(30, 37); // move the origin to the pivot point
    rotate(radians(45)); // rotate the coordinate system 
    rect(0, 0, 60, 20);
    rotate(radians(-90));
    rect(0, 0, 40, 20); 
   popMatrix();
  
  //Previous Levels Buttons
  if(stage > 0)
  {
    fill(255);
    rect(45,484,65,100);
    pushMatrix();
      fill(0);
      translate(65, 519); // move the origin to the pivot point
      rotate(radians(45)); // rotate the coordinate system 
      rect(0, 0, 60, 20);
      rotate(radians(-90));
      rect(0, 0, 40, 20); 
    popMatrix();
  }
  
  //Next Levels Button
  if(stage < 2)
  {
    fill(255);
    rect(1790,484,65,100);
    pushMatrix();
      fill(0);
      translate(1838, 549); // move the origin to the pivot point
      rotate(radians(135)); // rotate the coordinate system 
      rect(0, 0, 40, 20);
      rotate(radians(90));
      rect(0, 0, 60, 20); 
    popMatrix();
  }
}

//Draws buttons and text for indefinite levels
void drawInfiniteLevels()
{
  fill(255);
  stroke(0);
  rect(34,934, 100, 100);
  drawBackArrow(55,971);
  fill(0);
  textSize(50);
  text("Levels Completed: "+infLevelsComplete, 190, 999);
  text("Moves "+moves+"/"+numberOfOnes(rule1), 1000, 999);
  fill(0);
  circle(773,984,80);
  fill(255);
  circle(773,984,40);
}

//Draws the cell highlight
void drawControlCell(int pX, int pY)
{
  stroke(255, 0, 0);
  fill(255);
  int distX = Math.abs(zoom1.x-zoom.x)+1, distY = Math.abs(zoom1.y-zoom.y)+1;
  if(pX < winX && pY < winY)
  {
    controlCell.x = pX*distX/winX + zoom.x;
    controlCell.y = pY*distY/winY + zoom.y;
  }
  int x = controlCell.x, y = controlCell.y;
  if(showControl && x > zoom.x && x < zoom1.x && y > 0 && y <= zoom1.y)
  {
    fill(0,0,0,0);
    strokeWeight(4);
    rect((auto.get(y).get(x).x-auto.get(y).get(zoom.x).x) * winX / (distX), (y-zoom.y) * winY / (distY), winX/distX, winY/distY);
    rect((auto.get(y-1).get(x-1).x-auto.get(y).get(zoom.x).x) * winX / (distX), (y-1-zoom.y) * winY / (distY), winX/distX, winY/distY);
    rect((auto.get(y-1).get(x).x-auto.get(y).get(zoom.x).x) * winX / (distX), (y-1-zoom.y) * winY / (distY), winX/distX, winY/distY);
    rect((auto.get(y-1).get(x+1).x-auto.get(y).get(zoom.x).x) * winX / (distX), (y-1-zoom.y) * winY / (distY), winX/distX, winY/distY);
    
    
    if(auto.get(y-1).get(x-1).type == 0 && auto.get(y-1).get(x).type == 0 && auto.get(y-1).get(x+1).type == 0)
      rect(1600, 100, 100, 100);
    if(auto.get(y-1).get(x-1).type == 0 && auto.get(y-1).get(x).type == 0 && auto.get(y-1).get(x+1).type == 1)
      rect(1600, 200, 100, 100);
    if(auto.get(y-1).get(x-1).type == 0 && auto.get(y-1).get(x).type == 1 && auto.get(y-1).get(x+1).type == 0)
      rect(1600, 300, 100, 100);
    if(auto.get(y-1).get(x-1).type == 0 && auto.get(y-1).get(x).type == 1 && auto.get(y-1).get(x+1).type == 1)
      rect(1600, 400, 100, 100);
    if(auto.get(y-1).get(x-1).type == 1 && auto.get(y-1).get(x).type == 0 && auto.get(y-1).get(x+1).type == 0)
      rect(1600, 500, 100, 100);
    if(auto.get(y-1).get(x-1).type == 1 && auto.get(y-1).get(x).type == 0 && auto.get(y-1).get(x+1).type == 1)
      rect(1600, 600, 100, 100);
    if(auto.get(y-1).get(x-1).type == 1 && auto.get(y-1).get(x).type == 1 && auto.get(y-1).get(x+1).type == 0)
      rect(1600, 700, 100, 100);
    if(auto.get(y-1).get(x-1).type == 1 && auto.get(y-1).get(x).type == 1 && auto.get(y-1).get(x+1).type == 1)
      rect(1600, 800, 100, 100);
      
    strokeWeight(1);
  }
}

//Draws the tool tips, or info, depending on what's under the mouse for sandbox mode
void drawInfo()
{
  String info = "";
  
  if(mouseX < winX && mouseY < winY)
  {
    int distX = Math.abs(zoom1.x-zoom.x)+1, distY = Math.abs(zoom1.y-zoom.y)+1;
    int x = mouseX*distX/winX + zoom.x, y = mouseY*distY/winY + zoom.y;
    info = "Click to Toggle Cell (x = "+auto.get(y).get(x).x+", y = "+y+")" ;
    if(1/zoomFactor > 1)
      info += "\nClick & Drag to Shift";
  }
  
  if(mouseX > 1600 && mouseX < 1700)
  {
    if(mouseY > 100 && mouseY < 200)
      info = "Toggle Rule 1";
    if(mouseY > 200 && mouseY < 300)
      info = "Toggle Rule 2";
    if(mouseY > 300 && mouseY < 400)
      info = "Toggle Rule 4";
    if(mouseY > 400 && mouseY < 500)
      info = "Toggle Rule 8";
    if(mouseY > 500 && mouseY < 600)
      info = "Toggle Rule 16";
    if(mouseY > 600 && mouseY < 700)
      info = "Toggle Rule 32";
    if(mouseY > 700 && mouseY < 800)
      info = "Toggle Rule 64";
    if(mouseY > 800 && mouseY < 900)
      info = "Toggle Rule 128";
  }
  
  if(mouseX > 34 && mouseX < 134 && mouseY > 934 && mouseY < 1034)
    info = "Back to Menu";
    
  if(mouseY > 912 && mouseY < 980)
  {
     if(mouseX > 168 && mouseX < 236)
       info = "Toggle Showing Cells";
     if(mouseX > 248 && mouseX < 316)
       info = "Toggle Showing Branches";
     if(mouseX > 328 && mouseX < 396)
       info = "Toggle Showing Cell Highlight";
     if(mouseX > 1340 && mouseX < 1408)
       info = "Clear Automata";
     if(mouseX > 1420 && mouseX < 1488)
       info = "Random Initial Conditions";
  }

  if(mouseY > 992 && mouseY < 1060)
  {
     if(mouseX > 168 && mouseX < 236)
       info = "Render Automatically";
     if(mouseX > 248 && mouseX < 316)
       info = "Render Line by Line";
     if(mouseX > 328 && mouseX < 396)
       info = "Render Cell by Cell";
     if(mouseX > 1340 && mouseX < 1408)
       info = "Reset Automata";
     if(mouseX > 1420 && mouseX < 1488)
       info = "Random Rule";
  }

  if(mouseX > 1510 && mouseX < 1730 && mouseY > 910 && mouseY < 980)
    info = "Left Key to Decrease Size\nRight Key to Increase Size";  
  if(mouseX > 1510 && mouseX < 1760 && mouseY > 992 && mouseY < 1062)
    info = "Scroll Up to Zoom In\nScroll Down to Zoom Out";   
  if(mouseX > 1590 && mouseX < 1740 && mouseY > 30 && mouseY < 80)
    info = "Up Key to Increment Rule\nDown Key to Decrement Rule"; 
  if(mouseX > 600 && mouseX < 1100 && mouseY > 920 && mouseY < 990)
    info = "!!!HELLO!!! \n:)"; 
     
  textSize(50);
  textAlign(CENTER);
  text(info, 850, 960);
  textAlign(LEFT);
}

//Draws the info text and buttons for levels
void drawLevelInfo()
{
  String info = "What Rule Produces the Pattern?";
  if(stage == 0)
  {
    if(level == 0)
    {
      if(numberOfOnes(rule) == 1)
      {
        if(rule[0] == 1 || rule[2] == 1)
          info = "Not Quite";
        else if(rule[1] == 1)
          info = "Correct! That wasn't so hard";
        else if(rule[4] == 1)
          info = "No!";
        else
          info = "That didn't do anything";
      }
      if(numberOfOnes(rule) > 1)
        info = "TOO MANY RULES!!";
    }
    
    else if(level == 1)
    {
      if(numberOfOnes(rule) == 1)
      {
        if(rule[0] == 1 || rule[4] == 1)
          info = "Not Quite";
        else if(rule[1] == 1 || rule[2] == 1)
          info = "Almost There";
        else
          info = "That didn't do anything";
      }   
      if(numberOfOnes(rule) == 2)
      {
        if(rule[1] == 1 && rule[2] == 1)
          info = "Correct!";
        else
          info = "Not Quite";
      }
      if(numberOfOnes(rule) > 2)
        info = "TOO MANY RULES!!";
    }
    
    else if(level == 2)
    {
      info = "What Rules Produces the Pattern?";
      if(numberOfOnes(rule) == 1)
      {
        if(rule[0] == 1 || rule[4] == 1)
          info = "Not Quite";
        else if(rule[1] == 1 || rule[2] == 1 || rule[3] == 1)
          info = "Almost There";
        else
          info = "That didn't do anything";
      }   
      if(numberOfOnes(rule) == 2)
      {
        if(rule[1] == 1 || rule[2] == 1 || rule[3] == 1)
          info = "Yes!";
        else
          info = "Not Quite";
      }
      if(numberOfOnes(rule) == 3)
        if(rule[1] == 1 && rule[2] == 1 && rule[3] == 1)
          info = "Yes!! You get the gist";
      if(numberOfOnes(rule) > 3)
        info = "TOO MANY RULES!!";
    }
    else
    {
      if(numberOfOnes(rule1) > 1)
        info = "What Rules Produces the Pattern?";
      if(Arrays.equals(rule, rule1))
        info = "Correct!";
      if(numberOfOnes(rule) > numberOfOnes(rule1))
        info = "TOO MANY RULES!!";
    }
  }
  else
  {
    if(numberOfOnes(rule1) > 1)
      info = "What Rules Produces the Pattern?";
    if(Arrays.equals(rule, rule1))
      info = "Correct!";
    if(numberOfOnes(rule) > numberOfOnes(rule1))
      info = "TOO MANY RULES!!";
  }
  
  if(gameModes[1] == 1 & !showLevels)
  {
    // The Back Button
    if (mouseX > 34 && mouseX < 134 && mouseY > 934 && mouseY < 1034)
      info = "Back to Level Selection";
    
    //Previous Level Button
    if (mouseX > 648 && mouseX < 718 && mouseY > 949 && mouseY < 1019 && stage == 0 && level > 0)
      info = "Previous Level";
    
    //Reset Level Button
    if (mouseX > 738 && mouseX < 808 && mouseY > 949 && mouseY < 1019)
      info = "Reset Level";
    
    //Next Level Button
    if (mouseX > 828 && mouseX < 898 && mouseY > 949 && mouseY < 1019)
      info = "Next Level";
    
    textSize(35);
    text(info, 1400, 999);
    
    fill(255);
    rect(34,934, 100, 100);
    //rect(738, 949, 70, 70);
    fill(0);
    circle(773,984,80);
    fill(255);
    circle(773,984,40);
    if(!(stage == 0 && level == 0))
      drawLeftArrow(668,970);
    if(!(stage == levelRules.length-1 && level == 29))
      drawRightArrow(879,998);
    fill(0);
    textSize(50);
    text("Level "+(level+1+30*stage), 190, 999);
    textSize(40);
    text("Moves "+moves+"/"+numberOfOnes(rule1), 1000, 999);
  }
  stroke(0);
  drawBackArrow(55,971);
}

//Draws back arrow pointing to the left
void drawBackArrow(int x, int y)
{
  //Back To Menu Button
  pushMatrix();
    fill(0);
    rect(x,y+3,70,20);
    translate(x, y); // move the origin to the pivot point
    rotate(radians(45)); // rotate the coordinate system 
    rect(0, 0, 60, 20);
    rotate(radians(-90));
    rect(0, 0, 40, 20); 
   popMatrix();
}

//Draws arrow pointing right
void drawRightArrow(int x, int y)
{
    pushMatrix();
      fill(0);
      translate(x, y); // move the origin to the pivot point
      rotate(radians(135)); // rotate the coordinate system 
      rect(0, 0, 40, 20);
      rotate(radians(90));
      rect(0, 0, 60, 20); 
    popMatrix();
}

//Draws arrow pointing left
void drawLeftArrow(int x, int y)
{
    pushMatrix();
      fill(0);
      translate(x, y); // move the origin to the pivot point
      rotate(radians(45)); // rotate the coordinate system 
      rect(0, 0, 60, 20);
      rotate(radians(-90));
      rect(0, 0, 40, 20); 
    popMatrix();
}

//Draws the rule buttons, icons, & text seen on the right in the program screen
void drawRules()
{
  fill(0);
  stroke(0);
  rect(1710, 810, 20, 20);
  rect(1730, 810, 20, 20);
  rect(1750, 810, 20, 20);

  rect(1710, 710, 20, 20);
  rect(1730, 710, 20, 20);

  rect(1710, 610, 20, 20);
  rect(1750, 610, 20, 20);

  rect(1710, 510, 20, 20);

  rect(1730, 410, 20, 20);
  rect(1750, 410, 20, 20);

  rect(1730, 310, 20, 20);

  rect(1750, 210, 20, 20);

  fill(255);
  rect(1750, 710, 20, 20);

  rect(1730, 610, 20, 20);

  rect(1730, 510, 20, 20);
  rect(1750, 510, 20, 20);

  rect(1710, 410, 20, 20);

  rect(1710, 310, 20, 20);
  rect(1750, 310, 20, 20);

  rect(1710, 210, 20, 20);
  rect(1730, 210, 20, 20);

  rect(1710, 110, 20, 20);
  rect(1730, 110, 20, 20);
  rect(1750, 110, 20, 20);

  if (rule[0] == 1)
  {
    fill(0);
    rect(1730, 130, 20, 20);
    rect(1600, 100, 100, 100);
  } else
  {
    fill(255);
    rect(1730, 130, 20, 20);
    rect(1600, 100, 100, 100);
  }

  if (rule[1] == 1)
  {
    fill(0);
    rect(1730, 230, 20, 20);
    rect(1600, 200, 100, 100);
  } else
  {
    fill(255);
    rect(1730, 230, 20, 20);
    rect(1600, 200, 100, 100);
  }

  if (rule[2] == 1)
  {
    fill(0);
    rect(1730, 330, 20, 20);
    rect(1600, 300, 100, 100);
  } else
  {
    fill(255);
    rect(1730, 330, 20, 20);
    rect(1600, 300, 100, 100);
  }

  if (rule[3] == 1)
  {
    fill(0);
    rect(1730, 430, 20, 20);
    rect(1600, 400, 100, 100);
  } else
  {
    fill(255);
    rect(1730, 430, 20, 20);
    rect(1600, 400, 100, 100);
  }

  if (rule[4] == 1)
  {
    fill(0);
    rect(1730, 530, 20, 20);
    rect(1600, 500, 100, 100);
  } else
  {
    fill(255);
    rect(1730, 530, 20, 20);
    rect(1600, 500, 100, 100);
  }

  if (rule[5] == 1)
  {
    fill(0);
    rect(1730, 630, 20, 20);
    rect(1600, 600, 100, 100);
  } else
  {
    fill(255);
    rect(1730, 630, 20, 20);
    rect(1600, 600, 100, 100);
  }

  if (rule[6] == 1)
  {
    fill(0);
    rect(1730, 730, 20, 20);
    rect(1600, 700, 100, 100);
  } else
  {
    fill(255);
    rect(1730, 730, 20, 20);
    rect(1600, 700, 100, 100);
  }

  if (rule[7] == 1)
  {
    fill(0);
    rect(1730, 830, 20, 20);
    rect(1600, 800, 100, 100);
  } else
  {
    fill(255);
    rect(1730, 830, 20, 20);
    rect(1600, 800, 100, 100);
  }
  
  String number = "";
  for(int n = 0; n < rule.length; n++)
    number = rule[n] + number;
  fill(0);
  textSize(40);
  text("Rule "+Integer.parseInt(number, 2), 1600, 70);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CORE MECHANICS, ALGORITHMS, & SUCH
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Given a 2D ArrayList and an array of rules, this calculates and returns the appropriate automata
ArrayList<ArrayList<Cell>> calculateAuto(ArrayList<ArrayList<Cell>> autoGrid, int[] rule)
{
  ArrayList<ArrayList<Cell>> auto = autoGrid;
  for (int y = 1; y < auto.size(); y++)
  {
    for (int x = 0; x < auto.get(y).size(); x++)
    {
      if (!isPersistent(y, auto.get(y).get(x).x))
      {
        if (x == 0)
        {
          if (auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==1)//  1-1
            auto.get(y).get(x).type = rule[7];
          if (auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==0)//  1-0
            auto.get(y).get(x).type = rule[6];
          if (auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==1)//  0-1
            auto.get(y).get(x).type = rule[1];
          if (auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==0)//  0-0
            auto.get(y).get(x).type = rule[0];
        } 
        else if (x == auto.get(y).size()-1)
        {
          if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==1)//  1-1
            auto.get(y).get(x).type = rule[7];
          if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==0)//  1-0
            auto.get(y).get(x).type = rule[4];
          if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==1)//  0-1
            auto.get(y).get(x).type = rule[3];
          if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==0)//  0-0
            auto.get(y).get(x).type = rule[0];
        } 
        else
        {
          if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==1)//  1-1-1
            auto.get(y).get(x).type=rule[7];
          if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==0)//  1-1-0
            auto.get(y).get(x).type=rule[6];
          if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==1)//  1-0-1
            auto.get(y).get(x).type=rule[5];
          if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==0)//  1-0-0
            auto.get(y).get(x).type=rule[4];
          if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==1)//  0-1-1
            auto.get(y).get(x).type=rule[3];
          if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==0)//  0-1-0
            auto.get(y).get(x).type=rule[2];
          if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==1)//  0-0-1
            auto.get(y).get(x).type=rule[1];
          if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==0)//  0-0-0
            auto.get(y).get(x).type=rule[0];
        }
      }
    }
  }
  return auto;
}

//Calculates rows in the 2D Arraylist that stores the automata
void lineAuto()
{
  for(int i = 0; i < renderLines.size(); i++)
  {
    int y = renderLines.get(i);
    for(int n = 0; n < lineSpeed; n++)
    {
      for (int x = 0; y < auto.size() && x < auto.get(y).size(); x++)
        calculateOneCell(x, y);
      y++;
    }
    if(y < auto.size())
      renderLines.set(i, y);
    else
    {
      renderLines.remove(i);
      i--;
    }
  }
}

//Calculates cells in the 2D ArrayList
void pointAuto()
{
  for(int i = 0; i < renderPoints.size(); i++)
  {
    int y = renderPoints.get(i).y , x = renderPoints.get(i).x;
    
    if(x == 0)
    {
      for(int n = 0; n <= size/2; n++)
        calculateOneCell(n, y);
      renderPoints.get(i).x = size/2;
      x = renderPoints.get(i).x;
    }
    if(x >= size*3/2)
    {
      for(int n = x; n < auto.get(y).size(); n++)
        calculateOneCell(n, y);
      renderPoints.get(i).x = auto.get(y).size()-1;
      x = renderPoints.get(i).x;
    }
    calculateOneCell(x, y);

    if(x+1 < auto.get(y).size())
      renderPoints.get(i).x = x + 1;
    if(y+1 < auto.size() && x == auto.get(y).size()-1)
    {
      renderPoints.get(i).y = y + 1;
      renderPoints.get(i).x = 0;
    }
    if(y == auto.size()-1 && x == auto.get(y).size()-1)
    {
      renderPoints.remove(i);
      i--;
    }    
  }
}

//2D ArrayList coordinate, this calculates that cell
void calculateOneCell(int x, int y)
{
  if (!isPersistent(y, auto.get(y).get(x).x))
  {
    if (x == 0)
    {
      if (auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==1)//  1-1
        auto.get(y).get(x).type = rule[7];
      if (auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==0)//  1-0
        auto.get(y).get(x).type = rule[6];
      if (auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==1)//  0-1
        auto.get(y).get(x).type = rule[1];
      if (auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==0)//  0-0
        auto.get(y).get(x).type = rule[0];
    } 
    else if (x == auto.get(y).size()-1)
    {
      if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==1)//  1-1
        auto.get(y).get(x).type = rule[7];
      if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==0)//  1-0
        auto.get(y).get(x).type = rule[4];
      if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==1)//  0-1
        auto.get(y).get(x).type = rule[3];
      if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==0)//  0-0
        auto.get(y).get(x).type = rule[0];
    } 
    else
    {
      if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==1)//  1-1-1
        auto.get(y).get(x).type=rule[7];
      if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==0)//  1-1-0
        auto.get(y).get(x).type=rule[6];
      if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==1)//  1-0-1
        auto.get(y).get(x).type=rule[5];
      if (auto.get(y-1).get(x-1).type==1 && auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==0)//  1-0-0
        auto.get(y).get(x).type=rule[4];
      if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==1)//  0-1-1
        auto.get(y).get(x).type=rule[3];
      if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==1 && auto.get(y-1).get(x+1).type==0)//  0-1-0
        auto.get(y).get(x).type=rule[2];
      if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==1)//  0-0-1
        auto.get(y).get(x).type=rule[1];
      if (auto.get(y-1).get(x-1).type==0 && auto.get(y-1).get(x).type==0 && auto.get(y-1).get(x+1).type==0)//  0-0-0
        auto.get(y).get(x).type=rule[0];
    }
  }
}

//Adds the propper amount of cells and rows of cells to the main 2D ArrayList
void resizeList()
{
  int oldSize = auto.get(0).size();
  if (oldSize < size*2 && sizeDiff%2 == 0)
  {
    if(renderModes[1] == 1)
      renderLines.add(1);
    if(renderModes[2] == 1)
      renderPoints.add(new Point(0, 1));
      
    if(controlCell.x+1 < auto.get(0).size()*3/4-1 ) 
      controlCell.x += sizeDiff/2;
      
    for (int y = 0; y < auto.size(); y++)
    {
      for (int x = 0; x < sizeDiff; x++)
      {
        auto.get(y).add(new Cell(auto.get(y).get(auto.get(y).size()-1).x+1, y, 0));
      }
      for (int x = 0; x < sizeDiff/2; x++)
      {
        auto.get(y).add(0, new Cell(auto.get(y).get(0).x-1, y, 0));
        auto.get(y).add(new Cell(auto.get(y).get(auto.get(y).size()-1).x+1, y, 0));
      }
    }

    //Adds to bottom
    for (int n = 0; n < sizeDiff/2; n++)
    {
      auto.add(new ArrayList<Cell>());
      for (int i = 0; i < auto.get(auto.size()-2).size(); i++)
      {
        auto.get(auto.size()-1).add(new Cell(auto.get(auto.size()-2).get(i).x, auto.size()-1, 0));
      }
    }
    
    zoom.x += sizeDiff/2;
    zoom1.x += sizeDiff*3/2;
    zoom1.y += sizeDiff/2;
  }
  
  if (oldSize > size*2 && sizeDiff%2 == 0)
  {
    if(controlCell.x-1 > auto.size()-1)
      controlCell.x -= sizeDiff/2;
    
    for (int n = 0; n < sizeDiff/2; n++)
      auto.remove(auto.size()-1);
      
    for (int y = 0; y < auto.size(); y++)
    {
      for (int x = 0; x < sizeDiff; x++)
      {
        auto.get(y).remove(auto.get(y).size()-1);
      }
      for (int x = 0; x < sizeDiff/2; x++)
      {
        auto.get(y).remove(0);
        auto.get(y).remove(auto.get(y).size()-1);
      }
    }
    
    zoom.x -= sizeDiff/2;
    zoom1.x -= sizeDiff*3/2;
    zoom1.y -= sizeDiff/2;
  }
}

//Checks if the coordinate is a cell that should be left alone
boolean isPersistent(int y, int x)
{
  for (int i = 0; i < pCells.size(); i++)
  {
    if (pCells.get(i).x == x && pCells.get(i).y == y)
      return true;
  }
  return false;
}

//Removes persistent cells with the input coordinate
void removePersistence(int y, int x)
{
  for (int i = 0; i < pCells.size(); i++)
  {
    if (pCells.get(i).x == x && pCells.get(i).y == y)
    {
      pCells.remove(i);
      i--;
    }
  }
}

//There can only be one
void setRenderMode(int mode)
{
  renderModes[0] = 0;
  renderModes[1] = 0;
  renderModes[2] = 0;
  
  if(mode == 0)
    renderModes[0] = 1;
  else if(mode == 1)
    renderModes[1] = 1;
  else if(mode == 2)
    renderModes[2] = 1;
}

//Outputs an array containing a random rule
int[] getRandomRule()
{
  int[] genRule = new int[8];
  int n = (int)(Math.random()*allRules.size());
  String bin = Integer.toBinaryString(allRules.get(n));
  for(int x = bin.length()-1; x >= 0; x--)
    genRule[bin.length()-x-1] = Character.getNumericValue(bin.charAt(x));
  return genRule;
}

//Outputs rule depending on the current section and level
int[] getRule(int stg, int lev)
{
  int[] genRule = new int[8];
  String bin = Integer.toBinaryString(levelRules[stg][lev]);
  for(int x = bin.length()-1; x >= 0; x--)
    genRule[bin.length()-x-1] = Character.getNumericValue(bin.charAt(x));
  return genRule;
}

//Returns the number of 1s in a rule for the minimum number of moves
int numberOfOnes(int[] array)
{
  int n = 0;
  for(int x = 0; x < array.length; x++)
  {
    if(array[x] == 1)
      n++;
  }
  return n;
}

//Checks to see if all levels are complete for indefinite levels
boolean levelsComplete()
{
  for(int y = 0; y < levelCompleted.length; y++)
    for(int x = 0; x < levelCompleted[y].length; x++)
      if(levelCompleted[y][x] <= 1)
        return false;
  return true;
}

//Clears the top row of the main 2D ArrayList
void clearTopRow()
{
  for(int x = 0; x < auto.get(0).size(); x++)
  {
    auto.get(0).get(x).type = 0;
  }
}

//Clears the top row of the 2D ArrayList for the levels target pattern
void clearTopRow1()
{
  for(int x = 0; x < auto1.get(0).size(); x++)
  {
    auto1.get(0).get(x).type = 0;
    auto.get(0).get(x).type = 0;
  }
}

//Randomizes the cells turned on in the top row of the main 2D ArrayList
void randomInitialConditions()
{
  //clearTopRow();
  int i = (int)(Math.random()*auto.get(0).size()/2 + auto.size());
  for(int x = 0; x < 5; x++)
  {
    //auto1.get(0).get(i).type = 1;
    auto.get(0).get(i).type = 1;
    i = (int)(Math.random()*auto.get(0).size()/2 + auto.size());
  }
}

//Randomizes the cells turned on in the top row of the main 2D ArrayList & the levels 2D ArrayList
void randomInitialConditions1(int num)
{
  clearTopRow1();
  int i = (int)(Math.random()*auto1.get(0).size()/2 + auto1.size());
  for(int x = 0; x < num; x++)
  {
    auto.get(0).get(i).type = 1;
    auto1.get(0).get(i).type = 1;
    i = (int)(Math.random()*auto1.get(0).size()/2 + auto1.size());
  }
}

//Rests the main 2D Arraylist to the inputes size
void resetAuto(int s)
{
  size = s;
  auto.clear();
  for (int y = 0; y <= size/2; y++)
  {
    auto.add(new ArrayList<Cell>());
    for (int x = -size/2; x <= size*3/2; x++)
      auto.get(y).add(new Cell(x, y, 0));
  }
}

//Rests the levels 2D Arraylist to the inputes size
void resetAuto1(int s)
{
  size = s;
  auto1.clear();
  for (int y = 0; y <= size/2; y++)
  {
    auto1.add(new ArrayList<Cell>());
    for (int x = -size/2; x <= size*3/2; x++)
      auto1.get(y).add(new Cell(x, y, 0));
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MOUSE & KEY EVENT HANDLING
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Handles all mouse events in the game
void mouseClicked()// called automatically
{
  if(gameModes[0] == 1 || (gameModes[1] == 1 && !showLevels) || (gameModes[5] == 1 && tutorialState == 4) || gameModes[4] == 1)
  {
    if (mouseX > 1600 && mouseX < 1700 && mouseY > 100 && mouseY < 900)
    {
      int y = (mouseY-100)/100;
      if (rule[y] == 1)
        rule[y] = 0;
      else
        rule[y] = 1;
      
      if((gameModes[1] == 1 && !showLevels)||gameModes[4] == 1)
      {
        if(lastMove == -1)
          moves = 1;
        
        if(lastMove >= 0 && y != lastMove)
          moves++;
          
        lastMove = y;
      }
        
      if(renderModes[1] == 1)
        renderLines.add(1);
      if(renderModes[2] == 1)
        renderPoints.add(new Point(0,1));
    }
  }
  
  //Level gameplay mouse events
  if(gameModes[1] == 1 && !showLevels)
  {  
    // The Back Button
    if (mouseX > 34 && mouseX < 134 && mouseY > 934 && mouseY < 1034)
    {
      rule = new int[8];
      showLevels = true;
      lastMove = -1;
      moves = 0;
      rule = getRandomRule();
      resetAuto(512);
      randomInitialConditions();
      renderLines.add(1);
      //auto.get(0).get(size).type = 1;
      //auto1.get(0).get(size).type = 1;
    }
    
    //Previous Level Button
    if (mouseX > 648 && mouseX < 718 && mouseY > 949 && mouseY < 1019)
    {
      if(level-1 >= 0)
      {
        rule = new int[8];
        level--;
      }
      else if(level == 0 && stage > 0)
      {
        rule = new int[8];
        stage--; 
        level = 29;
      }
      if(stage > 0)
        showControl = false;
      else
        showControl = true;
      lastMove = -1;
      moves = 0;
      resetAuto(32);
      if(stage == 2)
        randomInitialConditions1(5);
      else
      {
        clearTopRow1();
        auto.get(0).get(size).type = 1;
        auto1.get(0).get(size).type = 1;
      }
    }
    
    //Reset Level Button
    if (mouseX > 738 && mouseX < 808 && mouseY > 949 && mouseY < 1019)
    {
      rule = new int[8];
      lastMove = -1;
      moves = 0;
      resetAuto(32);
      if(stage == 2)
        randomInitialConditions1(5);
      else
      {
        clearTopRow1();
        auto.get(0).get(size).type = 1;
        auto1.get(0).get(size).type = 1;
      }
    }
    
    //Next Level Button
    if (mouseX > 828 && mouseX < 898 && mouseY > 949 && mouseY < 1019)
    {
      if(level+1 < 30)
      {
        rule = new int[8];
        level++;
      }
      else if(level == 29 && stage+1 < levelRules.length)
      {
        rule = new int[8];
        stage++; 
        level = 0;
      }
      if(stage > 0)
        showControl = false;
      else
        showControl = true;
      
      lastMove = -1;
      moves = 0;
      resetAuto(32);
      
      if(stage == 2)
        randomInitialConditions1(5);
      else
      {
        clearTopRow1();
        auto.get(0).get(size).type = 1;
        auto1.get(0).get(size).type = 1;
      }
    }
  }
    
  //Levels  
  if(gameModes[1] == 1 && showLevels)
  {
    //Levels Buttons
    if(mouseX > 550 && mouseX < 1300 && mouseY > 84 && mouseY < 1084)
    {
      int x = (mouseX-550)/150, y = (mouseY-84)/150;
      level = (x)+5*y;
      showLevels = false;
      
      if(stage > 0)
        showControl = false;
      else
        showControl = true;
        
      resetAuto(32);
      resetAuto1(32);
      rule = new int[8];
      zoom = new Point(size/2, 0);
      zoom1 = new Point(size*3/2-1, size/2);
        
      if(stage == 2)
      {
        randomInitialConditions1(5);
      }
      else
      {
        clearTopRow1();
        auto.get(0).get(size).type = 1;
        auto1.get(0).get(size).type = 1;
      }
    }
    
    //Back Button
    if(mouseX < 100 && mouseY < 100)
    {
      gameModes[1] = 0;
      gameModes[2] = 1;
      showLevels = false;
      stage = 0;
      if(levelsComplete())
        allLevelsComplete = true;
    }
    
    //Next Levels Button
    if(mouseX > 1800 && mouseX < 1850 && mouseY > 484 && mouseY < 584 && stage+1 < 3)
      stage++;
      
    //Previous Levels Button
    if(mouseX > 45 && mouseX < 110 && mouseY > 484 && mouseY < 584 && stage-1 >= 0) 
      stage--;
  }
  
  //Sandbox Mode Mouse Events
  if(gameModes[0] == 1)
  {
    if (mouseX < winX && mouseY < winY)
    {
      //int y = mouseY*auto.size()/winY, x = mouseX*(size)/winX;
      //int xL = x+auto.size()-1;
      
      int distX = Math.abs(zoom1.x-zoom.x)+1, distY = Math.abs(zoom1.y-zoom.y)+1;
      int y = mouseY*distY/winY + zoom.y, x = mouseX*distX/winX, xL = x + zoom.x;
      //println(x+" "+xL+" "+auto.get(y).get(xL).x);
      if (auto.get(y).get(xL).type == 1)
      {
        auto.get(y).get(xL).type = 0;
        if (isPersistent(y, auto.get(y).get(xL).x))
          removePersistence(y, auto.get(y).get(xL).x);
        pCells.add(new Point(auto.get(y).get(xL).x, y));
        //println("0");
        if(renderModes[1] == 1 && y > 0)
          renderLines.add(y);
        else
          renderLines.add(1);
          
        if(renderModes[2] == 1 && y > 0)  
          renderPoints.add(new Point(xL,y));
        else
          renderPoints.add(new Point(xL,1));
      } 
      else
      {
        auto.get(y).get(xL).type = 1;
        //println(auto.get(y).get(xL).type);
        if (isPersistent(y, auto.get(y).get(xL).x))
          removePersistence(y, auto.get(y).get(xL).x);
        else
          pCells.add(new Point(auto.get(y).get(xL).x, y));
          
        if(renderModes[1] == 1 && y > 0)
          renderLines.add(y);
        else
          renderLines.add(1);
          
        if(renderModes[2] == 1 && y > 0)  
          renderPoints.add(new Point(xL,y));
        else
          renderPoints.add(new Point(xL,1));
      }
    }

    //Back to Menu
    if(mouseX > 34 && mouseX < 134 && mouseY > 934 && mouseY < 1034)
    {
      gameModes[0] = 0;
      gameModes[2] = 1;
      
      //Reset Everything
      resetAuto(512);
      pCells.clear();
      randomInitialConditions();
      renderLines.add(1);
      controlCell.x = size;
      controlCell.y = 1;
      zoom = new Point(size/2, 0);
      zoom1 = new Point(size*3/2-1, size/2);
      rule = getRandomRule();
      
      if(showJustBackground)
        showJustBackground = false;
    }
    
    // Show Cells
    if(mouseX > 168 && mouseX < 236 && mouseY > 912 && mouseY < 980)
    {      
      if(showCells)
        showCells = false;
      else
        showCells = true;
    }
    
    // Show Branches
    if(mouseX > 248 && mouseX < 316 && mouseY > 912 && mouseY < 980)
    {
      if(showBranches)
        showBranches = false;
      else
        showBranches = true;
    }
    
    //Show control cell thingy
    if(mouseX > 328 && mouseX < 396 && mouseY > 912 && mouseY < 980)
    {
      if(showControl)
        showControl = false;
      else
        showControl = true;
    }

    // Automatic Render
    if(mouseX > 168 && mouseX < 236 && mouseY > 992 && mouseY < 1060)
    {      
      setRenderMode(0);
      renderLines.clear();
      renderPoints.clear();
    }
    
    // Line by Line
    if(mouseX > 248 && mouseX < 316 && mouseY > 992 && mouseY < 1060)
    {
      setRenderMode(1);
      renderLines.add(1);
      renderPoints.clear();
    }
    
    //Cell by Cell
    if(mouseX > 328 && mouseX < 396 && mouseY > 992 && mouseY < 1060)
    {
      setRenderMode(2);
      renderPoints.add(new Point(0,1));
      renderLines.clear();
    }

    //Random Initial Conditions
    if(mouseX > 1420 && mouseX < 1488 && mouseY > 912 && mouseY < 980)
    {
      //clearTopRow();
      randomInitialConditions();
      if(renderModes[1] == 1)
        renderLines.add(1);
      if(renderModes[2] == 1)  
        renderPoints.add(new Point(0,1));
    }

    //Random Rule
    if(mouseX > 1420 && mouseX < 1488 && mouseY > 992 && mouseY < 1060)
    {
      rule = getRandomRule();
      if(renderModes[1] == 1)
        renderLines.add(1);
      if(renderModes[2] == 1)  
        renderPoints.add(new Point(0,1));
    }
    
    //Clear Automata
    if(mouseX > 1340 && mouseX < 1408 && mouseY > 912 && mouseY < 980)
    {
      resetAuto(size);
      pCells.clear();
      rule = new int[8];
    }
    
    //Reset Size
    if(mouseX > 1340 && mouseX < 1408 && mouseY > 992 && mouseY < 1060)
    {
      resetAuto(32);
      auto.get(0).get(size).type = 1;
      zoom = new Point(size/2, 0);
      zoom1 = new Point(size*3/2-1, size/2);
      auto = calculateAuto(auto, rule);
      renderLines.add(1);
      zoomFactor = 1.0;
    }
  }

  //Main Menu
  if(gameModes[2] == 1)
  {
    if(mouseX > 110 && mouseX < 1710 && mouseY > 20 && mouseY < 130)
    {
      showJustBackground = !showJustBackground;
    }
    if(!showJustBackground)
    {
      if(mouseX > 650 && mouseX < 1250)
      {
        //Tutorial
        if(mouseY > 150 && mouseY < 300)
        {
          gameModes[2] = 0;
          gameModes[5] = 1;
          
          resetAuto(32);
          auto.get(0).get(size).type = 1;
          zoom = new Point(size/2, 0);
          zoom1 = new Point(size*3/2-1, size/2);
          tutorialState = 0;
          cX = 70; cY = 75;
          rule = new int[8];
        }
        
        //Levels
        if(mouseY > 330 && mouseY < 480)
        {
          gameModes[2] = 0;
          gameModes[1] = 1;
          showLevels = true;
          stage = 0;
        }
        
        if(allLevelsComplete)
        {
          //Indefinite Levels
          if(mouseY > 510 && mouseY < 660)
          {
            gameModes[2] = 0;
            gameModes[4] = 1;
            rule = new int[8];
            resetAuto(infSize);
            resetAuto1(infSize);
            rule1 = getRandomRule();
            randomInitialConditions1(infCells);
            auto1 = calculateAuto(auto1, rule1);
            zoom = new Point(size/2, 0);
            zoom1 = new Point(size*3/2-1, size/2);
            
            
          }
          
          //Sandbox
          if(mouseY > 690 && mouseY < 840)
          {
            gameModes[2] = 0;
            gameModes[0] = 1;
            resetAuto(32);
            resetAuto1(32);
            rule = new int[8];
            zoom = new Point(size/2, 0);
            zoom1 = new Point(size*3/2-1, size/2);
            auto.get(0).get(size).type = 1;
            showControl = true;
          }
          
          //Quit
          if(mouseY > 870 && mouseY < 1020)
            exit();
        }
        else
        {
          //Sandbox
          if(mouseY > 510 && mouseY < 660)
          {
            gameModes[2] = 0;
            gameModes[0] = 1;
            resetAuto(32);
            resetAuto1(32);
            rule = new int[8];
            zoom = new Point(size/2, 0);
            zoom1 = new Point(size*3/2-1, size/2);
            auto.get(0).get(size).type = 1;
            showControl = true;
          }
          
          //Quit
          if(mouseY > 690 && mouseY < 840)
            exit();
        }
      }
    }
    else
    {
      if(mouseX > 650 && mouseX < 1250 && mouseY > 510 && mouseY < 660)
      {
        gameModes[2] = 0;
        gameModes[0] = 1;
      }
    }
  }
  
  //Tutorial
  if(gameModes[5] == 1)
  {
    //Back to Menu
    if(mouseX > 34 && mouseX < 134 && mouseY > 934 && mouseY < 1034)
    {
      gameModes[5] = 0;
      gameModes[2] = 1;
      rule = getRandomRule();
      resetAuto(512);
      randomInitialConditions();
      renderLines.add(1);
    }
  }
  
  //Indefinite Levels
  if(gameModes[4] == 1)
  {
    //Back to Menu
    if(mouseX > 34 && mouseX < 134 && mouseY > 934 && mouseY < 1034)
    {
      gameModes[4] = 0;
      gameModes[2] = 1;
      rule = getRandomRule();
      resetAuto(512);
      randomInitialConditions();
      renderLines.add(1);
    }
    
    //Reset Level Button
    if (mouseX > 738 && mouseX < 808 && mouseY > 949 && mouseY < 1019)
    {
      lastMove = -1;
      moves = 0;
      rule = new int[8];
      resetAuto(infSize);
      resetAuto1(infSize);
      randomInitialConditions1(infCells);
      auto1 = calculateAuto(auto1, rule1);
    }
  }
}

//Updates proper variables to enable zooming functionality
void mouseWheel(MouseEvent event)
{
  int e = event.getCount();
  int distX = Math.abs(zoom1.x-zoom.x)+1, distY = Math.abs(zoom1.y-zoom.y)+1;
  int y = mouseY*distY/winY + zoom.y, xL = mouseX*distX/winX + zoom.x;//int y = distY/2 + zoom.y, xL = distX/2 + zoom.x;
  float z = 0.95;
  if (e < 0 && zoomFactor*z > 0.1)
  {
    zoomFactor *= z;
    mX = xL; mY = y;
  }
    
  if (e > 0 && zoomFactor/z <= 1/z)
  {
    zoomFactor /= z; 
    xL = mX; y = mY;
  }
  if(e > 0 && zoomFactor/z > 1/z)
  {
    //zoom = new Point(auto.size()-1, 0); zoom1 = new Point(auto.get(0).size()*3/4, auto.size()-2);
    zoom = new Point(size/2, 0); zoom1 = new Point(size*3/2-1, size/2);
  }
  if((int)(xL - (xL - auto.size())*zoomFactor) >= auto.size())
    zoom.x = (int)(xL - (xL - auto.size())*zoomFactor);
  if((int)(xL + (auto.get(0).size()*3/4 - xL)*zoomFactor) < auto.get(0).size()*3/4)
    zoom1.x = (int)(xL + (auto.get(0).size()*3/4 - xL)*zoomFactor);
  if((int)(y - y*zoomFactor) >= 0)
    zoom.y = (int)(y - y*zoomFactor);
  if((int)(y + (auto.size() - y)*zoomFactor) < auto.size())  
    zoom1.y = (int)(y + (auto.size() - y)*zoomFactor);
}

//Handles click & drag events to shift vaiable along the 2D ArrayList to enable shifting the view while zoomed in
void mouseDragged() 
{
  //float factor = 0.1;
  PVector d = new PVector((mouseX-pmouseX), (mouseY-pmouseY));
  d.normalize();
  d.mult(1.5);
  if(zoom.x-d.x > size/2 && zoom1.x-d.x < size*3/2)
  {
    zoom.x -= d.x;
    zoom1.x -= d.x;
  }
  if(zoom.y-d.y > 0 && zoom1.y-d.y < size/2)
  {
    zoom.y -= d.y;
    zoom1.y -= d.y;
  }
}

void keyPressed()
{
  //Increase or Decrease the size of the Grid
  if(gameModes[0] == 1)
  {
    if (keyCode == LEFT && size-sizeDiff > lineSpeed)
    {
      size -= sizeDiff;
      resizeList();
    }
  
    if (keyCode == RIGHT)
    {
      size += sizeDiff;
      resizeList();
      //println(size+" "+auto.get(0).size());
    }
    
    if (keyCode == UP)
    {
      String number = "";
      for(int n = 0; n < rule.length; n++)
        number = rule[n] + number;
      int newRule = Integer.parseInt(number, 2);
      if(newRule+1 < 256)
        newRule++;
      String bin = Integer.toBinaryString(newRule);
      rule = new int[8];
      for(int x = bin.length()-1; x >= 0; x--)
        rule[bin.length()-x-1] = Character.getNumericValue(bin.charAt(x));
        
      if(renderModes[0] == 1)
        auto = calculateAuto(auto, rule);
      if(renderModes[1] == 1)
        renderLines.add(1);
      if(renderModes[2] == 1)
        renderPoints.add(new Point(0,1));   
    }
  
    if (keyCode == DOWN)
    {
      String number = "";
      for(int n = 0; n < rule.length; n++)
        number = rule[n] + number;
      int newRule = Integer.parseInt(number, 2);
      if(newRule-1 >= 0)
        newRule--;
      String bin = Integer.toBinaryString(newRule);
      rule = new int[8];
      for(int x = bin.length()-1; x >= 0; x--)
        rule[bin.length()-x-1] = Character.getNumericValue(bin.charAt(x));
        
      if(renderModes[0] == 1)
        auto = calculateAuto(auto, rule);
      if(renderModes[1] == 1)
        renderLines.add(1);
      if(renderModes[2] == 1)
        renderPoints.add(new Point(0,1));  
    }
  }
   
  if(gameModes[5] == 1)
  {
    if(keyCode == ENTER)
      tutorialState++;
  }
}
