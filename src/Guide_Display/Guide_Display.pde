/**
http://www2.kobe-u.ac.jp/~tnishida/misc/processing-japanese.html
http://r-dimension.xsrv.jp/classes_j/system_font/
この２つのURLを参考にして、Processing2を日本語化する
(Refer to these two URLs and Japaneseize Processing 2)

表示する内容の個数をmax_stateに入れる（例として３個設定するようにしてる）
str変数に表示する文字列をmax_stateと同じ数だけ設定する

cキーで表示物を設定した順番に切り替える
それぞれの表示物で矢印の角度・サイズや、文字のサイズ・半径・文字間隔を設定可能
＊テキストにsaveなんて高尚な機能はない。毎回それぞれ設定するべし

キー   ：  処理内容
[q,a]  :  矢印の角度を反時計／時計回りに変更
[w,s]  :  矢印の長さを伸ばす／短くする
[e,d]  :  矢印の太さを太く／細くする
[r,f]  :  文字間隔を広く／狭くする
[t,g]  :  文字表示円の半径を広く／狭くする
[y,h]  :  文字サイズを大きく／小さくする
[u,j]  :  文字回転を反時計回り／時計回りに速くする
[k]    :  文字色のタイプを虹、白、ユーザ調整の順に変更する
[i]    :  文字色をユーザ側で調整する
**/


//描画切り替えフラグ
int state;

//最大描画種類数
int max_state = 3;

//描画文字列
String[] str = {
  "サンプルプログラム", "ここに設定した文字列が表示されます","明日の天気は雨です"
};

//文字角度（文字の間隔を調整）
int[] angle;

//文字円の半径
int[] radius;

//文字サイズ
int[] char_size;

//矢印の向き
int[] arrow_angle;

//矢印の長さ
int[] arrow_length;

//矢印の太さ
int[] arrow_width;

//フォントインスタンス
PFont font;

//回転処理に使うカウンタ変数
float lotate_counter;

//回転速度
float[] lotate_d;

//文字色
int[] char_col;

//文字色をどうするか
static final int RAINBOW = 0; //虹色
static final int WHITE = 1; //白色
static final int USER = 2; //ユーザが調整
int char_color_flag = WHITE;

void setup()
{
  size(displayWidth, displayHeight);
  init_env();
  init_var();
  state = 0;
  lotate_counter = 0.0;
  font = createFont("HiraKakuPro-W3", char_size[0]);
  textFont(font, char_size[state]);
}

void draw()
{
  background(0);
  draw_str(str[state], angle[state], radius[state], char_size[state], char_col[state]);
  draw_arrow(arrow_angle[state], arrow_length[state], arrow_width[state]);
  lotate_counter += lotate_d[state];
}

void keyPressed()
{
  //次の文字列に変更
  switch(key) {
  case 'c':
    state += 1;
    state %= max_state;
    break;

    //矢印の角度変更
  case 'q':
    arrow_angle[state] += 5;
    break;
  case 'a':
    arrow_angle[state] -= 5;
    break;

    //矢印の長さの調整
  case 'w':
    arrow_length[state] += 5;
    break;
  case 's':
    arrow_length[state] -= 5;
    if (arrow_length[state] <  0)
      arrow_length[state] = 0;
    break;

    //矢印の太さの変更
  case 'e':
    arrow_width[state] += 5;
    break;
  case 'd':
    arrow_width[state]-= 5;
    if (arrow_width[state] <  0)
      arrow_width[state] = 0;
    break;

    //文字表示間隔の設定
  case 'r':
    angle[state] += 1;
    break;
  case 'f':
    angle[state] -= 1;
    break;

    //文字表示円の半径を調整
  case 't':
    radius[state] += 5;
    break;
  case 'g':
    radius[state] -= 5;
    break;

    //文字サイズの調整
  case 'y':
    char_size[state] += 1;
    font = createFont("HiraKakuPro-W3", char_size[state]);
    textFont(font, char_size[state]);
    break;
  case 'h':
    if (char_size[state] > 1)
      char_size[state] -= 1;
    font = createFont("HiraKakuPro-W3", char_size[state]);
    textFont(font, char_size[state]);
    break;

    //回転速度の調整
  case 'u':
    lotate_d[state] -= 0.05;
    break;
  case 'j':
    lotate_d[state] += 0.05;
    break;

    //文字色の調整
  case 'i':
    char_col[state] += 1;
    char_col[state] %= 100;
    break;

    //文字色のタイプ（虹・白・ユーザ調整）
  case 'k':
    char_color_flag += 1;
    char_color_flag %= 3;
    break;

  default:
    break;
  }
}

//変数初期化
void init_var()
{
  angle = new int[max_state];
  radius = new int[max_state];
  char_size = new int[max_state];
  arrow_angle = new int[max_state];
  arrow_length = new int[max_state];
  arrow_width = new int[max_state];
  lotate_d = new float[max_state];
  char_col = new int[max_state];
  for (int i = 0; i < max_state; i++)
  {
    angle[i] = 10;
    radius[i] = 100;
    char_size[i] = 18;
    arrow_angle[i] = 30;
    arrow_length[i] = 100;
    arrow_width[i] = 10;
    lotate_d[i] = -0.1;
    char_col[i] = 100;
  }
}

//環境の初期化
void init_env()
{
  colorMode(HSB, 100);
  rectMode(CENTER);
  textMode(CENTER);
  textAlign(CENTER);
  imageMode(CENTER);
  smooth();
  noCursor();
  state = 0;
}

//円環状の文字列を描画する
void draw_str(String str, int ang, int rad, int size, int col)
{

  int len = str.length();

  // 文字列を円状に配置
  for (int i = 0; i < len; i++) {
    pushMatrix();
     translate(width / 2, height / 2);
    // 基点の回転
    rotate(radians((i+lotate_counter) * ang));
    translate(rad, 0);
    rotate(radians(90));

    // 文字色の設定
    switch(char_color_flag)
    {
    case RAINBOW:
      fill(i * ang * 100 / 360, 100, 100);
      break;

    case WHITE:
      fill(0, 0, 100);
      break;

    case USER:
      fill(col, 100, 100);
      break;

    default:
      break;
    }

    //文字の描画
    text(str.charAt(i), 0, 0);
    popMatrix(); // 復元
  }

  //一周回ると回転変数を初期化
  if (radians((lotate_counter) * ang) < -2*PI)
    lotate_counter = 0;
}

//矢印を描画する
void draw_arrow(int ang, int len, int wid)
{
  //矢印の色
  fill(0,0,100);
  pushMatrix();
  translate(width/2-len/10,height/2);
  rotate(radians(ang));
  noStroke();
  rect(0, 0, len/2, wid);
  triangle(len/6, -wid*1.5, len/6, wid*1.5, len/2, 0);
  popMatrix();
}