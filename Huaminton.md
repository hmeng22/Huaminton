# Huaminton

主要实现功能, 羽毛球计分, 提示发球人位置, 纪录比赛结果, 蓝牙控制器.

## Descriptions

功能描述:

* 支持设备
	* iPhone, iPad, Android, Pad
* 赛制
	* 类型 
	* 局数
	* 分制
* 记分
	* 得分
	* 撤销上一步操作
	* 重置
* 发球人
	* 初始随机一名队员发球
	* 奇数,偶数分别在左、右场区发球
	* 得分者发球
* 比赛历史纪录
	* 时间, 赛制, 参赛人, 比分, 时长
* 系统功能
	* 开始, 暂停, 重置, 屏幕是否常亮, 退出
* 国际化与本地化
	* 简体中文, 英语, 日语, 韩语
* Remote Control
	* 添加控制器远程触发计分动作:至少有两种输出:A得分,B得分, 撤销等动作函数
	* 蓝牙连接界面,

1. 输入

		类型选择 : 单人, 双人
		局数选择 : 1, 3, 5, 7
		分制选择 : 11, 21, 31
		
		队员设置 : 名字, 颜色, 照片
		
2. 动作

		比赛 : 
			得分 : 得分
			撤销 : 回到上一个状态
			重置 : 比分重置
			
		系统 :
			开始 : 根据输入参数初始化比赛,开始计时
			暂停 : 暂停计时
			重置 : 重置比分
			退出 : 放弃此次比赛
			
			屏幕常亮 : 
			选择语言 : 
			帮助视频 : 
			Version, Rate Me, About Me, Feedback, Official Website
			
			InterfaceOrientation : portrait
			
			iCloud View History : 

3. 数据结构

		--- --- --- --- --- --- --- --- --- --- --- --- 
		enum HUAMINTON_TYPE{
		    HUAMINTON_TYPE_SINGLE,
		    HUAMINTON_TYPE_DOUBLE,
		};
		enum HUAMINTON_ROUNDS{
		    HUAMINTON_ROUNDS_ONE,
		    HUAMINTON_ROUNDS_THREE,
		    HUAMINTON_ROUNDS_FIVE,
		    HUAMINTON_ROUNDS_SEVEN,
		    HUAMINTON_ROUNDS_COUNTS,
		};
		enum HUAMINTON_POINTS{
		    HUAMINTON_POINTS_ELEVEN,
		    HUAMINTON_POINTS_TWENTYONE,
		    HUAMINTON_POINTS_THIRTYONE,
		    HUAMINTON_POINTS_COUNTS,
		};
		enum HUAMINTON_POSITIONS{
		    HUAMINTON_POSITIONS_HOMEA,
		    HUAMINTON_POSITIONS_HOMEB,
		    HUAMINTON_POSITIONS_AWAYB,
		    HUAMINTON_POSITIONS_AWAYA,
		};
		#define HOMEA_NAME @"HomeA"
		#define HOMEB_NAME @"HomeB"
		#define AWAYB_NAME @"AwayB"
		#define AWAYA_NAME @"AwayA"
		
		BadmintonGame
			type, rounds, points, players
			
			roundIndex, pointIndex
			homeSet, awaySet, match
			server, positions
			serverHistory, positionsHistory
			
			isHomeGameWinner, isHomeRoundWinner
			isNewRound
			
			
			-(void)initHuamintonGame;
			
			-(void)homeGetOnePoint;
			-(void)awayGetOnePoint;
			
			-(Boolean)isRoundEnd;
			-(Boolean)isGameEnd;
			
			-(void)nextRound;
			
			-(void)saveData;
		--- --- --- --- --- --- --- --- --- --- --- --- 
		BadmintonMatch
			startDate, endDate
			
			maxPoint, gamePoint
			homePoint, awayPoint
			homePointHistory, awayPointHistory
			
			-initHuamintonMatch:points;
			
			-(void)homeGetOnePoint;
			-(void)awayGetOnePoint;
			
			-(void)addPointToHistory;
			-(void)deletePointFromHistory;
			-(void)resetPoint;
			
		--- --- --- --- --- --- --- --- --- --- --- --- 
		BadmintionPlayer
			name, color, image
			
			-initWithName:name :color;
		--- --- --- --- --- --- --- --- --- --- --- --- 
		
4. 逻辑

		--- --- --- --- --- --- --- --- --- --- --- --- 
		计分规则
			1. 每球直接得分, 先到21分者获胜
			2. 如果双方打到20平手, 连续得2分者获胜
			3. 否则先取得30分者获胜
			4. 一局的胜方在下一局首先发球
		
		发球规则
			1. 最开始发球随机队伍在右方发球区发球,之后上一局胜利者在本区右方发球区发球
			2. 发球方的得分为偶数时, 在右方发球区内准备发球或接发球;奇数时为左方发球区
			3. 得分后获得发球权, 当连续得分的时候, 球员在自己的两个发球区内交替发球

		保存规则
			1. 如果一局比赛结束, 保存结果
			2. 如果一场比赛结束, 保存结果
			3. 没有胜利者, 放弃结果

		历史纪录
			正向
			1. 本轮 pointIndex
			2. 算分 match - toHistory
			3. 确定发球者 server
			4. 确定位置 positions
			5. server and postions - toHistory
			6. 下一轮 pointIndex++
			
			反向
			1. 如果有上一轮 pointIndex--
			2. 算分 match - fromHistory
			3. 确定发球者 server
			4. 确定位置 positions
			5. server and postions - fromHistory
			
		--- --- --- --- --- --- --- --- --- --- --- --- 

## View

```
mainView
 -------------------------
|  ---------     -------  |
| |  Type   |   | S | D | | 
|  ---------     -------  |
|  ---------   ---------  |
| |  Rounds | |  Points | |
|  ---------   ---------  |
|     1            11     |
| |   3      |     21   | |
|     5            31     |
|                         |
|  ---------   ---------  |
| |  HomeA  | |  AwayA  | |
| |         | |         | |
|  ---------   ---------  |
|  ---------   ---------  |
| |  HomeB  | |  AwayB  | |
| |         | |         | |
|  --------    ---------  |
|                         |
|  ---------------------  |
| |        Start        | |
|  ---------------------  |
|                         |
|  ---------   ---------  |
| | Setting | | History | |
|  ---------   ---------  |
 -------------------------

Label : Type, Rounds, Points
Segment : S|D
Picker : 1-3-5-7, 11-21-31
Button : HomeA, HomeB, AwayA, AwayB, Start, Setting, Histroy

View Background Color : (236,236,236)

Label Text Color : (77,77,77)
Font : System Heavy 24.0
Alignmnt : Center
Label Background Color : clear color
Label Tint Color : clear color

Segment Background Color : clear color
Segment Tint Color : (61,74,93)

Picker Background Color : clear color
Font : bold system font 40
Picker Text Color : (77,77,77)

Button Text Color : 
	Default : Dark Gray Color
	Disable : Light Text Color
Font System Medium 20
Button Shadow Color : clear color
Button Background Color : clear color
Button Tint Color : clear color

Start Button 
Background Color : (230,15,40)
Text Color : white color
Shadow Color : clear color
Tint Color : clear color
Font System Black 40

Setting & History Buttons
Background Color : clear color
Text Color : (77,77,77)
Shadow Color : clear color
Tint Color : clear color
Font System thin 30

Constraints:
	too lazy to write them down

 --------- 
|  A1 B1  |
|  A2 B2  |
 ---------
 -------------------------
|                         |
|   -------------------   |
|  |        name       |  |
|   -------------------   |
|                         |
|   -------------------   |
|  |       color       |  |
|   -------------------   |
|                         |
|   -------------------   |
|  |                   |  |
|  |       image       |  |
|  |                   |  |
|   -------------------   |
|                         |
|   -------------------   |
|  |        done       |  |
|   -------------------   |
 -------------------------

Name Text Field
Font System Bold 24
Text Color : Dark Gray Color
Shadow Color : clear color
Background Color : white color
Tint Color : clear color

Done Button
Background Color : 
Text Color : white color
Shadow Color : clear color
Background Color : white color

 ---------------------  
|        Start        | 
 ---------------------  
recordView
 -------------------------
| ----------------------- |
||         Button        || 
|| ---------   --------- ||
|||  Label  | |  Label  |||
|||         | |         |||
|||         | |         |||
|||         | |         |||
|||         | |         |||
|||         | |         |||
|| ---------   --------- ||
| ----------------------- |
| --------  ---  -------- |
||    F   || S ||    E   ||
| --------  ---  -------- |
| ----------------------- |
|| ---------   --------- ||
|||         | |         |||
|||         | |         |||
|||         | |         |||
|||         | |         |||
|||         | |         |||
|||  Label  | |  Label  |||
|| ---------   --------- ||
||         Button        || 
| ----------------------- |
 -------------------------

Button:
	Background : transparent

M : Menu ActionSheet : Undo, Reset
S : Score
E : Exit

 ---------
| Setting |
 ---------
 settingView
 -------------------------
|                         |
|   -------------------   |
|  |                   |  |
|  |       Logo        |  |
|  |                   |  |
|   -------------------   |
|                         |
|                         |
|   -------------------   |
|  |      version      |  |
|   -------------------   |
|   -------------------   |
|  |       About       |  |
|   -------------------   |
|   -------------------   |
|  |      Rate Me      |  |
|   -------------------   |
|   -------------------   |
|  |     Feed Back     |  |
|   -------------------   |
|                         |
|   | Offical Website |   |
 -------------------------


 ---------
| History |
 ---------
 historyView
 -------------------------
|-------------------------|
||         Table         ||
|-------------------------|
|-------------------------|
||                       ||
|-------------------------|
|-------------------------|
||                       ||
|-------------------------|
|-------------------------|
||                       ||
|-------------------------|
|-------------------------|
||                       ||
|-------------------------|
|                         |
|                         |
|  ---------   ---------  |
| | Export  | |  Return | |
|  ---------   ---------  |
 -------------------------

Export : Email in formatted
```


## Database

```objectivec
gamename = datetime(yyyy-MM-dd HH:mm:ss)

CREATE TABLE games (
	id			INTEGER  PRIMARY KEY 	AUTOINCREMENT,
	gamename	TEXT,
	gamedate	TEXT,
	gametime	TEXT,
	gamenum	INTEGER,
	type		INTEGER,
	rounds		INTEGER,
	points		INTEGER,
	haname		TEXT,
	hacolor 	INTEGER,
	haphotost	TEXT,
	hbname		TEXT,
	hbcolor 	INTEGER,
	hbphotost	TEXT,
	aaname		TEXT,
	aacolor 	INTEGER,
	aaphotost	TEXT,
	abname		TEXT,
	abcolor 	INTEGER,
	abphotost	TEXT,
	hset		INTEGER,
	aset		INTEGER
);


NSString *createTabelgames = @"CREATE TABLE games (  id INTEGER  PRIMARY KEY  AUTOINCREMENT,  gamename TEXT,  gamedate TEXT,  gametime TEXT,  gamenum  INTEGER,  type  INTEGER,  rounds  INTEGER,  points  INTEGER,  haname  TEXT,  hacolor  INTEGER,  haphotost  TEXT,  hbname  TEXT,  hbcolor  INTEGER,  hbphotost  TEXT,  aaname  TEXT,  aacolor  INTEGER,  aaphotost  TEXT,  abname  TEXT,  abcolor  INTEGER,  abphotost  TEXT,  hset  INTEGER,  aset  INTEGER  );";
[self.db executeUpdate:createTabelgames];


SINGLE:
[db executeUpdate:@"insert into games(gamename,gamedate,gametime,gamenum,type,rounds,points,haname,hacolor,haphotost,aaname,aacolor,aaphotost,hset,aset) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",gamename,gamedate,gametime,[NSNumber numberWithInteger:type],[NSNumber numberWithInteger:rounds],[NSNumber numberWithInteger:points],åhaname,[NSNumber numberWithInteger:hacolor],haphotostring,haname,[NSNumber numberWithInteger:hacolor],haphotostring,[NSNumber numberWithInteger:homeset],[NSNumber numberWithInteger:awayset]];

DOUBLE:
[db executeUpdate:@"insert into games(gamename,gamedate,gametime,type,rounds,points,haname,hacolor,haphotost,hbname,hbcolor,hbphotost,aaname,aacolor,aaphotost,abname,abcolor,abphotost,hset,aset) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",gamename,gamedate,gametime,[NSNumber numberWithInteger:type],[NSNumber numberWithInteger:rounds],[NSNumber numberWithInteger:points],haname,[NSNumber numberWithInteger:hacolor],haphotostring,haname,[NSNumber numberWithInteger:hacolor],haphotostring,haname,[NSNumber numberWithInteger:hacolor],haphotostring,haname,[NSNumber numberWithInteger:hacolor],haphotostring,[NSNumber numberWithInteger:homeset],[NSNumber numberWithInteger:awayset]];

Update result:
[db executeUpdate:@"update games set hset=?, aset=? where gamename=?",[NSNumber numberWithInteger:homeset],[NSNumber numberWithInteger:awayset],gamename];

-saveGameInitData
	// type, rounds, points, players


-saveGameResultData
	// homeset, awayset

--- --- --- --- --- --- 

roundname = gamename + roundIndex(1,2,3,4,5,6,7);

CREATE TABLE rounds (
	id			INTEGER PRIMARY KEY 	AUTOINCREMENT,
	roundname	TEXT,
	roundtime	TEXT,
	pointnum	INTEGER DEFAULT 0,
	homepoint	INTEGER DEFAULT 0,
	awaypoint INTEGER DEFAULT 0,
	h0			INTEGER DEFAULT -1,
	h1			INTEGER DEFAULT -1,
	h2			INTEGER DEFAULT -1,
	h3			INTEGER DEFAULT -1,
	h4			INTEGER DEFAULT -1,
	h5			INTEGER DEFAULT -1,
	h6			INTEGER DEFAULT -1,
	h7			INTEGER DEFAULT -1,
	h8			INTEGER DEFAULT -1,
	h9			INTEGER DEFAULT -1,
	h10			INTEGER DEFAULT -1,
	h11			INTEGER DEFAULT -1,
	h12			INTEGER DEFAULT -1,
	h13			INTEGER DEFAULT -1,
	h14			INTEGER DEFAULT -1,
	h15			INTEGER DEFAULT -1,
	h16			INTEGER DEFAULT -1,
	h17			INTEGER DEFAULT -1,
	h18			INTEGER DEFAULT -1,
	h19			INTEGER DEFAULT -1,
	h20			INTEGER DEFAULT -1,
	h21			INTEGER DEFAULT -1,
	h22			INTEGER DEFAULT -1,
	h23			INTEGER DEFAULT -1,
	h24			INTEGER DEFAULT -1,
	h25			INTEGER DEFAULT -1,
	h26			INTEGER DEFAULT -1,
	h27			INTEGER DEFAULT -1,
	h28			INTEGER DEFAULT -1,
	h29			INTEGER DEFAULT -1,
	h30			INTEGER DEFAULT -1,
	h31			INTEGER DEFAULT -1,
	h32			INTEGER DEFAULT -1,
	h33			INTEGER DEFAULT -1,
	h34			INTEGER DEFAULT -1,
	h35			INTEGER DEFAULT -1,
	h36			INTEGER DEFAULT -1,
	h37			INTEGER DEFAULT -1,
	h38			INTEGER DEFAULT -1,
	h39			INTEGER DEFAULT -1,
	h40			INTEGER DEFAULT -1,
	h41			INTEGER DEFAULT -1,
	h42			INTEGER DEFAULT -1,
	h43			INTEGER DEFAULT -1,
	h44			INTEGER DEFAULT -1,
	h45			INTEGER DEFAULT -1,
	h46			INTEGER DEFAULT -1,
	h47			INTEGER DEFAULT -1,
	h48			INTEGER DEFAULT -1,
	h49			INTEGER DEFAULT -1,
	h50			INTEGER DEFAULT -1,
	h51			INTEGER DEFAULT -1,
	h52			INTEGER DEFAULT -1,
	h53			INTEGER DEFAULT -1,
	h54			INTEGER DEFAULT -1,
	h55			INTEGER DEFAULT -1,
	h56			INTEGER DEFAULT -1,
	h57			INTEGER DEFAULT -1,
	h58			INTEGER DEFAULT -1,
	h59			INTEGER DEFAULT -1,
	h60			INTEGER DEFAULT -1,
	h61			INTEGER DEFAULT -1,
	h62			INTEGER DEFAULT -1,
	h63			INTEGER DEFAULT -1,
	h64			INTEGER DEFAULT -1,
	h65			INTEGER DEFAULT -1,
	h66			INTEGER DEFAULT -1,
	h67			INTEGER DEFAULT -1,
	h68			INTEGER DEFAULT -1,
	h69			INTEGER DEFAULT -1,
	h70			INTEGER DEFAULT -1,
	h71			INTEGER DEFAULT -1,
	h72			INTEGER DEFAULT -1,
	h73			INTEGER DEFAULT -1,
	h74			INTEGER DEFAULT -1,
	h75			INTEGER DEFAULT -1,
	h76			INTEGER DEFAULT -1,
	h77			INTEGER DEFAULT -1,
	h78			INTEGER DEFAULT -1,
	h79			INTEGER DEFAULT -1,
	h80			INTEGER DEFAULT -1,
	a0			INTEGER DEFAULT -1,
	a1			INTEGER DEFAULT -1,
	a2			INTEGER DEFAULT -1,
	a3			INTEGER DEFAULT -1,
	a4			INTEGER DEFAULT -1,
	a5			INTEGER DEFAULT -1,
	a6			INTEGER DEFAULT -1,
	a7			INTEGER DEFAULT -1,
	a8			INTEGER DEFAULT -1,
	a9			INTEGER DEFAULT -1,
	a10			INTEGER DEFAULT -1,
	a11			INTEGER DEFAULT -1,
	a12			INTEGER DEFAULT -1,
	a13			INTEGER DEFAULT -1,
	a14			INTEGER DEFAULT -1,
	a15			INTEGER DEFAULT -1,
	a16			INTEGER DEFAULT -1,
	a17			INTEGER DEFAULT -1,
	a18			INTEGER DEFAULT -1,
	a19			INTEGER DEFAULT -1,
	a20			INTEGER DEFAULT -1,
	a21			INTEGER DEFAULT -1,
	a22			INTEGER DEFAULT -1,
	a23			INTEGER DEFAULT -1,
	a24			INTEGER DEFAULT -1,
	a25			INTEGER DEFAULT -1,
	a26			INTEGER DEFAULT -1,
	a27			INTEGER DEFAULT -1,
	a28			INTEGER DEFAULT -1,
	a29			INTEGER DEFAULT -1,
	a30			INTEGER DEFAULT -1,
	a31			INTEGER DEFAULT -1,
	a32			INTEGER DEFAULT -1,
	a33			INTEGER DEFAULT -1,
	a34			INTEGER DEFAULT -1,
	a35			INTEGER DEFAULT -1,
	a36			INTEGER DEFAULT -1,
	a37			INTEGER DEFAULT -1,
	a38			INTEGER DEFAULT -1,
	a39			INTEGER DEFAULT -1,
	a40			INTEGER DEFAULT -1,
	a41			INTEGER DEFAULT -1,
	a42			INTEGER DEFAULT -1,
	a43			INTEGER DEFAULT -1,
	a44			INTEGER DEFAULT -1,
	a45			INTEGER DEFAULT -1,
	a46			INTEGER DEFAULT -1,
	a47			INTEGER DEFAULT -1,
	a48			INTEGER DEFAULT -1,
	a49			INTEGER DEFAULT -1,
	a50			INTEGER DEFAULT -1,
	a51			INTEGER DEFAULT -1,
	a52			INTEGER DEFAULT -1,
	a53			INTEGER DEFAULT -1,
	a54			INTEGER DEFAULT -1,
	a55			INTEGER DEFAULT -1,
	a56			INTEGER DEFAULT -1,
	a57			INTEGER DEFAULT -1,
	a58			INTEGER DEFAULT -1,
	a59			INTEGER DEFAULT -1,
	a60			INTEGER DEFAULT -1,
	a61			INTEGER DEFAULT -1,
	a62			INTEGER DEFAULT -1,
	a63			INTEGER DEFAULT -1,
	a64			INTEGER DEFAULT -1,
	a65			INTEGER DEFAULT -1,
	a66			INTEGER DEFAULT -1,
	a67			INTEGER DEFAULT -1,
	a68			INTEGER DEFAULT -1,
	a69			INTEGER DEFAULT -1,
	a70			INTEGER DEFAULT -1,
	a71			INTEGER DEFAULT -1,
	a72			INTEGER DEFAULT -1,
	a73			INTEGER DEFAULT -1,
	a74			INTEGER DEFAULT -1,
	a75			INTEGER DEFAULT -1,
	a76			INTEGER DEFAULT -1,
	a77			INTEGER DEFAULT -1,
	a78			INTEGER DEFAULT -1,
	a79			INTEGER DEFAULT -1,
	a80			INTEGER DEFAULT -1
);


NSString *createTablerounds = @"CREATE TABLE rounds ( id INTEGER PRIMARY KEY AUTOINCREMENT, roundname	TEXT, roundtime	TEXT, pointnum	INTEGER DEFAULT 0, homepoint	INTEGER DEFAULT 0, awaypoint INTEGER DEFAULT 0, h0 INTEGER DEFAULT -1, h1 INTEGER DEFAULT -1, h2 INTEGER DEFAULT -1, h3 INTEGER DEFAULT -1, h4 INTEGER DEFAULT -1, h5 INTEGER DEFAULT -1, h6 INTEGER DEFAULT -1, h7 INTEGER DEFAULT -1, h8 INTEGER DEFAULT -1, h9 INTEGER DEFAULT -1, h10 INTEGER DEFAULT -1, h11 INTEGER DEFAULT -1, h12 INTEGER DEFAULT -1, h13 INTEGER DEFAULT -1, h14 INTEGER DEFAULT -1, h15 INTEGER DEFAULT -1, h16 INTEGER DEFAULT -1, h17 INTEGER DEFAULT -1, h18 INTEGER DEFAULT -1, h19 INTEGER DEFAULT -1, h20 INTEGER DEFAULT -1, h21 INTEGER DEFAULT -1, h22 INTEGER DEFAULT -1, h23 INTEGER DEFAULT -1, h24 INTEGER DEFAULT -1, h25 INTEGER DEFAULT -1, h26 INTEGER DEFAULT -1, h27 INTEGER DEFAULT -1, h28 INTEGER DEFAULT -1, h29 INTEGER DEFAULT -1, h30 INTEGER DEFAULT -1, h31 INTEGER DEFAULT -1, h32 INTEGER DEFAULT -1, h33 INTEGER DEFAULT -1, h34 INTEGER DEFAULT -1, h35 INTEGER DEFAULT -1, h36 INTEGER DEFAULT -1, h37 INTEGER DEFAULT -1, h38 INTEGER DEFAULT -1, h39 INTEGER DEFAULT -1, h40 INTEGER DEFAULT -1, h41 INTEGER DEFAULT -1, h42 INTEGER DEFAULT -1, h43 INTEGER DEFAULT -1, h44 INTEGER DEFAULT -1, h45 INTEGER DEFAULT -1, h46 INTEGER DEFAULT -1, h47 INTEGER DEFAULT -1, h48 INTEGER DEFAULT -1, h49 INTEGER DEFAULT -1, h50 INTEGER DEFAULT -1, h51 INTEGER DEFAULT -1, h52 INTEGER DEFAULT -1, h53 INTEGER DEFAULT -1, h54 INTEGER DEFAULT -1, h55 INTEGER DEFAULT -1, h56 INTEGER DEFAULT -1, h57 INTEGER DEFAULT -1, h58 INTEGER DEFAULT -1, h59 INTEGER DEFAULT -1, h60 INTEGER DEFAULT -1, h61 INTEGER DEFAULT -1, h62 INTEGER DEFAULT -1, h63 INTEGER DEFAULT -1, h64 INTEGER DEFAULT -1, h65 INTEGER DEFAULT -1, h66 INTEGER DEFAULT -1, h67 INTEGER DEFAULT -1, h68 INTEGER DEFAULT -1, h69 INTEGER DEFAULT -1, h70 INTEGER DEFAULT -1, h71 INTEGER DEFAULT -1, h72 INTEGER DEFAULT -1, h73 INTEGER DEFAULT -1, h74 INTEGER DEFAULT -1, h75 INTEGER DEFAULT -1, h76 INTEGER DEFAULT -1, h77 INTEGER DEFAULT -1, h78 INTEGER DEFAULT -1, h79 INTEGER DEFAULT -1, h80 INTEGER DEFAULT -1, a0 INTEGER DEFAULT -1, a1 INTEGER DEFAULT -1, a2 INTEGER DEFAULT -1, a3 INTEGER DEFAULT -1, a4 INTEGER DEFAULT -1, a5 INTEGER DEFAULT -1, a6 INTEGER DEFAULT -1, a7 INTEGER DEFAULT -1, a8 INTEGER DEFAULT -1, a9 INTEGER DEFAULT -1, a10 INTEGER DEFAULT -1, a11 INTEGER DEFAULT -1, a12 INTEGER DEFAULT -1, a13 INTEGER DEFAULT -1, a14 INTEGER DEFAULT -1, a15 INTEGER DEFAULT -1, a16 INTEGER DEFAULT -1, a17 INTEGER DEFAULT -1, a18 INTEGER DEFAULT -1, a19 INTEGER DEFAULT -1, a20 INTEGER DEFAULT -1, a21 INTEGER DEFAULT -1, a22 INTEGER DEFAULT -1, a23 INTEGER DEFAULT -1, a24 INTEGER DEFAULT -1, a25 INTEGER DEFAULT -1, a26 INTEGER DEFAULT -1, a27 INTEGER DEFAULT -1, a28 INTEGER DEFAULT -1, a29 INTEGER DEFAULT -1, a30 INTEGER DEFAULT -1, a31 INTEGER DEFAULT -1, a32 INTEGER DEFAULT -1, a33 INTEGER DEFAULT -1, a34 INTEGER DEFAULT -1, a35 INTEGER DEFAULT -1, a36 INTEGER DEFAULT -1, a37 INTEGER DEFAULT -1, a38 INTEGER DEFAULT -1, a39 INTEGER DEFAULT -1, a40 INTEGER DEFAULT -1, a41 INTEGER DEFAULT -1, a42 INTEGER DEFAULT -1, a43 INTEGER DEFAULT -1, a44 INTEGER DEFAULT -1, a45 INTEGER DEFAULT -1, a46 INTEGER DEFAULT -1, a47 INTEGER DEFAULT -1, a48 INTEGER DEFAULT -1, a49 INTEGER DEFAULT -1, a50 INTEGER DEFAULT -1, a51 INTEGER DEFAULT -1, a52 INTEGER DEFAULT -1, a53 INTEGER DEFAULT -1, a54 INTEGER DEFAULT -1, a55 INTEGER DEFAULT -1, a56 INTEGER DEFAULT -1, a57 INTEGER DEFAULT -1, a58 INTEGER DEFAULT -1, a59 INTEGER DEFAULT -1, a60 INTEGER DEFAULT -1, a61 INTEGER DEFAULT -1, a62 INTEGER DEFAULT -1, a63 INTEGER DEFAULT -1, a64 INTEGER DEFAULT -1, a65 INTEGER DEFAULT -1, a66 INTEGER DEFAULT -1, a67 INTEGER DEFAULT -1, a68 INTEGER DEFAULT -1, a69 INTEGER DEFAULT -1, a70 INTEGER DEFAULT -1, a71 INTEGER DEFAULT -1, a72 INTEGER DEFAULT -1, a73 INTEGER DEFAULT -1, a74 INTEGER DEFAULT -1, a75 INTEGER DEFAULT -1, a76 INTEGER DEFAULT -1, a77 INTEGER DEFAULT -1, a78 INTEGER DEFAULT -1, a79 INTEGER DEFAULT -1, a80 INTEGER DEFAULT -1);";
[self.db executeUpdate:createTablerounds];


NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
[dictonary setObject:roundname forKey:@"roundname"];
[self.database executeUpdate:@"update rounds set roundname=:roundname" withParameterDictionary:dictonary];


-saveNewRoundData
    // roundname,roundtime

-saveRoundResultData
    // homePointHistory, awayPointHistory
```