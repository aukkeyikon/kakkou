class Reminder {

  int taskCount;//taskの数を管理する変数
  int delete;
  boolean save=true;
  boolean click=false;//項目の入れ替えをアクティブ時に即実行しないためのフラグ
  String[] lines;
  String [] board = new String[21];
  float [] posX = new float [21];

  Reminder() {
    init();
  }

  void init() {
    lines=loadStrings("backup.txt");
    for (int i=0; i<20; i++) { 
      board[i] = lines[i];
      posX[i]=70;
      if (!lines[i].equals("null"))taskCount=i+1;
    }
  }

  void mousePressed() {
    delete=mouseY/(height/21);
    if (mouseX<width/9&&mouseY<height/21*(taskCount+1)&&mouseY>height/21) {
      if (!board[delete-1].equals("null")) {
        pLine=board[delete-1];
        for (int i=delete; i<board.length; i++)
          board[i-1]=board[i];
        taskCount--;
      }
      save=false;
    }
    if (!save&&mouseX<width/9&&mouseY<height/21) saveData();
  }

  void mouseReleased() {
    if (click && mouseX>width/9 && mouseY>height/21) {
      int releasePoint=mouseY/(height/21);
      String temp=board[delete-1];
      board[delete-1]=board[releasePoint-1];
      board[releasePoint-1]=temp;
      save=false;
    }
    click=true;
  }

  void setReminder(String str) {   
    if (taskCount<board.length-1) {
      board[taskCount]=str;
      taskCount++;
      save=false;
    }
  }

  void setWindow() {
    PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
    PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
    int posX;
    if (right)posX=displayWidth-width;
    else posX=161;
    if (smoothCanvas.getFrame().isActive()) {
      if (taskCount<10)
        smoothCanvas.getFrame().setLocation(posX, (displayHeight)/2);    
      else if (taskCount>=10)
        smoothCanvas.getFrame().setLocation(posX, (displayHeight/2)-displayHeight/21*(taskCount-10));
    } else {
      smoothCanvas.getFrame().setLocation(posX, displayHeight*9/10);
      click=false;
      noLoop();
    }
  }

  void draw() {
    stroke(255);
    strokeWeight(1);
    line(width/9, height/21, width/9, height);
    fill(255);
    for (int i=0; i<board.length; i ++) {
      try {  
        if (!board[i].equals("null")) 
          text(board[i], posX[i], height/21*(i+2));
      }
      catch(Exception e) {
      }
      line(0, height/21*(i+1), width, height/21*(i+1));
    }
    if (!save) {
      fill(255, 100);  
      rect(0, 0, width/9, height/21);
      fill(0);
    }
    text("*", 0, height/21);
    int mouseOver=mouseY/(height/21);
    try {
      if (textWidth(board[mouseOver-1])>580) {
        posX[mouseOver-1]-=3;
        if (posX[mouseOver-1]<-textWidth(board[mouseOver-1])+width-30)
          posX[mouseOver-1]=70;
      } else
        for (int i=0; i<20; i++)
          posX[i]=70;
    }
    catch(Exception e) {
    }
  }

  void saveData() {
    saveStrings("./data/backup.txt", board);
    save=true;
  }
}