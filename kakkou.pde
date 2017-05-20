import processing.awt.PSurfaceAWT;
import java.io.*;
import java.io.FileWriter;
import processing.awt.*;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;

Reminder reminder;
JTextField field=new JTextField("");

String [] launchLines;
PImage back;
boolean right=true;
boolean onTop=true;
String pLine="";//削除される直前の項目

void setup() {
  textFont(createFont("Microsoft JhengHei UI", 50, true));

  init(displayWidth/5, displayHeight);
  reminder = new Reminder();
  back=loadImage("back.jpg");
  launchLines = loadStrings("launcher.txt");

  Canvas canvas =(Canvas)surface.getNative();
  JLayeredPane pane =(JLayeredPane)canvas.getParent().getParent();

  field.setForeground(Color.WHITE);
  field.setBackground(Color.BLACK);
  field.setFont(new Font("Microsoft JhengHei UI", Font.PLAIN, 50));
  field.setBounds(width/9, 0, width, height/21);
  field.setCaretPosition(field.getText().length());
  field.setCaretColor(new Color( 0, 255, 0));
  field.addActionListener(new ActionListener() {
    public void actionPerformed(ActionEvent e) {
      String str = field.getText();
      field.setText("");
      launcher(str);
    }
  }
  );
  pane.add(field);
}

void mousePressed() {
  reminder.mousePressed();
  loop();
}

void mouseReleased() {
  reminder.mouseReleased();
}

void keyPressed() {
  if (key==0x13) reminder.saveData();
  if (key==0x1A && !pLine.equals("")) 
    reminder.setReminder(pLine);
  if (keyCode==LEFT) {
    right=false;
  }
  if (keyCode==RIGHT)right=true;
  if (keyCode==UP)onTop=true;
  if (keyCode==DOWN)onTop=false;
  switchOnTop();
  onTop=true;
}

void draw() {
  reminder.setWindow();
  image(back, 0, 0, displayWidth/5, displayHeight/2);
  fill(0, 200);
  rect(0, 0, width, height);
  reminder.draw();
  fill(255);
}

void init(int windowWidth, int windowHeight) {
  surface.setResizable(true); 
  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();

  smoothCanvas.getFrame().removeNotify();
  smoothCanvas.getFrame().setUndecorated(true);//タイトルバー非表示
  smoothCanvas.getFrame().setAlwaysOnTop(true);
  smoothCanvas.getFrame().setLocation(displayWidth-windowWidth, displayHeight-windowHeight);
  smoothCanvas.getFrame().addNotify();
  smoothCanvas.getFrame().setSize(windowWidth, windowHeight);
}

void switchOnTop() {
  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  if (onTop)  smoothCanvas.getFrame().setAlwaysOnTop(true);
  else   smoothCanvas.getFrame().setAlwaysOnTop(false);
}

void launcher(String program) {
  boolean remind=true;

  for (int i=0; i<launchLines.length; i++) {
    String [] data = split(launchLines[i], ',');
    if (program.equals(data[0])) { 
      link(data[1]);
      remind=false;
    }
  }

  if (remind)
    reminder.setReminder(program);
}