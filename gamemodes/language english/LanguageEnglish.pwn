/*
																			CHANGELOGS NEWUPDATE 1.7 PearL
		- Added Command /SPEC
		- Added Command /SETWEATHER
		- Added Command /SETTIME
		- Added Command /MAKEADMIN
		- Added Command /GIVECASH
		- Added Anti CHENH4X
		- Switch Name w1.2 to 1.7 PearL
		- Added New Team ( Great Britan )
		- Added Command /BAN /UNBAN
		- Added Command /JAIL /UNJAIL
		- Added Command /KICK
		- Added New CAPTURES ZONE
		- Added BASE BRITAN & CAR
		- Added VIP SYSTEM
		- Update Database Mysql

		UPDATE STATS
		DAY : SATURDAY
		DATE : 07/30/22
		TIME : 9:59 PM
		
		MESSAGE FROM THE DEVELOPER
		
		- USE THIS GAMEMODE AS WELL AS POSSIBLE NEVER FOR SALE, YOU GET THE GAMEMODE FOR FREE WITHOUT BUYING
		PLEASE RESPECT THE DEVELOPERS OF THIS GAMEMODE ( K_ZxZ Or I Typed This Message Myself. )

		- THIS GAMEMODE FOR FREE YOU CAN HAVE. IF YOU WANT TO UPDATE AGAIN, PLEASE I ALLOW ME BUT IF THIS GAMEMODE IS SOLD YOU ARE A COPYRIGHT INFRINGEMENT.

																			MEDIA DEVELOPER
		- DISCORD : K_ZxZ#0777
		- YOUTUBE : https://www.youtube.com/channel/UCrFGy7gBa8BXN5cbxH8UBtA
		- GITHUB : https://github.com/KZxZ12
*/

// I N C L U D E
#include <a_samp>					// by SA_MP team
#include <a_mysql>					// by BlueG					>	github.com/pBlueG/SA-MP-MySQL/releases/tag/R41-2
#include <foreach>
#include <YSI_Coding\y_va>          // by Y_Less             	>   github.com/pawn-lang/YSI-Includes
#include <samp_bcrypt>              // by Sreyas-Sreelal		>	github.com/Sreyas-Sreelal/samp-bcrypt
#include <zcmd>                     // by Zeex					>   github.com/Southclaws/zcmd
#include <streamer>					// by incognito				>	github.com/samp-incognito/samp-streamer-plugin/releases/tag/v2.9.1
#include <sscanf2>					// by Y_Less				>	github.com/maddinat0r/sscanf/releases/tag/v2.8.2
//#include <YSI\y_ini>


// D E F I N E

#define forex(%0,%1) for(new %0 = 0; %0 < %1; %0++)

#define WW5C::%0(%1) forward %0(%1); public %0(%1)

#define MAX_CHARS 3

#define DATABASE_ADDRESS "localhost"
#define DATABASE_USERNAME "root"
#define DATABASE_PASSWORD ""
#define DATABASE_NAME "gmtest"

#if !defined ACCOUNTS_WW5C
	#define ACCOUNTS_WW5C 250
#endif

#if !defined BCOST
	#define BCOST 12
#endif

#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, 0x00FFFFFF, "SERVER:{FFFFFF} "%1)

#define SendSyntaxMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_WHITE, "USE:{FFFFFF} "%1)
	
#define SendErrorMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_WHITE, "ERROR: "%1)

// T E A M S

#define TEAM_USA 0
#define TEAM_USSR 1
#define TEAM_ARAB 2
#define TEAM_GERMANY 3
#define TEAM_AFRICA 4
#define TEAM_INDONESIA 5
#define TEAM_LATINO 6
#define TEAM_BRITAN 7
#define TEAM_NONE 8


// K E L A S

#define ASSAULT 1
#define SNIPER 2
#define MEDIC 3

// D I A L O G S
#define DIALOG_HELP 789
#define DIALOG_CMDS 790
#define DIALOG_RANKS 791
#define DIALOG_CHANGELOGS 792
#define DIALOG_ADMIN 793

// C A P Z O N E S
#define Zone1 0
#define Zone2 1
#define Zone3 2
#define Zone4 3
#define Zone5 4
#define Zone6 5
#define Zone7 6
#define Zone8 7
#define Zone9 8
#define Zone10 9

// P A T H S

enum e_world_war_data
{
	pID,
	pUCP[22],
	pName[MAX_PLAYER_NAME],
	Float:pPos[3],
	pSkin,
	pAge,
	pAttempt,
	pOrigin[32],
	pGender,
	pSpawn,
	pChar,
	pMoney,
	pAdmin,
	pAduty,
	pSpectator,
	pGuns[10],
	pAmmo[10],
	pLevel,
	pExp,
	pJailTime,
	pJailReason[32],
	pJailedBy[MAX_PLAYER_NAME],
};

new WorldWar5CountryData[MAX_PLAYERS][e_world_war_data];

enum
{
	DIALOG_REGISTER,
	DIALOG_LOGIN,
	DIALOG_MAKECHAR,
	DIALOG_ORIGIN,
	DIALOG_AGE,
	DIALOG_CHARLIST,
	DIALOG_NONE
};

// I NCLUDE S GAME
#include "modules\stock.pwn"
#include "modules\defines.pwn"

// V A R I A B L E

new MySQL:sqlww5c;
new PlayerCheckGM[MAX_PLAYERS char];
new SurvivorsChar[MAX_PLAYERS][MAX_CHARS][MAX_PLAYER_NAME + 1];
new tempUCP[64];

new bool:ServerLocked = false;

new BF1;
new BF2;
new BF3;
new BF4;
new BF5;
new BF6;
new BF7;

new tCP[30];
new UnderAttack[30];
new Captured[30];
new CP[30];
new Zone[30];
new timer[MAX_PLAYERS][30];
new CountVar[MAX_PLAYERS] = 25;
new InCP[MAX_PLAYERS];
new CountTime[MAX_PLAYERS];

new FirstSpawn[MAX_PLAYERS];
// C O O R D I R N A T E S P A W N
new Float:Rebals[][] =
{
   {-367.1493,2205.4155,42.4844,245.1246},
   {-379.1219,2240.8486,42.4695,89.7823},
   {-392.1632,2246.2773,42.4162,60.3521}

};

new Float:ArabSpawn[][] =
{
   {-796.8353,1559.8621,27.1244,88.3696},
   {-729.4165,1558.1375,41.1295,351.5721},
   {-772.0912,1615.7186,27.1244,358.4655}
};
new Float:MercSpawn[][] =
{
   {-148.6964,1111.9276,19.7500,270.2336},
   {203.1372,1872.8495,13.1406,263.0270},
   {-392.1632,2246.2773,42.4162,60.3521}
};
new Float:RusSpawn[][] =
{
   {-148.6964,1111.9276,19.7500,270.2336},
   {-89.2924,1163.3394,19.7422,183.4396},
   {-204.2620,1081.1177,19.7422,270.8604}
};

new Float:EuroSpawn[][] =
{
   {-252.7739,2603.1516,62.8582,263.5070},
   {-200.1243,2665.6450,62.7293,275.1005},
   {-276.1315,2718.0430,62.6376,352.9625}
};

new Float:UsaSpawn[][] =
{
   {203.1372,1872.8495,13.1406,263.0270},
   {230.5600,1937.8513,30.0547,12.6714},
   {245.1640,1839.8844,23.2422,342.5678}
};
new Float:AsiaSpawn[][] =
{
   {-1477.8877,2618.1267,58.7813,87.5035},
   {-1401.9437,2649.2827,55.6875,260.1520},
   {-1515.2573,2522.1611,55.8376,9.5062}
};

new Float:BritanSpawn[][] =
{
   {-2237.2556,2354.2283,4.9798,125.2312},
   {-2255.7058,2382.7578,4.8920,37.8572},
   {-2185.5515,2413.6050,5.1563,206.6556}
};

// T E A M B A S E S
new USA_BASE;
new USSR_BASE;
new ARAB_BASE;
new GERMANY_BASE;
new AFRICA_BASE;
new INDONESIAN_BASE;
new BRITAN_BASE;

// T E A K & K E L A S
new gTeam[MAX_PLAYERS];
new gPlayerClass[MAX_PLAYERS];
new PickedClass[MAX_PLAYERS];

// F O R W A R D
forward SetCaptureZone(playerid);
public SetCaptureZone(playerid)
{
    for(new x=0; x < sizeof(UnderAttack); x++)
    {
        if(InCP[playerid] == x)
        {
       		SetPlayerScore(playerid, GetPlayerScore(playerid)+5);
         	GivePlayerMoney(playerid, 5000);
         	SendClientMessage(playerid, COLOR_YELLOW,"Happy! You have successfully captured this zone!! You get +5 score and +$50.00!");
         	tCP[x] = gTeam[playerid];
         	GangZoneStopFlashForAll(Zone[x]);
         	Captured[x] = 1;
	        KillTimer(CountTime[playerid]);
         	UnderAttack[x] = 0;
         	KillTimer(timer[playerid][x]);
         	switch(gTeam[playerid])
          	{
	           	case TEAM_USA: GangZoneShowForAll(Zone[x], COLOR_LIGHTERBLUE);
	            case TEAM_USSR: GangZoneShowForAll(Zone[x], COLOR_RED);
	            case TEAM_ARAB: GangZoneShowForAll(Zone[x], COLOR_ORANGELIGHT);
	            case TEAM_GERMANY: GangZoneShowForAll(Zone[x], COLOR_GREENLIGHT);
	            case TEAM_AFRICA: GangZoneShowForAll(Zone[x], COLOR_BROWNLIGHT);
	            case TEAM_INDONESIA: GangZoneShowForAll(Zone[x], COLOR_YELLOW);
	            case TEAM_BRITAN: GangZoneShowForAll(Zone[x], COLOR_WHITE);
           }
        }
	}
 	return 1;
}

forward CountDown(playerid);
public CountDown(playerid)
{
    CountVar[playerid]--;
    if(CountVar[playerid] == 0)
    {
      CountVar[playerid] = 20;
      KillTimer(CountTime[playerid]);
    }
    CountTime[playerid] = SetTimerEx("CountDown", 1000, false,"i", playerid);
    return 1;
}

// F U N C T I O N
IsNumeric(const str[])
{
	for (new i = 0, l = strlen(str); i != l; i ++)
	{
	    if (i == 0 && str[0] == '-')
			continue;

	    else if (str[i] < '0' || str[i] > '9')
			return 0;
	}
	return 1;
}

new static g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD", "SFPD", "LVPD",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};


GetVehicleModelByName(const name[])
{
	if(IsNumeric(name) && (strval(name) >= 400 && strval(name) <= 611))
		return strval(name);

	for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
	{
		if(strfind(g_arrVehicleNames[i], name, true) != -1)
		{
			return i + 400;
		}
	}
	return 0;
}

ReturnVehicleModelName(model)
{
	new
	    name[32] = "None";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}

static KickEx(playerid)
{
	SaveSurvivorsData(playerid);
	SetTimerEx("KickTimer", 1000, false, "d", playerid);
}

WW5C::KickTimer(playerid)
{
	Kick(playerid);
}

static GetName(playerid)
{
	new name[MAX_PLAYER_NAME];
 	GetPlayerName(playerid,name,sizeof(name));
	return name;
}

Database_Connect()
{
	sqlww5c = mysql_connect(DATABASE_ADDRESS,DATABASE_USERNAME,DATABASE_PASSWORD,DATABASE_NAME);

	if(mysql_errno(sqlww5c) != 0)
	{
	    print("[MySQL] - Failed Connect!");
	}
	else
	{
		print("[MySQL] - Connected!");
		SetGameModeText("1.7 PearL Latest");
	}
}

static SendClientMessageEx(playerid, colour, const text[], va_args<>)
{
    new str[145];
    va_format(str, sizeof(str), text, va_start<3>);
    return SendClientMessage(playerid, colour, str);
}

static CheckAccount(playerid)
{
	new query[256];
	format(query, sizeof(query), "SELECT * FROM `UCPSystem` WHERE `UCP` = '%s' LIMIT 1;", GetName(playerid));
	mysql_tquery(sqlww5c, query, "CheckPlayerUCP", "d", playerid);
	return 1;
}

WW5C::PlayerCheck(playerid, rcc)
{
	if(rcc != PlayerCheckGM{playerid})
	    return Kick(playerid);
	    
	CheckAccount(playerid);
	return true;
}

WW5C::CheckPlayerUCP(playerid)
{
	new rows = cache_num_rows();
	new str[256];
	if (rows)
	{
	    cache_get_value_name(0, "UCP", tempUCP[playerid]);
	    format(str, sizeof(str), "UCP Name: %s\nAttempts: %d/3\nPassword: ", GetName(playerid), WorldWar5CountryData[playerid][pAttempt]);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "World War 5 Country", str, "Login", "Exit");
	}
	else
	{
	    format(str, sizeof(str), "UCP Name: %s\nAttempts: %d/3\nPassword: ", GetName(playerid), WorldWar5CountryData[playerid][pAttempt]);
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "World War 5 Country", str, "Register", "Exit");
	}
	return 1;
}

static SaveSurvivorsData(playerid)
{
	new query[2512];
	if(WorldWar5CountryData[playerid][pSpawn])
	{
		mysql_format(sqlww5c, query, sizeof(query), "UPDATE `survivors` SET ");
	    mysql_format(sqlww5c, query, sizeof(query), "%s`Age`='%d', ", query, WorldWar5CountryData[playerid][pAge]);
	    mysql_format(sqlww5c, query, sizeof(query), "%s`Origin`='%s', ", query, WorldWar5CountryData[playerid][pOrigin]);
	    mysql_format(sqlww5c, query, sizeof(query), "%s`Gender`='%d', ", query, WorldWar5CountryData[playerid][pGender]);
	    mysql_format(sqlww5c, query, sizeof(query), "%s`AdminLevel`='%d', ", query, WorldWar5CountryData[playerid][pAdmin]);
	    mysql_format(sqlww5c, query, sizeof(query), "%s`Money`='%d', ", query, WorldWar5CountryData[playerid][pMoney]);
	    mysql_format(sqlww5c, query, sizeof(query), "%s`UCP`='%s' ", query, WorldWar5CountryData[playerid][pUCP]);
	    mysql_format(sqlww5c, query, sizeof(query), "%sWHERE `pID` = %d", query, WorldWar5CountryData[playerid][pID]);
		mysql_query(sqlww5c, query, true);
	}
	return 1;
}

WW5C::LoadCharacterData(playerid)
{
	cache_get_value_name_int(0, "pID", WorldWar5CountryData[playerid][pID]);
	cache_get_value_name(0, "Name", WorldWar5CountryData[playerid][pName]);
	cache_get_value_name_int(0, "Age", WorldWar5CountryData[playerid][pAge]);
	cache_get_value_name(0, "Origin", WorldWar5CountryData[playerid][pOrigin]);
	cache_get_value_name_int(0, "Gender", WorldWar5CountryData[playerid][pGender]);
	cache_get_value_name(0, "UCP", WorldWar5CountryData[playerid][pUCP]);
	cache_get_value_name_int(0, "AdminLevel", WorldWar5CountryData[playerid][pAdmin]);
	cache_get_value_name_int(0, "Money", WorldWar5CountryData[playerid][pMoney]);
	
    SendServerMessage(playerid, "Your account is stored in the 'Survivors' database!");
    return 1;
}

WW5C::HashPlayerPassword(playerid, hashid)
{
	new
		query[256],
		hash[ACCOUNTS_WW5C];

    bcrypt_get_hash(hash, sizeof(hash));

	GetPlayerName(playerid, tempUCP[playerid], MAX_PLAYER_NAME + 1);

	format(query,sizeof(query),"INSERT INTO `UCPSystem` (`UCP`, `Password`) VALUES ('%s', '%s')", tempUCP[playerid], hash);
	mysql_tquery(sqlww5c, query);

    SendServerMessage(playerid, "Your UCP is successfully registered!");
    CheckAccount(playerid);
	return 1;
}

ShowCharacterList(playerid)
{
	new name[256], count, sgstr[128];

	for (new i; i < MAX_CHARS; i ++) if(SurvivorsChar[playerid][i][0] != EOS)
	{
	    format(sgstr, sizeof(sgstr), "%s\n", SurvivorsChar[playerid][i]);
		strcat(name, sgstr);
		count++;
	}
	if(count < MAX_CHARS)
		strcat(name, "< Create Character >");

	ShowPlayerDialog(playerid, DIALOG_CHARLIST, DIALOG_STYLE_LIST, "Character List", name, "Pilih", "Quit");
	return 1;
}

WW5C::LoadCharacter(playerid)
{
	for (new i = 0; i < MAX_CHARS; i ++)
	{
		SurvivorsChar[playerid][i][0] = EOS;
	}
	for (new i = 0; i < cache_num_rows(); i ++)
	{
		cache_get_value_name(i, "Name", SurvivorsChar[playerid][i]);
	}
  	ShowCharacterList(playerid);
  	return 1;
}

WW5C::OnPlayerPasswordChecked(playerid, bool:success)
{
	new str[256];
    format(str, sizeof(str), "UCP Name: %s\nAttempts: %d/3\nPassword: ", GetName(playerid), WorldWar5CountryData[playerid][pAttempt]);
    
	if(!success)
	{
	    if(WorldWar5CountryData[playerid][pAttempt] < 3)
	    {
		    WorldWar5CountryData[playerid][pAttempt]++;
	        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "World War 5 Country", str, "Login", "Exit");
			return 1;
		}
		else
		{
		    SendServerMessage(playerid, "You have entered the wrong password 3 times!");
		    KickEx(playerid);
			return 1;
		}
	}
	new query[256];
	format(query, sizeof(query), "SELECT `Name` FROM `survivors` WHERE `UCP` = '%s' LIMIT %d;", GetName(playerid), MAX_CHARS);
	mysql_tquery(sqlww5c, query, "LoadCharacter", "d", playerid);
	return 1;
}

WW5C::InsertPlayerName(playerid, name[])
{
	new count = cache_num_rows(), query[145], Cache:execute;
	if(count > 0)
	{
        ShowPlayerDialog(playerid, DIALOG_MAKECHAR, DIALOG_STYLE_INPUT, "Create Character", "ERROR: This name is already used by another player!", "Create", "Back");
	}
	else
	{
		mysql_format(sqlww5c,query,sizeof(query),"INSERT INTO `survivors` (`Name`,`UCP`) VALUES('%e','%e')",name,GetName(playerid));
		execute = mysql_query(sqlww5c, query);
		WorldWar5CountryData[playerid][pID] = cache_insert_id();
	 	cache_delete(execute);
	 	SetPlayerName(playerid, name);
		format(WorldWar5CountryData[playerid][pName], MAX_PLAYER_NAME, name);
	 	ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Character Age", "Input Your Character Age", "Continue", "Batal");
	}
	return 1;
}

static ResetVariable(playerid)
{
	WorldWar5CountryData[playerid][pMoney] = 0;
	WorldWar5CountryData[playerid][pAttempt] = 0;
	WorldWar5CountryData[playerid][pSpawn] = false;
	return 1;
}

public OnGameModeInit()
{
	Database_Connect();
    UsePlayerPedAnims();
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
    AddPlayerClass(287,203.1372,1872.8495,13.1406,263.0270,0,0,0,0,0,0); // USA SPAWN 1
    AddPlayerClass(285,-148.6964,1111.9276,19.7500,270.2336,0,0,0,0,0,0); // USSR SPAWN 1
    AddPlayerClass(179,-796.8353,1559.8621,27.1244,88.3696,0,0,0,0,0,0); // Arabz
    AddPlayerClass(165,-252.7739,2603.1516,62.8582,263.5070,0,0,0,0,0,0); // GERMANY SPAWN 1
    AddPlayerClass(100,-382.1090,2208.1689,42.3969,284.9675,0,0,0,0,0,0); // AFRICA spawn
    AddPlayerClass(122,-1477.8877,2618.1267,58.7813,87.5035,0,0,0,0,0,0); // spawn INDONESIA
    AddPlayerClass(61,-1477.8877,2618.1267,58.7813,87.5035,0,0,0,0,0,0); // spawn INDONESIA

    USA_BASE = GangZoneCreate(-54,1668,426,2136); //a51
    USSR_BASE = GangZoneCreate(-378,960,144,1248); // Middle Desert Town
    ARAB_BASE = GangZoneCreate(-930,1392,-648,1674); //arab
    GERMANY_BASE = GangZoneCreate(-378,2556,-78,2814); // Northern Village
    INDONESIAN_BASE = GangZoneCreate(-1662,2460,-1350,2736); // Korean Town
    AFRICA_BASE = GangZoneCreate(-516,2112,-288,2298); // Ghosts Town
    BRITAN_BASE = GangZoneCreate(-2261.7498,2329.5198,4.8125,197.3704); // Bay Side

	CreateVehicle(522,-231.3270870,2671.1950680,62.3588790,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-232.8657070,2671.2932130,62.3588790,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-234.4156340,2671.2922360,62.3588790,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-236.2406160,2671.2932130,62.3588790,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-237.9906160,2671.2932130,62.3588790,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-239.7158050,2671.2185060,62.3588790,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-177.4187620,1154.8553470,19.5103650,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-176.1042940,1154.9934080,19.5103650,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-174.6547700,1155.0881350,19.5103650,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-173.1548920,1155.0388180,19.5103650,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-171.7546230,1155.1634520,19.5103650,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-170.4796910,1155.1877440,19.5103650,0.0000000,-1,-1,40); //NRG-500
	CreateVehicle(522,-169.2546230,1155.1889650,19.5103650,0.0000000,-1,-1,40); //NRG-500


	CreateVehicle(507,-169.7802000,1193.7305000,19.4832000,272.1584000,53,53,40); //Elegant
	CreateVehicle(507,-151.3201000,1193.4274000,19.4921000,270.2192000,53,53,40); //Elegant
	CreateVehicle(432,-132.8332000,1214.5040000,19.7549000,359.7852000,-1,-1,40); //Rhino
	CreateVehicle(432,-143.8001000,1213.6923000,19.7513000,1.2314000,-1,-1,40); //Rhino
	CreateVehicle(432,-163.7118000,1227.4756000,19.7552000,92.3068000,-1,-1,40); //Rhino
	CreateVehicle(432,-162.9769000,1215.4075000,19.7552000,92.4037000,-1,-1,40); //Rhino
	CreateVehicle(432,-148.0277000,1183.0833000,19.7562000,269.6900000,-1,-1,40); //Rhino
	CreateVehicle(432,-80.7883000,1053.4082000,19.7529000,90.7146000,-1,-1,40); //Rhino
	CreateVehicle(432,-80.8473000,1045.3708000,19.7413000,91.6475000,-1,-1,40); //Rhino
	CreateVehicle(432,-243.6082000,1081.1266000,19.7272000,178.3251000,-1,-1,40); //Rhino
	CreateVehicle(432,-259.8210000,1218.5247000,19.7549000,358.7866000,-1,-1,40); //Rhino
	CreateVehicle(432,-250.5950000,1216.1040000,19.7551000,2.0934000,-1,-1,40); //Rhino
	CreateVehicle(432,-236.8259000,1214.0068000,19.7550000,1.2626000,-1,-1,40); //Rhino
	CreateVehicle(433,-228.7815000,1217.0042000,20.1753000,181.5212000,-1,-1,40); //Barracks
	CreateVehicle(433,-218.9273000,1216.7688000,20.1735000,178.4961000,-1,-1,40); //Barracks
	CreateVehicle(433,-197.2750000,1214.2571000,20.1787000,182.0692000,-1,-1,40); //Barracks
	CreateVehicle(433,-200.4926000,1171.9255000,20.1027000,179.7394000,-1,-1,40); //Barracks
	CreateVehicle(433,-153.7065000,1084.7604000,20.1406000,266.1849000,-1,-1,40); //Barracks
	CreateVehicle(470,-158.6108000,1167.2167000,19.7354000,178.3675000,-1,-1,40); //Patriot
	CreateVehicle(470,-145.2791000,1153.0159000,19.6592000,272.3667000,-1,-1,40); //Patriot
	CreateVehicle(470,-82.8678000,1158.0170000,19.7345000,271.8048000,-1,-1,40); //Patriot
	CreateVehicle(470,-32.2315000,1184.7002000,19.3484000,359.4193000,-1,-1,40); //Patriot
	CreateVehicle(470,-10.5601000,1220.7673000,19.3413000,4.1551000,-1,-1,40); //Patriot
	CreateVehicle(470,-2.0027000,1221.7136000,19.3442000,1.9967000,-1,-1,40); //Patriot
	CreateVehicle(470,5.4184000,1218.5588000,19.3461000,357.7910000,-1,-1,40); //Patriot
	CreateVehicle(470,-80.4464000,1222.3505000,19.7347000,91.6395000,-1,-1,40); //Patriot

	CreateVehicle(402,-305.8307000,1114.7781000,19.5790000,358.0663000,-1,-1,40); //Buffalo
	CreateVehicle(402,-304.1901000,1028.3877000,19.4255000,92.2054000,-1,-1,40); //Buffalo
	CreateVehicle(402,-304.0491000,1023.7325000,19.4255000,90.1839000,-1,-1,40); //Buffalo
	CreateVehicle(402,-304.7504000,1007.6920000,19.4253000,90.9390000,-1,-1,40); //Buffalo
	CreateVehicle(402,-173.3682000,1018.7441000,19.5736000,271.4858000,-1,-1,40); //Buffalo
	CreateVehicle(402,-172.7404000,1013.4344000,19.5738000,269.0490000,-1,-1,40); //Buffalo
	CreateVehicle(402,-77.2107000,1076.8668000,19.5736000,179.3166000,-1,-1,40); //Buffalo
	CreateVehicle(402,-23.2576000,1143.3752000,19.4968000,271.0952000,-1,-1,40); //Buffalo
	CreateVehicle(402,-70.9021000,1185.6937000,19.4937000,4.7178000,-1,-1,40); //Buffalo
	CreateVehicle(548,-131.3202000,993.5706000,22.3230000,273.4375000,-1,-1,40); //Cargobob
	CreateVehicle(520,-132.2480000,1025.1906000,21.3739000,272.3754000,-1,-1,40); //Hydra
	CreateVehicle(425,-169.5678000,988.2139000,21.2705000,89.2718000,-1,-1,40); //Hunter
	CreateVehicle(487,-93.1889000,1027.0336000,19.8679000,260.7979000,-1,-1,40); //Maverick
	CreateVehicle(487,-126.4990000,1050.4193000,20.8552000,87.3708000,-1,-1,40); //Maverick
	CreateVehicle(470,-91.7931000,1157.5265000,19.7338000,273.4672000,-1,-1,40); //Patriot
	CreateVehicle(471,-120.0205000,1141.9608000,19.1744000,173.4989000,-1,-1,40); //Quad
	CreateVehicle(471,-122.9541000,1142.5817000,19.2001000,186.2512000,-1,-1,40); //Quad
	CreateVehicle(471,-126.2311000,1141.1714000,19.2241000,180.4574000,-1,-1,40); //Quad
	CreateVehicle(471,-130.1885000,1141.0081000,19.2220000,178.7012000,-1,-1,40); //Quad
	CreateVehicle(468,-112.3525000,1120.9099000,19.4105000,72.9971000,-1,-1,40); //Sanchez
	CreateVehicle(468,-112.5510000,1117.9872000,19.4110000,81.6557000,-1,-1,40); //Sanchez
	CreateVehicle(468,-112.5225000,1116.2460000,19.4116000,58.3526000,-1,-1,40); //Sanchez
	CreateVehicle(468,-112.6650000,1114.5563000,19.4107000,73.8427000,-1,-1,40); //Sanchez
	CreateVehicle(487,-226.0801000,2716.0386000,67.1165000,268.1381000,54,29,40); //Maverick
	CreateVehicle(487,-344.9044000,2676.9741000,63.8829000,23.0436000,54,29,40); //Maverick
	CreateVehicle(487,-563.5708000,2601.9707000,66.0528000,272.8370000,54,29,40); //Maverick
	CreateVehicle(487,-417.3027000,2191.2710000,42.6609000,9.3595000,54,29,40); //Maverick
	CreateVehicle(487,333.7563000,1961.2158000,17.8156000,95.5012000,54,29,40); //Maverick
	CreateVehicle(487,334.1656000,1924.0676000,17.8218000,79.1497000,54,29,40); //Maverick
	CreateVehicle(487,332.2151000,1867.0376000,17.9470000,89.0947000,54,29,40); //Maverick
	CreateVehicle(522,292.3523000,1878.6427000,17.2000000,56.2868000,-1,-1,40); //NRG-500
	CreateVehicle(522,292.3821000,1883.3024000,17.2067000,52.2745000,-1,-1,40); //NRG-500
	CreateVehicle(578,-1507.3623000,1982.4646000,48.8080000,0.6026000,-1,-1,40); //DFT-30
	CreateVehicle(511,-1484.9375000,1976.6157000,49.1932000,1.9646000,-1,-1,40); //Beagle
	CreateVehicle(578,-296.5619000,2612.9839000,63.9745000,261.1927000,-1,-1,40); //DFT-30


	AddStaticVehicleEx(432,-214.8000000,2732.6999500,62.8000000,0.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(432,-222.3000000,2732.6999500,62.8000000,0.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(432,-229.8000000,2732.3999000,62.8000000,0.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(425,-307.3999900,2679.1001000,66.4000000,0.0000000,95,10,40); //Hunter
	AddStaticVehicleEx(520,-213.0000000,2661.0000000,66.4000000,0.0000000,-1,-1,40); //Hydra
	AddStaticVehicleEx(427,-237.1000100,2596.8000500,63.0000000,0.0000000,-1,-1,40); //Enforcer
	AddStaticVehicleEx(402,-231.8000000,2595.8000500,62.6000000,0.0000000,109,122,40); //Buffalo
	AddStaticVehicleEx(427,-204.6000100,2597.0000000,63.0000000,0.0000000,-1,-1,40); //Enforcer
	AddStaticVehicleEx(415,-219.7000000,2595.8999000,62.6000000,0.0000000,63,62,40); //Cheetah
	AddStaticVehicleEx(415,-210.7000000,2595.6999500,62.6000000,0.0000000,63,62,40); //Cheetah
	AddStaticVehicleEx(447,-249.8000000,2586.0000000,65.0000000,0.0000000,32,32,40); //Seasparrow
	AddStaticVehicleEx(487,-203.6000100,2734.3000500,63.0000000,0.0000000,165,169,40); //Maverick
	AddStaticVehicleEx(487,-287.8999900,2618.6001000,63.4000000,0.0000000,165,169,40); //Maverick
	AddStaticVehicleEx(560,-175.3999900,2708.6001000,62.4000000,0.0000000,45,58,40); //Sultan
	AddStaticVehicleEx(560,-200.8000000,2716.1001000,62.5000000,0.0000000,45,58,40); //Sultan
	AddStaticVehicleEx(490,-284.2999900,2606.8999000,63.2000000,0.0000000,-1,-1,40); //FBI Rancher
	AddStaticVehicleEx(432,-271.0000000,2674.8000500,62.7000000,270.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(425,-751.0999800,1637.3000500,28.0000000,0.0000000,95,10,40); //Hunter
	AddStaticVehicleEx(520,-786.2000100,1437.1999500,14.7000000,90.0000000,-1,-1,40); //Hydra
	AddStaticVehicleEx(520,-814.5999800,1436.0000000,14.7000000,90.0000000,-1,-1,40); //Hydra
	AddStaticVehicleEx(432,-776.7000100,1557.3000500,27.2000000,270.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(487,-797.2999900,1596.5000000,30.0000000,0.0000000,151,149,40); //Maverick
	AddStaticVehicleEx(487,-822.2000100,1558.0999800,30.9000000,0.0000000,151,149,40); //Maverick
	AddStaticVehicleEx(447,-810.0000000,1477.3000500,26.1000000,0.0000000,32,32,40); //Seasparrow
	AddStaticVehicleEx(522,-783.0000000,1517.0999800,26.7000000,0.0000000,37,37,40); //NRG-500
	AddStaticVehicleEx(470,-745.2000100,1577.8000500,27.1000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-745.0999800,1569.3000500,27.1000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-744.2999900,1562.5000000,27.1000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-865.7000100,1544.5999800,23.1000000,90.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-865.7000100,1554.3000500,23.9000000,90.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-865.7999900,1563.1999500,24.6000000,90.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(601,-791.4000200,1567.8000500,27.0000000,0.0000000,245,245,40); //S.W.A.T. Van
	AddStaticVehicleEx(522,-794.2999900,1547.4000200,26.8000000,0.0000000,76,117,40); //NRG-500
	AddStaticVehicleEx(522,-785.9000200,1547.5999800,26.8000000,0.0000000,215,142,40); //NRG-500
	AddStaticVehicleEx(522,-788.2000100,1547.4000200,26.8000000,0.0000000,132,4,40); //NRG-500
	AddStaticVehicleEx(522,-792.5000000,1548.1999500,26.8000000,0.0000000,37,37,40); //NRG-500
	AddStaticVehicleEx(522,-729.2999900,1517.8000500,38.4000000,0.0000000,132,4,40); //NRG-500
	AddStaticVehicleEx(521,-820.5999800,1543.6999500,26.8000000,0.0000000,115,10,40); //FCR-900
	AddStaticVehicleEx(560,-797.7000100,1630.5999800,26.9000000,0.0000000,111,103,40); //Sultan
	AddStaticVehicleEx(487,217.0000000,1929.5999800,23.5000000,0.0000000,165,169,40); //Maverick
	AddStaticVehicleEx(520,308.1000100,2047.5999800,18.6000000,180.0000000,-1,-1,40); //Hydra
	AddStaticVehicleEx(432,280.1000100,2019.0999800,17.7000000,270.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(432,280.3999900,2028.0000000,17.7000000,270.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(425,367.8999900,1982.9000200,21.8000000,0.0000000,95,10,40); //Hunter
	AddStaticVehicleEx(522,213.7000000,1860.1999500,12.8000000,0.0000000,37,37,40); //NRG-500
	AddStaticVehicleEx(522,215.8000000,1860.1999500,12.8000000,0.0000000,215,142,40); //NRG-500
	AddStaticVehicleEx(522,218.2000000,1858.6999500,12.8000000,0.0000000,189,190,40); //NRG-500
	AddStaticVehicleEx(522,220.8000000,1859.1999500,12.8000000,0.0000000,37,37,40); //NRG-500
	AddStaticVehicleEx(522,211.8000000,1860.0999800,12.8000000,0.0000000,215,142,40); //NRG-500
	AddStaticVehicleEx(470,201.7000000,1888.3000500,17.8000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,226.3000000,1886.4000200,17.8000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,254.5000000,1835.0999800,17.8000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,219.7000000,1915.1999500,17.8000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,210.8999900,1914.9000200,17.8000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,202.1000100,1916.0000000,17.8000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(522,186.7000000,1928.5000000,17.4000000,0.0000000,189,190,40); //NRG-500
	AddStaticVehicleEx(470,277.8999900,1983.3000500,17.8000000,270.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,279.2000100,1992.0999800,17.8000000,270.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,308.2999900,1929.1999500,17.8000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(476,279.1000100,1955.6999500,18.8000000,270.0000000,167,162,40); //Rustler
	AddStaticVehicleEx(497,-423.6000100,2206.8999000,42.7000000,0.0000000,-1,-1,40); //Police Maverick
	AddStaticVehicleEx(461,-371.2000100,2229.1001000,42.2000000,90.0000000,14,49,40); //PCJ-600
	AddStaticVehicleEx(461,-371.3999900,2226.8999000,42.2000000,90.0000000,14,49,40); //PCJ-600
	AddStaticVehicleEx(461,-370.6000100,2224.8999000,42.2000000,90.0000000,14,49,40); //PCJ-600
	AddStaticVehicleEx(461,-370.6000100,2223.1001000,42.2000000,90.0000000,14,49,40); //PCJ-600
	AddStaticVehicleEx(461,-370.2999900,2221.5000000,42.2000000,90.0000000,14,49,40); //PCJ-600
	AddStaticVehicleEx(461,-369.6000100,2219.3000500,42.2000000,90.0000000,14,49,40); //PCJ-600
	AddStaticVehicleEx(535,-393.7000100,2193.1001000,42.3000000,0.0000000,61,74,40); //Slamvan
	AddStaticVehicleEx(535,-389.2000100,2193.6001000,42.3000000,0.0000000,61,74,40); //Slamvan
	AddStaticVehicleEx(535,-386.6000100,2193.6999500,42.3000000,0.0000000,61,74,40); //Slamvan
	AddStaticVehicleEx(470,-395.6000100,2238.1999500,42.5000000,290.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-394.6000100,2234.0000000,42.5000000,289.9950000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-391.5000000,2221.6999500,42.5000000,289.9950000,95,10,40); //Patriot
	AddStaticVehicleEx(497,-348.7000100,2211.3999000,42.7000000,0.0000000,-1,-1,40); //Police Maverick
	AddStaticVehicleEx(432,-1525.5999800,2531.6001000,55.8000000,0.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(432,-1505.8000500,2530.0000000,55.8000000,0.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(470,-1534.0999800,2627.8000500,55.9000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-1529.3000500,2629.1001000,55.9000000,0.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-1534.6999500,2648.5000000,55.9000000,190.0000000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-1529.8000500,2642.3000500,55.9000000,189.9980000,95,10,40); //Patriot
	AddStaticVehicleEx(470,-1523.8000500,2642.8999000,55.9000000,189.9980000,95,10,40); //Patriot
	AddStaticVehicleEx(489,-1401.9000200,2630.8000500,56.1000000,90.0000000,214,218,40); //Rancher
	AddStaticVehicleEx(489,-1402.5000000,2641.0000000,56.0000000,90.0000000,214,218,40); //Rancher
	AddStaticVehicleEx(489,-1402.3000500,2653.5000000,56.0000000,90.0000000,214,218,40); //Rancher
	AddStaticVehicleEx(489,-1437.8000500,2650.8000500,56.2000000,90.0000000,214,218,40); //Rancher
	AddStaticVehicleEx(487,-1530.1999500,2584.3000500,60.9000000,0.0000000,165,169,40); //Maverick
	AddStaticVehicleEx(487,-1511.9000200,2585.8000500,61.3000000,0.0000000,165,169,40); //Maverick
	AddStaticVehicleEx(447,-1520.5000000,2619.6001000,59.8000000,0.0000000,32,32,40); //Seasparrow
	AddStaticVehicleEx(411,-1451.5000000,2656.3999000,55.6000000,0.0000000,32,32,40); //Infernus
	AddStaticVehicleEx(411,-1455.4000200,2657.0000000,55.6000000,0.0000000,32,32,40); //Infernus
	AddStaticVehicleEx(516,-1500.4000200,2527.8000500,55.6000000,0.0000000,94,112,40); //Nebula
	AddStaticVehicleEx(432,-1514.9000200,2531.6001000,55.8000000,0.0000000,95,10,40); //Rhino
	AddStaticVehicleEx(520,-1449.9000200,2508.5000000,61.6000000,0.0000000,-1,-1,40); //Hydra
	AddStaticVehicleEx(425,-1449.9000200,2541.6001000,59.6000000,0.0000000,95,10,40); //Hunter
	CreateObject(3279,-160.0000000,2615.8999000,60.7000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (1)
	CreateObject(3279,-153.6000100,2654.8000500,63.6000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (2)
	CreateObject(3279,-364.0000000,2703.8999000,62.8000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (3)
	CreateObject(3279,-223.8000000,2691.8999000,61.7000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (4)
	CreateObject(9241,-214.2000000,2661.3000500,63.7000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (1)
	CreateObject(9241,-307.5996100,2678.0000000,63.7000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (3)
	CreateObject(3279,-861.4000200,1579.4000200,24.9000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (5)
	CreateObject(3279,-849.4000200,1628.8000500,26.3000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (7)
	CreateObject(3279,-864.0000000,1430.4000200,13.1000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (8)
	CreateObject(8251,307.5000000,2054.3999000,20.6000000,0.0000000,0.0000000,270.0000000); //object(pltschlhnger02_lvs) (1)
	CreateObject(4874,369.7999900,1966.1999500,20.5000000,0.0000000,0.0000000,270.0000000); //object(helipad1_las) (2)
	CreateObject(9241,-1449.5000000,2541.1999500,56.9000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (3)
	CreateObject(9241,-1450.0000000,2507.3999000,58.9000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (3)
	CreateObject(5816,284.8999900,1855.9000200,25.8000000,0.0000000,0.0000000,90.0000000); //object(odrampbit) (1)
	CreateObject(3279,-160.0000000,2615.8999000,60.7000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (1)
	CreateObject(3279,-153.6000100,2654.8000500,63.6000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (2)
	CreateObject(3279,-364.0000000,2703.8999000,62.8000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (3)
	CreateObject(3279,-223.8000000,2691.8999000,61.7000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (4)
	CreateObject(9241,-214.2000000,2661.3000500,63.7000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (1)
	CreateObject(9241,-307.5996100,2678.0000000,63.7000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (3)
	CreateObject(3279,-861.4000200,1579.4000200,24.9000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (5)
	CreateObject(3279,-849.4000200,1628.8000500,26.3000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (7)
	CreateObject(3279,-864.0000000,1430.4000200,13.1000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (8)
	CreateObject(8251,307.5000000,2054.3999000,20.6000000,0.0000000,0.0000000,270.0000000); //object(pltschlhnger02_lvs) (1)
	CreateObject(4874,369.7999900,1966.1999500,20.5000000,0.0000000,0.0000000,270.0000000); //object(helipad1_las) (2)
	CreateObject(9241,-1449.5000000,2541.1999500,56.9000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (3)
	CreateObject(9241,-1450.0000000,2507.3999000,58.9000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (3)
	CreateObject(5816,284.8999900,1855.9000200,25.8000000,0.0000000,0.0000000,90.0000000); //object(odrampbit) (1)

	AddStaticVehicle(489,-2271.3418,2285.5806,4.9639,90.0718,214,218); // Rancher
	AddStaticVehicle(489,-2271.7363,2288.5808,4.9633,90.6168,214,218); // Rancher
	AddStaticVehicle(489,-2270.1934,2294.5193,4.9644,89.8030,214,218); // Rancher
	AddStaticVehicle(430,-2314.0891,2332.2253,-0.4130,179.9853,46,26); // Hunter
	AddStaticVehicle(520,-2226.9238,2301.8813,8.2393,177.3461,0,0); // Hydra
	AddStaticVehicle(432,-2257.9136,2287.0730,4.8291,358.2672,43,0); // Rhino
	AddStaticVehicle(432,-2264.3792,2286.7136,4.8315,359.4264,43,0); // Rhino
	AddStaticVehicle(578,-2253.3718,2323.9487,5.4381,91.5261,1,1); // DFT-30
	AddStaticVehicle(578,-2253.2024,2333.0400,5.4379,90.3086,1,1); // DFT-30
	AddStaticVehicle(446,-2247.8862,2413.2009,-0.7416,316.0262,1,5); // Squalo
	AddStaticVehicle(446,-2226.0066,2434.9351,-0.4924,316.1526,1,5); // Squalo
	AddStaticVehicle(446,-2237.4885,2406.5830,-0.4258,317.7842,1,5); // Squalo
	AddStaticVehicle(446,-2219.3774,2427.0647,-0.4745,318.5283,1,5); // Squalo
	CreateObject(12990, -2318.971923, 2327.387207, 0.552300, 0.000000, 0.000000, 0.000000, 300.00);
	CreateObject(12990, -2318.971923, 2303.018554, 0.752299, 0.000000, 0.000000, 0.000000, 300.00);
	CreateObject(1472, -2320.716796, 2335.944824, 1.291509, 0.000000, 0.000000, 0.000000, 300.00);
	CreateObject(1472, -2319.206542, 2335.944824, 1.291509, 0.000000, 0.000000, 0.000000, 300.00);
	CreateObject(1472, -2317.806152, 2335.944824, 1.291509, 0.000000, 0.000000, 0.000000, 300.00);
	CreateObject(1472, -2317.806152, 2337.065917, 1.931509, 0.000000, 0.000000, 0.000000, 300.00);
	CreateObject(1472, -2319.306396, 2337.065917, 1.931509, 0.000000, 0.000000, 0.000000, 300.00);
	CreateObject(1472, -2320.807617, 2337.065917, 1.931509, 0.000000, 0.000000, 0.000000, 300.00);

    // briefcases
    BF1 = CreatePickup(1210, 2, 229.94, 1929.07, 17.64);
    BF2 = CreatePickup(1210,2,-252.4021,2603.1230,62.8582, -1);
    BF3 = CreatePickup(1210, 2, -365.27, 2220.66, 42.49);
    BF4 = CreatePickup(1210, 2, -814.32, 1567.55, 26.96);
    BF5 = CreatePickup(1210, 2, -1507.04, 2609.88, 55.83);
    BF6 = CreatePickup(1210, 2, -2279.75, 2289.33, 4.96);
    BF7 = CreatePickup(1210, 2, -146.11, 1131.19, 19.74);


    // Gangzones
    //Zone 1
    CP[Zone1] = CreateDynamicCP(379.3820,2536.7795,16.5391,5,0,0,-1,25);
    Zone[Zone1] = GangZoneCreate(78,2412,462,2628); // DA

    CP[Zone2] = CreateDynamicCP(-551.0111,2594.2004,53.9348,5,0,0,-1,25);
    Zone[Zone2] = GangZoneCreate(-672,2472,-462,2670); // Army Restuarent

    CP[Zone3] = CreateDynamicCP(-34.5398,2350.1331,24.3026,5,0,0,-1,25);
    Zone[Zone3] = GangZoneCreate(-96,2280,48,2406); // Snake Farms

    CP[Zone4] = CreateDynamicCP(262.8434,2897.5767,9.5997,5,0,0,-1,25);
    Zone[Zone4] = GangZoneCreate(186,2832,330,2988); // Northern Beach

    CP[Zone5] = CreateDynamicCP(-909.5822,2690.5254,42.3703,5,0,0,-1,25);
    Zone[Zone5] = GangZoneCreate(-966,2664,-666,2796); // Rusty Bridge

    CP[Zone6] = CreateDynamicCP(633.7563,1688.3315,6.9922,5,0,0,-1,25);
    Zone[Zone6] = GangZoneCreate(462,1584,708,1788); // Gas Station

    CP[Zone7] = CreateDynamicCP(-348.0113,1565.5128,75.7663,5,0,0,-1,25);
    Zone[Zone7] = GangZoneCreate(-432,1458,-210,1680); // Radar Station

    CP[Zone8] = CreateDynamicCP(-1194.1002,1815.9631,41.8145,5,0,0,-1,25);
    Zone[Zone8] = GangZoneCreate(-1290,1716,-1050,1884); // Clukin's Restuarent

    CP[Zone9] = CreateDynamicCP(-1471.4646,1864.6365,32.6328,5,0,0,-1,25);
    Zone[Zone9] = GangZoneCreate(-1536,1770,-1362,1914); // Gas Station 2

    CP[Zone10] = CreateDynamicCP(-2261.7498,2329.5198,4.8125,5,0,0,-1,25);
    Zone[Zone10] = GangZoneCreate(-2261.7498,2329.5198,4.8125,197.3704); // Bay Side Marina

    for(new x=0; x < sizeof(UnderAttack); x++) UnderAttack[x] = 0;
    for(new x=0; x < sizeof(Captured); x++) Captured[x] = 0;
    for(new x=0; x < sizeof(tCP); x++) tCP[x] = TEAM_NONE;
	ServerLocked = false;
	return 1;
}

public OnGameModeExit()
{
	ServerLocked = false;
	return 1;
}

public OnPlayerConnect(playerid)
{
	PlayerCheckGM{playerid} ++;
	SetTimerEx("PlayerCheck", 1000, false, "ii", playerid, PlayerCheckGM{playerid});

	FirstSpawn[playerid] = 1;

	GangZoneShowForPlayer(playerid, USA_BASE, COLOR_LIGHTERBLUE);
    GangZoneShowForPlayer(playerid, USSR_BASE, COLOR_RED);
    GangZoneShowForPlayer(playerid, ARAB_BASE, COLOR_ORANGELIGHT);
    GangZoneShowForPlayer(playerid, GERMANY_BASE, COLOR_GREENLIGHT);
    GangZoneShowForPlayer(playerid, INDONESIAN_BASE, COLOR_YELLOW);
    GangZoneShowForPlayer(playerid, AFRICA_BASE, COLOR_BROWNLIGHT);
	GangZoneShowForPlayer(playerid, BRITAN_BASE, COLOR_WHITE);

    SetPlayerMapIcon(playerid, 5, -36.5458, 2347.6426, 24.1406, 19,2,MAPICON_GLOBAL); //snake farms
    SetPlayerMapIcon(playerid, 6, -1194.1002,1815.9631,41.8145, 19,2,MAPICON_GLOBAL); // cluck'in
    SetPlayerMapIcon(playerid, 7, -1471.4646,1864.6365,32.6328, 19,2,MAPICON_GLOBAL); // 2nd gas station
    SetPlayerMapIcon(playerid, 8, 379.3820,2536.7795,16.5391, 19,2,MAPICON_GLOBAL); // DA
    SetPlayerMapIcon(playerid, 9, -909.5822,2690.5254,42.3703, 19,2,MAPICON_GLOBAL); // Rusty Bridge
    SetPlayerMapIcon(playerid, 10, 262.8434,2897.5767,9.5997, 19,2,MAPICON_GLOBAL); // Northern Beach
    SetPlayerMapIcon(playerid, 11, -551.0111,2594.2004,53.9348, 19,2,MAPICON_GLOBAL); // Army Res
    SetPlayerMapIcon(playerid, 12, 633.7563,1688.3315,6.9922, 19,2,MAPICON_GLOBAL); // cluck'in
    SetPlayerMapIcon(playerid, 13, -348.0113,1565.5128,75.7663, 19,2,MAPICON_GLOBAL); // cluck'in
    SetPlayerMapIcon(playerid, 13, -2261.7498,2329.5198,4.8125, 19,2,MAPICON_GLOBAL); // cluck'in

    InCP[playerid] = -1;
    for(new x=0; x < sizeof(tCP); x++)
    {
		switch(x)
		{
		    case TEAM_NONE: GangZoneShowForAll(Zone[x], COLOR_WHITE);
		    case TEAM_USA: GangZoneShowForPlayer(playerid, Zone[x], COLOR_LIGHTERBLUE);
		    case TEAM_USSR: GangZoneShowForPlayer(playerid, Zone[x], COLOR_RED);
		    case TEAM_ARAB: GangZoneShowForPlayer(playerid, Zone[x], COLOR_ORANGELIGHT);
		    case TEAM_GERMANY: GangZoneShowForPlayer(playerid, Zone[x], COLOR_GREENLIGHT);
		    case TEAM_AFRICA: GangZoneShowForPlayer(playerid, Zone[x], COLOR_BROWNLIGHT);
		    case TEAM_INDONESIA: GangZoneShowForPlayer(playerid, Zone[x], COLOR_YELLOW);
		    case TEAM_BRITAN: GangZoneShowForPlayer(playerid, Zone[x], COLOR_WHITE);
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	for(new x=0; x < sizeof(UnderAttack); x++)
    {
        if(InCP[playerid] == x) UnderAttack[x] = 0;
    }
	SaveSurvivorsData(playerid);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_PASSENGER || newstate == PLAYER_STATE_DRIVER) SetPlayerArmedWeapon(playerid, 0);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
       return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_REGISTER)
	{
	    if(!response)
	        return Kick(playerid);

		new str[256];
	    format(str, sizeof(str), "UCP Name: %s\nAttempts: %d/3\nPassword: ", GetName(playerid), WorldWar5CountryData[playerid][pAttempt]);

        if(strlen(inputtext) < 7)
			return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "World War 5 Country", str, "Register", "Exit");

        if(strlen(inputtext) > 32)
			return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "World War 5 Country", str, "Register", "Exit");

        bcrypt_hash(playerid, "HashPlayerPassword", inputtext, BCOST);
	}
	if(dialogid == DIALOG_LOGIN)
	{
	    if(!response)
	        return Kick(playerid);
	        
        if(strlen(inputtext) < 1)
        {
			new str[256];
            format(str, sizeof(str), "UCP Name: %s\nAttempts: %d/3\nPassword: ", GetName(playerid), WorldWar5CountryData[playerid][pAttempt]);
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "World War 5 Country", str, "Login", "Exit");
            return 1;
		}
		new pwQuery[256], hash[ACCOUNTS_WW5C];
		mysql_format(sqlww5c, pwQuery, sizeof(pwQuery), "SELECT Password FROM UCPSystem WHERE UCP = '%e' LIMIT 1", GetName(playerid));
		mysql_query(sqlww5c, pwQuery);
		
        cache_get_value_name(0, "Password", hash, sizeof(hash));
        
        bcrypt_verify(playerid, "OnPlayerPasswordChecked", inputtext, hash);

	}
    if(dialogid == DIALOG_CHARLIST)
    {
		if(response)
		{
			if (SurvivorsChar[playerid][listitem][0] == EOS)
				return ShowPlayerDialog(playerid, DIALOG_MAKECHAR, DIALOG_STYLE_INPUT, "Create Character", "Inpu Your Name Character", "Create", "Exit");

			WorldWar5CountryData[playerid][pChar] = listitem;
			SetPlayerName(playerid, SurvivorsChar[playerid][listitem]);

			new cQuery[256];
			mysql_format(sqlww5c, cQuery, sizeof(cQuery), "SELECT * FROM `survivors` WHERE `Name` = '%s' LIMIT 1;", SurvivorsChar[playerid][WorldWar5CountryData[playerid][pChar]]);
			mysql_tquery(sqlww5c, cQuery, "LoadCharacterData", "d", playerid);
			
		}
	}
	switch(dialogid)
	{
	    case DIALOG_RANKS:
	    {
	        if(response)
			{
				if(listitem == 0)
				{
	        		SendClientMessage(playerid, 0xFFFFFFFF, "Information about Private");
	        		SendClientMessage(playerid, 0xFFFFFFFF, "For this rank you need at least 0 score.");
				}
				if(listitem == 1)
				{
	        		SendClientMessage(playerid, 0xFFFFFFFF, "Information about Coparal:");
	        		SendClientMessage(playerid, 0xFFFFFFFF, "For this rank you need at least 50 score.");

				}
				if(listitem == 2)
				{
	        		SendClientMessage(playerid, 0xFFFFFFFF, "Information about Officer rank:");
	        		SendClientMessage(playerid, 0xFFFFFFFF, "For this rank you need at least 150 score.");
				}
				if(listitem == 3)
				{
	        		SendClientMessage(playerid, 0xFFFFFFFF, "Information about Lieutenant rank:");
	        		SendClientMessage(playerid, 0xFFFFFFFF, "For this rank you need at least 300 score.");
				}
				if(listitem == 4)
				{
	        		SendClientMessage(playerid, 0xFFFFFFFF, "Information about Colonel rank:");
	        		SendClientMessage(playerid, 0xFFFFFFFF, "For this rank you need at least 650 score.");
				}
				if(listitem == 5)
				{
	        		SendClientMessage(playerid, 0xFFFFFFFF, "Information about rank of Lieutenant Colonel:");
	        		SendClientMessage(playerid, 0xFFFFFFFF, "For this rank you need at least 2500 score.");
				}
				if(listitem == 6)
				{
	        		SendClientMessage(playerid, 0xFFFFFFFF, "Information about General rank:");
	        		SendClientMessage(playerid, 0xFFFFFFFF, "For this rank you need at least 7000 score.");
				}
				if(listitem == 7)
				{
	        		SendClientMessage(playerid, 0xFFFFFFFF, "Information about Legend rank:");
	        		SendClientMessage(playerid, 0xFFFFFFFF, "For this rank you need at least 29900 score.");
				}
			}
	    }
	    case 999:
	    {
     		if(response)
      		{
      		    switch(listitem)
      		    {
       			    case 0:
       			    {
                    	if(GetPlayerScore(playerid) >= 0)
                        {
	                        SendClientMessage(playerid, COLOR_WHITE, "You chose the Assualt as your class.");
	                        ShowPlayerDialog(playerid, 11, DIALOG_STYLE_MSGBOX, "{6EF83C}Assualt Class:", "{F81414}Abilities:\n{FFFFFF}A Solo class, good in infantry attacks.\n\n{F81414}Weapons:\n\n{FFFFFF}M4\n{FFFFFF}Shotgun\n{FFFFFF}Deagle", "Play","");
	                        gPlayerClass[playerid] = ASSAULT;//
	                        PickedClass[playerid] = 1;
	                        SetPlayerVirtualWorld(playerid, 0);
	                        TogglePlayerControllable(playerid, 1);
	                        ResetPlayerWeapons(playerid);
	                        GivePlayerWeapon(playerid, 31, 200);//m4
	                        GivePlayerWeapon(playerid, 29, 100);//mp5
	                        GivePlayerWeapon(playerid, 27, 100);//  combat
	                        GivePlayerWeapon(playerid, 24, 70);//deagle
                        }
                    }
					case 1:
                    {
                    	if(GetPlayerScore(playerid) >= 0)
                        {
	                        SendClientMessage(playerid, COLOR_WHITE, "You chose the Sniper as your class.");
	                        ShowPlayerDialog(playerid, 11, DIALOG_STYLE_MSGBOX, "{6EF83C}Sniper Class:", "{F81414}Abilities:\n{FFFFFF}A Locater class, Always invisible on map.\n\n{F81414}Weapons:\n\n{FFFFFF}Sniper Rifle\n{FFFFFF}Mp5\n{FFFFFF}Knife", "Play","");
	                        gPlayerClass[playerid] = SNIPER;
	                        PickedClass[playerid] = 2;
	                        RemovePlayerMapIcon(playerid, 0);
	                        SetPlayerVirtualWorld(playerid, 0);
	                        TogglePlayerControllable(playerid, 1);
	                        ResetPlayerWeapons(playerid);
	                        GivePlayerWeapon(playerid, 34, 250);//sniper
	                        GivePlayerWeapon(playerid, 29, 250);//mp5
	                        GivePlayerWeapon(playerid, 4, 1);//knife
                        }
                    }

                	case 2:
                    {
                    	if(GetPlayerScore(playerid) >= 0)
                        {
	                        SendClientMessage(playerid, COLOR_WHITE, "You chose the Medic as your class.");
	                        ShowPlayerDialog(playerid, 11, DIALOG_STYLE_MSGBOX, "{6EF83C}Medic Class:", "{F81414}Abilities:\n{FFFFFF}A Support class , can use /heal \n\n{F81414}Weapons:\n\n{FFFFFF}Spas12\n{FFFFFF}Silent Pistol\n{FFFFFF}RPG\n{FFFFFF}Grenade", "Play","");
	                        gPlayerClass[playerid] = MEDIC;
	                        PickedClass[playerid] = 3;
	                        SetPlayerVirtualWorld(playerid, 0);
	                        TogglePlayerControllable(playerid, 1);
	                        ResetPlayerWeapons(playerid);
	                        GivePlayerWeapon(playerid, 33, 200);
	                        GivePlayerWeapon(playerid, 22, 200);
	                        GivePlayerWeapon(playerid, 25, 200);
	                        GivePlayerWeapon(playerid, 11, 2);
                        }
					}
                }
			}
		}
		case 2:
		{
		    if(response)
		    {
	  			switch(listitem)
	        	{
	        	    case 0:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 5000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	                    GivePlayerMoney(playerid, -5000);
	                    ShowDialog(playerid);
						SetPlayerHealth(playerid, 100.0);
						SendClientMessage(playerid, COLOR_WHITE, "You bought Health for $5000");
					}
	        	    case 1:
	        	    {
	                    if(GetPlayerMoney(playerid) < 5500) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	                    ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -5500);
	        	        ShowDialog(playerid);
	        	        SetPlayerArmour(playerid, 100.0);
                  		SendClientMessage(playerid, COLOR_WHITE, "You bought Armour for $5500");
	        	    }
	        	    case 2:
	        	    {
	        	        ShowPlayerDialog(playerid, 30, DIALOG_STYLE_LIST, "Weapons", "M4 - 8000$\nAK47 - 8000$\nMP5 - 6000$\nUZI - 12000$\nCombat Shotgun - 10000$\nShotgun - 5000$\nDesert Eagle - 6000$\nSilent Pistol - 3000$\nPistol - 3000$\nTec 9 - 3000$\nSawn-Off Shotgun - 8000$\nRPG - 10000$", "Buy", "Exit");
	 	 			}
	 			}
	    	}
    	}
    	case 30:
    	{
    	    if(response)
    	    {
	    	    switch(listitem)
	        	{
	        	    case 0:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 8000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -8000);
	        	        GivePlayerWeapon(playerid, 31, 300);
	        	        ShowDialog(playerid);
						SendClientMessage(playerid,COLOR_WHITE, "You bought M4 with 300 Ammo.");
	        	    }
	        	    case 1:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 8000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -8000);
	        	        ShowDialog(playerid);
	        	        GivePlayerWeapon(playerid, 30, 300);
						SendClientMessage(playerid, COLOR_WHITE, "You bought AK 47 with 300 Ammo.");
	        	    }
	        	    case 2:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 6000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	                 	ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -6000);
	        	        GivePlayerWeapon(playerid, 29, 300);
						SendClientMessage(playerid, COLOR_WHITE, "You bought MP5 with 300 Ammo.");
	        	    }
	        	    case 3:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 12000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -12000);
	        	        ShowDialog(playerid);
	        	        GivePlayerWeapon(playerid, 28, 500);
						SendClientMessage(playerid, COLOR_WHITE, "You bought UZI with 300 Ammo.");
	        	    }
	        	    case 4:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 10000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -10000);
	        	        ShowDialog(playerid);
	        	        GivePlayerWeapon(playerid, 27, 300);
						SendClientMessage(playerid, COLOR_WHITE, "You bought SPAZ12 with 300 Ammo.");
	        	    }
	        	    case 5:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 5000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -5000);
	        	        ShowDialog(playerid);
	        	        GivePlayerWeapon(playerid, 25, 300);
						SendClientMessage(playerid, COLOR_WHITE, "You bought Shotgun with 300 Ammo.");
	        	    }
	        	    case 6:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 6000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -6000);
	        	        ShowDialog(playerid);
	        	        GivePlayerWeapon(playerid, 24, 100);
						SendClientMessage(playerid, COLOR_WHITE, "You bought Desert Eagle with 100 Ammo.");
	        	    }
	        	    case 7:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 3000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -3000);
	        	        ShowDialog(playerid);
	        	        GivePlayerWeapon(playerid, 23, 300);
						SendClientMessage(playerid, COLOR_WHITE, "You bought Silencer with 300 Ammo.");
	        	    }
	        	    case 8:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 3000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -3000);
	        	        ShowDialog(playerid);
	        	        GivePlayerWeapon(playerid, 22, 300);
						SendClientMessage(playerid, COLOR_WHITE, "You bought Pistol with 300 Ammo.");
      				}
          			case 9:
       	     		{
						SendClientMessage(playerid, COLOR_WHITE, " This Weapon Removed by Admin");
	        	    }
	        	    case 10:
        	     	{
						SendClientMessage(playerid, COLOR_WHITE, " This Weapon Removed.");
	        	    }
	        	    case 11:
	        	    {
	                 	if(GetPlayerMoney(playerid) < 25000) return SendClientMessage(playerid, 0xFF0000AA, "ERROR: You don't have enough cash.") && ShowDialog(playerid);
	        	        GivePlayerMoney(playerid, -10000);
	        	        ShowDialog(playerid);
	        	        GivePlayerWeapon(playerid, 35, 1);
						SendClientMessage(playerid, COLOR_WHITE, "You bought RPG with 1 Ammo.");
					}
	        	}
			}
    	}
  	}
	if(dialogid == DIALOG_MAKECHAR)
	{
	    if(response)
	    {
		    if(strlen(inputtext) < 1 || strlen(inputtext) > 24)
				return ShowPlayerDialog(playerid, DIALOG_MAKECHAR, DIALOG_STYLE_INPUT, "Create Character", "Input Your Name Character", "Create", "Back");

			new characterQuery[178];
			mysql_format(sqlww5c, characterQuery, sizeof(characterQuery), "SELECT * FROM `survivors` WHERE `Name` = '%s'", inputtext);
			mysql_tquery(sqlww5c, characterQuery, "InsertPlayerName", "ds", playerid, inputtext);

		    format(WorldWar5CountryData[playerid][pUCP], 22, GetName(playerid));
		}
	}
	if(dialogid == DIALOG_AGE)
	{
		if(response)
		{
			if(strval(inputtext) >= 60)
			    return ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Character Age", "ERROR:Must not be more than 60 years old!", "Continue", "Batal");

			if(strval(inputtext) < 15)
			    return ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Character Age", "ERROR:Cannot be under 15 years old!", "Continue", "Batal");

			WorldWar5CountryData[playerid][pAge] = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_ORIGIN, DIALOG_STYLE_INPUT, "Character Origin", "Please enter your Character Origin(United States of America,Great Britan,Indonesia,Soviet Union,Saudi Arabia,Germany):", "Continue", "Quit");
		}
		else
		{
		    ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Character Age", "Please Insert your Character Age", "Continue", "Batal");
		}
	}
	if(dialogid == DIALOG_ORIGIN)
	{
	    if(!response)
	        return ShowPlayerDialog(playerid, DIALOG_ORIGIN, DIALOG_STYLE_INPUT, "Character Origin", "Please enter your Character Origin(United States of America,Great Britan,Indonesia,Soviet Union,Saudi Arabia,Germany):", "Continue", "Quit");

		if(strlen(inputtext) < 1)
		    return ShowPlayerDialog(playerid, DIALOG_ORIGIN, DIALOG_STYLE_INPUT, "Character Origin", "Please enter your Character Origin(United States of America,Great Britan,Indonesia,Soviet Union,Saudi Arabia,Germany):", "Continue", "Quit");

        format(WorldWar5CountryData[playerid][pOrigin], 32, inputtext);
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
  // sea sparrow rank
    new Sparrow = GetVehicleModel(GetPlayerVehicleID(playerid));
	if(PickedClass[playerid] >= 1 && GetPlayerScore(playerid) <= 300) {
    if(Sparrow == 447) {
    Slap(playerid);
    SendClientMessage(playerid,COLOR_RED,"ERROR:You must be Major + Assault class to Drive this vehicle.");
    }
	}
	// rhino rank
	new Tank = GetVehicleModel(GetPlayerVehicleID(playerid));
	if(PickedClass[playerid] >= 1 && GetPlayerScore(playerid) <= 750) {
	if(Tank == 432) {
	Slap(playerid);
	SendClientMessage(playerid,COLOR_RED,"ERROR:You must be Colonel + Assault class to Drive this vehicle.");
 	}
	}
	// hydra rank
	new Hydra = GetVehicleModel(GetPlayerVehicleID(playerid));
	if(PickedClass[playerid] >= 1 && GetPlayerScore(playerid) <= 1500) {
	if(Hydra == 520) {
	Slap(playerid);
	SendClientMessage(playerid,COLOR_RED,"ERROR:You must be General + Assault class to Drive this vehicle.");
	}
	}
	// hunter rank
 	new Hunter = GetVehicleModel(GetPlayerVehicleID(playerid));
    if(PickedClass[playerid] >= 1 && GetPlayerScore(playerid) <= 1500) {
    if(Hunter == 425) {
    Slap(playerid);
    SendClientMessage(playerid,COLOR_RED,"ERROR: You must be General + Assault class to Drive this vehicle.");
    }
	}
	return 1;
}

stock ShowDialog(playerid)
{
	ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Tas", "Health - $50,00\nArmour - $55,00\n\nWeapons", "Select", "Cancel");
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    for(new x=0; x < sizeof(CP); x++)
    {
        if(checkpointid == CP[x])
        {
            if(UnderAttack[x] == 1)
         	{
             	SendClientMessage(playerid, 0xFF0000FF,"This zone has been captured!");
         	}
         	else if(gTeam[playerid] == tCP[x])
         	{
             	SendClientMessage(playerid, 0xFF0000FF,"This zone has been captured by your team!");
         	}
         	else if(gTeam[playerid] == TEAM_NONE)
         	{
             	SendClientMessage(playerid, 0xFF0000FF,"You don't have a team so you can't catch!");
         	}
         	else
         	{
	            UnderAttack[x] = 1;
				timer[playerid][x] = SetTimerEx("SetCaptureZone", 60000, false,"i",playerid);
	            CountTime[playerid] = SetTimerEx("CountDown", 1, false,"i", playerid);
	            InCP[playerid] = x;
	            Captured[Zone1] = 0;
	            switch(gTeam[playerid])
	            {
	                case TEAM_USA: GangZoneFlashForAll(Zone[x], COLOR_LIGHTERBLUE);
	                case TEAM_USSR: GangZoneFlashForAll(Zone[x], COLOR_RED);
	                case TEAM_ARAB: GangZoneFlashForAll(Zone[x], COLOR_ORANGELIGHT);
	                case TEAM_GERMANY: GangZoneFlashForAll(Zone[x], COLOR_GREENLIGHT);
	                case TEAM_AFRICA: GangZoneFlashForAll(Zone[x], COLOR_BROWNLIGHT);
	                case TEAM_INDONESIA: GangZoneFlashForAll(Zone[x], COLOR_YELLOW);
                    case TEAM_BRITAN: GangZoneFlashForAll(Zone[x], COLOR_WHITE);
	            }
            	SendClientMessage(playerid, COLOR_YELLOW,"Wait 60 seconds to capture this zone");
         	}
		}
	}
 	return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
    for(new x=0; x < sizeof(CP); x++)
    {
        if(checkpointid == CP[x])
        {
            if(Captured[x] == 1)
            {
                GangZoneStopFlashForAll(Zone[x]);
	            UnderAttack[x] = 0;
	            InCP[playerid] = 0;
	            tCP[x] = gTeam[playerid];
	            switch(gTeam[playerid])
	            {
	                case TEAM_USA: GangZoneShowForAll(Zone[x], COLOR_LIGHTERBLUE);
	                case TEAM_USSR: GangZoneShowForAll(Zone[x], COLOR_RED);
	                case TEAM_ARAB: GangZoneShowForAll(Zone[x], COLOR_ORANGELIGHT);
	                case TEAM_GERMANY: GangZoneShowForAll(Zone[x], COLOR_GREENLIGHT);
	                case TEAM_AFRICA: GangZoneShowForAll(Zone[x], COLOR_BROWNLIGHT);
	                case TEAM_INDONESIA: GangZoneShowForAll(Zone[x], COLOR_YELLOW);
					case TEAM_BRITAN: GangZoneShowForAll(Zone[x], COLOR_WHITE);
	            }
			}
		}
	}
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == BF1) ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Bag", "Health - $50,00\nArmour - $55,00\n\nWeapons", "Select", "Cancel");
	{
    if(pickupid == BF2) ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Bag", "Health - $50,00\nArmour - $55,00\n\nWeapons", "Select", "Cancel");
    }
    if(pickupid == BF3) ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Bag", "Health - $50,00\nArmour - $55,00\n\nWeapons", "Select", "Cancel");
	{
    if(pickupid == BF4) ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Bag", "Health - $50,00\nArmour - $55,00\n\nWeapons", "Select", "Cancel");
    }
    if(pickupid == BF5) ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Bag", "Health - $50,00\nArmour - $55,00\n\nWeapons", "Select", "Cancel");
	{
    if(pickupid == BF6) ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Bag", "Health - $50,00\nArmour - $55,00\n\nWeapons", "Select", "Cancel");
	}
    if(pickupid == BF7) ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Bag", "Health - $50,00\nArmour - $55,00\n\nWeapons", "Select", "Cancel");
	{

	 }
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SendClientMessage(playerid, COLOR_RED,"You have Anti-Spawn Kill Protection for 10 seconds");
    switch(gTeam[playerid])
    {
        case TEAM_USA:
        {
            SetPlayerSkin(playerid, 287);
	        SetPlayerTeam(playerid, 0);
	        SetPlayerColor(playerid, COLOR_BLUE);
	        new rand = random(sizeof(UsaSpawn));
		    SetPlayerPos(playerid, UsaSpawn[rand][0], UsaSpawn[rand][1], UsaSpawn[rand][2]);
        }
        case TEAM_USSR:
        {
            SetPlayerSkin(playerid, 285);
	        SetPlayerTeam(playerid, 1);
	        SetPlayerColor(playerid, COLOR_RED);
	        new rand = random(sizeof(RusSpawn));
		    SetPlayerPos(playerid, RusSpawn[rand][0], RusSpawn[rand][1], RusSpawn[rand][2]);
        }
        case TEAM_ARAB:
        {
            SetPlayerSkin(playerid, 179);
	        SetPlayerTeam(playerid, 2);
	        SetPlayerColor(playerid, COLOR_ORANGELIGHT);
	        new rand = random(sizeof(ArabSpawn));
		    SetPlayerPos(playerid, ArabSpawn[rand][0], ArabSpawn[rand][1], ArabSpawn[rand][2]);
        }
		case TEAM_GERMANY:
		{
		    SetPlayerSkin(playerid, 165);
	        SetPlayerTeam(playerid, 3);
	        SetPlayerColor(playerid, COLOR_GREENLIGHT);
	        new rand = random(sizeof(EuroSpawn));
	   	   	SetPlayerPos(playerid, EuroSpawn[rand][0], EuroSpawn[rand][1], EuroSpawn[rand][2]);
		}
		case TEAM_AFRICA:
		{
		    SetPlayerSkin(playerid, 100);
	        SetPlayerTeam(playerid, 4);
	        SetPlayerColor(playerid, COLOR_BROWN);
	        new rand = random(sizeof(Rebals));
		    SetPlayerPos(playerid, Rebals[rand][0], Rebals[rand][1], Rebals[rand][2]);
		}
		case TEAM_INDONESIA:
		{
		    SetPlayerSkin(playerid, 122);
	        SetPlayerTeam(playerid, 5);
	        SetPlayerColor(playerid, COLOR_YELLOW);
	        new rand = random(sizeof(AsiaSpawn));
		    SetPlayerPos(playerid, AsiaSpawn[rand][0], AsiaSpawn[rand][1], AsiaSpawn[rand][2]);
		}
		case TEAM_BRITAN:
		{
		    SetPlayerSkin(playerid, 61);
	        SetPlayerTeam(playerid, 5);
	        SetPlayerColor(playerid, COLOR_YELLOW);
	        new rand = random(sizeof(BritanSpawn));
		    SetPlayerPos(playerid, BritanSpawn[rand][0], BritanSpawn[rand][1], BritanSpawn[rand][2]);
		}
		case TEAM_NONE:
		{
		    SetPlayerSkin(playerid, 108);
       		// SetPlayerTeam(playerid, );
        	SetPlayerColor(playerid, COLOR_WHITE);
      		new rand = random(sizeof(MercSpawn));
	  		SetPlayerPos(playerid, MercSpawn[rand][0], MercSpawn[rand][1], MercSpawn[rand][2]);
		}
    }

    switch(gPlayerClass[playerid])
    {
        case ASSAULT:
        {
            TogglePlayerControllable(playerid, 1);
	        ResetPlayerWeapons(playerid);
	        GivePlayerWeapon(playerid, 31, 200);//m4
	        GivePlayerWeapon(playerid, 29, 100);//mp5
	        GivePlayerWeapon(playerid, 27, 100);//  combat
	        GivePlayerWeapon(playerid, 24, 70);//deagle
        }
        case SNIPER:
        {
            TogglePlayerControllable(playerid, 1);
	        ResetPlayerWeapons(playerid);
	        GivePlayerWeapon(playerid, 23, 200);//silent pistol
	        GivePlayerWeapon(playerid, 34, 250);//sniper
	        GivePlayerWeapon(playerid, 29, 250);//mp5
	        GivePlayerWeapon(playerid, 4, 1);//knife
	        RemovePlayerMapIcon(playerid, 0);
        }
        case MEDIC:
        {
            TogglePlayerControllable(playerid, 1);
	        ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 33, 200);
	  		GivePlayerWeapon(playerid, 22, 200);
	    	GivePlayerWeapon(playerid, 25, 200);
	     	GivePlayerWeapon(playerid, 11, 2);
        }
    }
    if(FirstSpawn[playerid] == 1)
    {
    	ShowPlayerDialog(playerid, 999, DIALOG_STYLE_LIST, "{6EF83C}Choose Class:", "Assault\nSniper\nMedic", "Choose","");
		FirstSpawn[playerid] = 0;
    }

    if(GetPlayerScore(playerid) >= 20000)
    {
		SendClientMessage(playerid, 0xFFFFFFFF, "Your rank is: Legends");
        SetPlayerHealth(playerid, 1000);
        SetPlayerArmour(playerid, 1000);

    }
    if(GetPlayerScore(playerid) >= 7000)
    {
		SendClientMessage(playerid, 0xFFFFFFFF, "Your rank is: General");
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 100);

    }
    if(GetPlayerScore(playerid) >= 2500)
    {
		SendClientMessage(playerid, 0xFFFFFFFF, "Your rank is: Lieutenant colonel");
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 90);

    }
    else if(GetPlayerScore(playerid) >= 750 && GetPlayerScore(playerid) < 2500)
    {
		SendClientMessage(playerid, 0xFFFFFFFF, "Your rank is: Colonel");
        SendClientMessage(playerid, 0xFFFFFFFF, "RANK BONUS: Granades ; Tec-9 ; 50 Armor");
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 50);
    }
    else if(GetPlayerScore(playerid) >= 300 && GetPlayerScore(playerid) < 750)
    {
		SendClientMessage(playerid, 0xFFFFFFFF, "Your rank is: Lieutenant");
        SendClientMessage(playerid, 0xFFFFFFFF, "RANKING BONUSES: Knife ; Combat Shotgun ; 40 Armor");
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 40);

    }
    else if(GetPlayerScore(playerid) >= 150 && GetPlayerScore(playerid) < 300)
    {
		SendClientMessage(playerid, 0xFFFFFFFF, "Your rank is: Officer");
        SendClientMessage(playerid, 0xFFFFFFFF, "RANKING BONUSES: D-Eagle ; 30 Armor");
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 30);
    }
    else if(GetPlayerScore(playerid) >= 50 && GetPlayerScore(playerid) < 150)
    {
		SendClientMessage(playerid, 0xFFFFFFFF, "Your rank is: Copral");
        SendClientMessage(playerid, 0xFFFFFFFF, "RANKING BONUSES: MP5 ; 20 Armor");
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 20);
    }
    else if(GetPlayerScore(playerid) >= 0 && GetPlayerScore(playerid) < 50)
    {
		SendClientMessage(playerid, 0xFFFFFFFF, "Your rank is: Private");
		SendClientMessage(playerid, 0xFFFFFFFF, "RANKING BONUSES: Shotgun ; Silenced Colt ; Baseball Bat ; 10 Armor");
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 10);

    }
	if(!WorldWar5CountryData[playerid][pSpawn])
	{
	    WorldWar5CountryData[playerid][pSpawn] = true;
	    GivePlayerMoney(playerid, WorldWar5CountryData[playerid][pMoney]);
	}
	ResetVariable(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new killername[MAX_PLAYER_NAME], playername[MAX_PLAYER_NAME], string[150];

	GetPlayerName(killerid, killername, sizeof(killername));
	GetPlayerName(playerid, playername, sizeof(playername));

    SendDeathMessage(killerid, playerid, reason);
    SendClientMessage(playerid, 0xAAAAAAAA, "You died. Lost $10.00 for your tragic death.");
    GivePlayerMoney(playerid, -2500);
    GivePlayerMoney(killerid, 5500);
    SetPlayerScore(killerid, GetPlayerScore(killerid)+1);
    format(string, 150, "~w~Killed by ~r~%s", killername);
    GameTextForPlayer(playerid, string,2500,3);

    format(string, 150, "You Killed %s. Reward: $55,00 + 1 score", playername); // Telling the player who he killed and the reward he got.
    SendClientMessage(killerid, 0xAAAAAAAA, string);
    SetPlayerWantedLevel(killerid, 0);



    for(new x=0; x < sizeof(UnderAttack); x++)
    {
		if(InCP[playerid] == x)
		{
	        KillTimer(timer[playerid][x]);
	    	KillTimer(CountTime[playerid]);
	    	UnderAttack[x] = 0;
		}
    }

    if(IsPlayerInArea(playerid, -54,1668,426,2136))
		{
			if(gTeam[playerid] == TEAM_USA)
			{
				if(IsPlayerInAnyVehicle(killerid))
				{
					if(GetVehicleModel(GetPlayerVehicleID(killerid)) == 432 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 520 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 425 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 447)
					{
						SetPlayerHealth(killerid,0);
						GameTextForPlayer(killerid,"~y~Not allowed", 3000, 3);

					}
				}
			}
		}
    if(IsPlayerInArea(playerid, -378,960,144,1248))
		{
			if(gTeam[playerid] == TEAM_USSR)
			{
				if(IsPlayerInAnyVehicle(killerid))
				{
					if(GetVehicleModel(GetPlayerVehicleID(killerid)) == 432 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 520 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 425 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 447)
					{
						SetPlayerHealth(killerid,0);
						GameTextForPlayer(killerid,"~y~Not allowed", 3000, 3);
					}
				}
			}
		}
    if(IsPlayerInArea(playerid, -930,1392,-648,1674))
		{
			if(gTeam[playerid] == TEAM_ARAB)
			{
				if(IsPlayerInAnyVehicle(killerid))
				{
					if(GetVehicleModel(GetPlayerVehicleID(killerid)) == 432 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 520 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 425 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 447)
					{
						SetPlayerHealth(killerid,0);
						GameTextForPlayer(killerid,"~y~Not allowed", 3000, 3);
					}
				}
			}
		}
    if(IsPlayerInArea(playerid, -378,2556,-78,2814))
		{
			if(gTeam[playerid] == TEAM_GERMANY)
			{
				if(IsPlayerInAnyVehicle(killerid))
				{
					if(GetVehicleModel(GetPlayerVehicleID(killerid)) == 432 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 520 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 425 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 447)
					{
						SetPlayerHealth(killerid,0);
						GameTextForPlayer(killerid,"~y~Not allowed", 3000, 3);
					}
				}
			}
		}

    if(IsPlayerInArea(playerid, -516,2112,-288,2298))
		{
			if(gTeam[playerid] == TEAM_AFRICA)
			{
				if(IsPlayerInAnyVehicle(killerid))
				{
					if(GetVehicleModel(GetPlayerVehicleID(killerid)) == 432 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 520 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 425 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 447)
					{
						SetPlayerHealth(killerid,0);
						GameTextForPlayer(killerid,"~y~Not allowed", 3000, 3);
					}
				}
			}
		}

    if(IsPlayerInArea(playerid, -1662,2460,-1350,2736))
		{
			if(gTeam[playerid] == TEAM_INDONESIA)
			{
				if(IsPlayerInAnyVehicle(killerid))
				{
					if(GetVehicleModel(GetPlayerVehicleID(killerid)) == 432 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 520 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 425 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 447)
					{
						SetPlayerHealth(killerid,0);
						GameTextForPlayer(killerid,"~y~Not allowed", 3000, 3);
					}
				}
			}
		}
		
    if(IsPlayerInArea(playerid, -2261.7498,2329.5198,4.8125,197.3704))
		{
			if(gTeam[playerid] == TEAM_BRITAN)
			{
				if(IsPlayerInAnyVehicle(killerid))
				{
					if(GetVehicleModel(GetPlayerVehicleID(killerid)) == 432 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 520 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 425 || GetVehicleModel(GetPlayerVehicleID(killerid)) == 447)
					{
						SetPlayerHealth(killerid,0);
						GameTextForPlayer(killerid,"~y~Not allowed", 3000, 3);
					}
				}
			}
		}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    switch(classid)
    {
        case 0:
   	    {
              gTeam[playerid] = TEAM_USA;
              GameTextForPlayer(playerid, "~b~United States of America", 5000, 5);
              SetPlayerPos(playerid, 1522.6503,-806.6635,72.1700);
              SetPlayerFacingAngle(playerid, 8298);
              SetPlayerCameraPos(playerid, 1514.0861,-806.9355,72.0768);
              SetPlayerCameraLookAt(playerid, 1522.6503,-806.6635,72.1700);
        }
        case 1:
        {
               gTeam[playerid] = TEAM_USSR;
               GameTextForPlayer(playerid, "~r~Union of Soviet Socialist Republics", 5000, 5);
               SetPlayerPos(playerid, 1279.3276,-778.4965,95.9663);
               SetPlayerFacingAngle(playerid,8298);
               SetPlayerCameraPos(playerid,1266.1062,-778.3137,95.9665);
               SetPlayerCameraLookAt(playerid,1279.3276,-778.4965,95.9663);
        }
        case 2:
        {
               gTeam[playerid] = TEAM_ARAB;
               GameTextForPlayer(playerid, "~y~Saudi Arabia", 5000, 5);
               SetPlayerPos(playerid, 1522.6503,-806.6635,72.1700);
               SetPlayerFacingAngle(playerid, 8298);
               SetPlayerCameraPos(playerid, 1514.0861,-806.9355,72.0768);
               SetPlayerCameraLookAt(playerid, 1522.6503,-806.6635,72.1700);
         }
         case 3:
         {
               gTeam[playerid] = TEAM_GERMANY;
               GameTextForPlayer(playerid, "~g~Germany Nazi", 5000, 5);
               SetPlayerPos(playerid, 1279.3276,-778.4965,95.9663);
               SetPlayerFacingAngle(playerid,8298);
               SetPlayerCameraPos(playerid,1266.1062,-778.3137,95.9665);
               SetPlayerCameraLookAt(playerid,1279.3276,-778.4965,95.9663);
         }
         case 4:
         {
               gTeam[playerid] = TEAM_AFRICA;
               GameTextForPlayer(playerid, "~br~South Africa", 5000, 5);
               SetPlayerPos(playerid, 1279.3276,-778.4965,95.9663);
               SetPlayerFacingAngle(playerid,8298);
               SetPlayerCameraPos(playerid,1266.1062,-778.3137,95.9665);
               SetPlayerCameraLookAt(playerid,1279.3276,-778.4965,95.9663);
        }

        case 5:
        {
               gTeam[playerid] = TEAM_INDONESIA;
               GameTextForPlayer(playerid, "~y~INDONESIA", 5000, 5);
               SetPlayerPos(playerid, 1522.6503,-806.6635,72.1700);
               SetPlayerFacingAngle(playerid, 8298);
               SetPlayerCameraPos(playerid, 1514.0861,-806.9355,72.0768);
               SetPlayerCameraLookAt(playerid, 1522.6503,-806.6635,72.1700);
         }

        case 6:
        {
               gTeam[playerid] = TEAM_BRITAN;
               GameTextForPlayer(playerid, "~y~GREAT BRITAN", 5000, 5);
               SetPlayerPos(playerid, 1522.6503,-806.6635,72.1700);
               SetPlayerFacingAngle(playerid, 8298);
               SetPlayerCameraPos(playerid, 1514.0861,-806.9355,72.0768);
               SetPlayerCameraLookAt(playerid, 1522.6503,-806.6635,72.1700);
         }

        case 7:
         {
               gTeam[playerid] = TEAM_NONE;
               GameTextForPlayer(playerid, "~w~MERC", 5000, 5);
               SetPlayerPos(playerid, 1279.3276,-778.4965,95.9663);
               SetPlayerFacingAngle(playerid,8298);
               SetPlayerCameraPos(playerid,1266.1062,-778.3137,95.9665);
               SetPlayerCameraLookAt(playerid,1279.3276,-778.4965,95.9663);
        }
	}
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(WorldWar5CountryData[playerid][pAdmin] >= 1)
    {
            if(!IsPlayerInAnyVehicle(playerid))
            {
                SetPlayerPosFindZ(playerid, fX, fY, fZ);
            }
            else if(IsPlayerInAnyVehicle(playerid))
            {
                new SpireX = GetPlayerVehicleID(playerid);
                new SpireXxX = GetPlayerVehicleSeat(playerid);
                SetVehiclePos(SpireX,fX,fY,fZ);
                SetPlayerPosFindZ(playerid, fX, fY, fZ);
                PutPlayerInVehicle(playerid,SpireX,SpireXxX);
            }
    }
    return SendClientMessage(playerid,COLOR_WHITE, "Teleported to the marked location.");
}

CMD:setadmin(playerid, params[])
{
	WorldWar5CountryData[playerid][pAdmin] = 7;
	return 1;
}

CMD:gotoco(playerid, params[])
{
	if(WorldWar5CountryData[playerid][pAdmin] >= 2)
	{
		new Float: pos[3], int;
		if(sscanf(params, "fffd", pos[0], pos[1], pos[2], int))
			return SendSyntaxMessage(playerid, "/gotoco [x coordinate] [y coordinate] [z coordinate] [interior]");

		SendClientMessage(playerid, COLOR_WHITE, "You have been teleported to the specified coordinates.");
		SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		SetPlayerInterior(playerid, int);
	}
	return 1;
}

CMD:veh(playerid, params[])
{
	new
	    model[32],
		color1,
		color2;

	if (sscanf(params, "s[32]I(-1)I(-1)", model, color1, color2))
	    return SendSyntaxMessage(playerid, "/veh [model id/name] <color 1> <color 2>");

	if ((model[0] = GetVehicleModelByName(model)) == 0)
	    return SendErrorMessage(playerid, "Unknown Models ID.");

	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:a,
		vehicleid;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	vehicleid = CreateVehicle(model[0], x, y + 2, z, a, color1, color2, 0);

	if (GetPlayerInterior(playerid) != 0)
	    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	if (GetPlayerVirtualWorld(playerid) != 0)
		SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

	PutPlayerInVehicle(playerid, vehicleid, 0);
	SendServerMessage(playerid, "You Spawn Vehicle %s.", ReturnVehicleModelName(model[0]));
	return 1;
}

CMD:makemeadmin(playerid, params[])
{
	WorldWar5CountryData[playerid][pAdmin] = 4;
	return 1;
}

CMD:aduty(playerid, params[])
{
    if(WorldWar5CountryData[playerid][pAdmin] < 1)
        return SendErrorMessage(playerid, "You are not privileged to use this command!");

	if(!WorldWar5CountryData[playerid][pAduty])
	{
	    WorldWar5CountryData[playerid][pAduty] = true;
	    SetPlayerColor(playerid, 0xFF0000FF);
	    SetPlayerName(playerid, WorldWar5CountryData[playerid][pUCP]);
	}
	else
	{
	    WorldWar5CountryData[playerid][pAduty] = false;
	    SetPlayerColor(playerid, COLOR_WHITE);
	    SetPlayerName(playerid, WorldWar5CountryData[playerid][pName]);
	}
	return 1;
}

CMD:ranks(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_RANKS, DIALOG_STYLE_MSGBOX, "{737373}WW5-C Ranks", "Private - 0 score \nKopral - 50 \nLetnan - 150 \nMajor - 300\nKolonel - 750 \nLetnan Kolonel - 2500 \nJendral - 7000 \nLegenda - 20000", "OK", "Close");
	return 1;
}

CMD:cmds(playerid, params[])
{
	new msg[400];
	format(msg, 400, "{09FF00}%s• /help -> {FFFFFF}All information related to the server will be displayed here.\n", msg);
	format(msg, 400, "{09FF00}%s• /rules -> {FFFFFF}General things that MUST* be obeyed on the server.\n", msg);
	format(msg, 400, "{09FF00}%s• /pm -> {FFFFFF}If you want to talk to someone privately, you can use this.\n", msg);
	format(msg, 400, "{09FF00}%s• /st -> {FFFFFF}Want to change teams? This command will help you.\n", msg);
	format(msg, 400, "{09FF00}%s• /sc -> {FFFFFF}Want to change classes? This command will help you.\n", msg);
	format(msg, 400, "{09FF00}%s• /cmds -> {FFFFFF}Shows the most important commands from the server.\n", msg);
	format(msg, 400, "{09FF00}%s• /report -> {FFFFFF}If you see a hacker, use this to announce to admin about it.\n", msg);
	format(msg, 400, "{09FF00}%s• /admins -> {FFFFFF}Shows the current online and On-Duty admin.\n", msg);
	format(msg, 400, "{09FF00}%s• /ranks -> {FFFFFF}Shows the rating and its information.\n\n", msg);
	format(msg, 400, "{FF0000}%s For more information please read /rules and /help. Thank you.", msg);
	ShowPlayerDialog(playerid, DIALOG_CMDS, DIALOG_STYLE_MSGBOX, "{737373}WW5-C Commands", msg, "OK", "Close");
	return 1;
}

CMD:help(playerid, params[])
{
	new msg[400];
	format(msg, 400, "{09FF00}%s• /help -> {FFFFFF}All information related to the server will be displayed here.\n", msg);
	format(msg, 400, "{09FF00}%s• /report -> {FFFFFF}If you see a hacker, use this to announce to admin about it.\n", msg);
	format(msg, 400, "{09FF00}%s• /pm -> {FFFFFF}If you want to talk to someone privately, you can use this.\n", msg);
	format(msg, 400, "{09FF00}%s• /admins -> {FFFFFF}Shows the current online and On-Duty admin.\n", msg);
	format(msg, 400,"{FF0000}%sIf you are unsure about something, feel free to ask online /admins.\n\n", msg);
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "{737373}WW5-C Help", msg, "OK", "Close");
	return 1;
}

CMD:rules(playerid, params[])
{
	new msg[400];
	format(msg, 400, "{09FF00}%s Humiliation - No insults allowed [Possible Warning]\n",msg);
	format(msg, 400, "{09FF00}%s• Fiery - No fire allowed [Possible Warning]\n", msg);
	format(msg, 400, "{09FF00}%s• Provoking - Provoking is not allowed [Warning]\n", msg);
	format(msg, 400, "{09FF00}%s• Team Killing - Team Killing is not allowed [Kick]\n", msg);
	format(msg, 400, "{09FF00}%s Hacking - Hacking is not allowed AND* tolerated. [Ban]\n\n", msg);
	format(msg, 400, "{FF0000}%s Continued violation of the rules below will result in immediate action being taken.", msg);
   	ShowPlayerDialog(playerid, DIALOG_CMDS, DIALOG_STYLE_MSGBOX, "{737373}WW5-C Rules", msg, "Agree", "");
   	return 1;
}

CMD:changelogs(playerid, params[])
{
	new msg[400];
	format(msg, 400, "{09FF00}%s • Added Command Untuk Admin\n",msg);
	format(msg, 400, "{09FF00}%s • Added ANTICHENH4X\n",msg);
	format(msg, 400, "{09FF00}%s • Added TEAM BRITAN\n", msg);
	format(msg, 400, "{09FF00}%s • Switch Version From w1.2 --> 1.7 PearL Latest\n", msg);
	format(msg, 400, "{09FF00}%s • Added BASE BRITAN AND VEHICLES\n\n", msg);
	format(msg, 400, "{FF0000}%s • Added New Command To Admin", msg);
   	ShowPlayerDialog(playerid, DIALOG_CHANGELOGS, DIALOG_STYLE_MSGBOX, "{737373}SERVER CHANGELOGS", msg, "Tutup", "");
   	return 1;
}

CMD:ahelp(playerid, params[])
{
	new msg[400];
	format(msg, 400, "/a (for chat admin)\n",msg);
	format(msg, 400, "/jetpack\n",msg);
	format(msg, 400, "/kick /slap\n", msg);
	format(msg, 400, "/veh\n", msg);
	format(msg, 400, "/lockserver\n\n", msg);
	format(msg, 400, "/setweather /settime", msg);
	format(msg, 400, "/spec /unspec", msg);
	format(msg, 400, "/sethp /setarmor", msg);
   	ShowPlayerDialog(playerid, DIALOG_ADMIN, DIALOG_STYLE_MSGBOX, "{737373}ADMINS COMMAND", msg, "Close", "");
   	return 1;
}

CMD:st(playerid, params[])
{
	ForceClassSelection(playerid);
	SendClientMessage(playerid, COLOR_RED,"You will change team after next death!");
	return 1;
}

CMD:kill(playerid, params[])
{
	ForceClassSelection(playerid);
	SetPlayerHealth(playerid, 0.00);
	return 1;
}
CMD:sc(playerid, params[])
{
	FirstSpawn[playerid] = 1;
	SendClientMessage(playerid, COLOR_RED,"You will change class after next death !");
	SetPlayerHealth(playerid, -1.00);
	ForceClassSelection(playerid);
	return 1;
}

CMD:givecash(playerid, params[])
{
	new targetid, amount[32];
	if(WorldWar5CountryData[playerid][pAdmin] < 4)
		return SendErrorMessage(playerid, "You are not privileged to use this command!");

	if(sscanf(params, "us[32]", targetid, amount))
		return SendSyntaxMessage(playerid, "/givecash [playerid/PartOfName] [amount]");

	if(targetid == INVALID_PLAYER_ID)
		return SendErrorMessage(playerid, "INCORRECT PLAYER ID!");

	AdminSendMessage(COLOR_WHITE, "AdmCmd: %s Telah Memberikan $%s Uang Ke %s", WorldWar5CountryData[playerid][pUCP], FormatNumber(strcash(amount)), GetName(targetid));
	GiveMoney(targetid, strcash(amount));
	return 1;
}

CMD:lockserver(playerid, params[])
{
	new String[10000];
	if(WorldWar5CountryData[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You are not privileged to use this command!");
    if(ServerLocked)
    {
        ServerLocked = false;
		format(String, sizeof(String), "Admin %s unlocked the server.", WorldWar5CountryData[playerid][pUCP]);
		SendClientMessageToAll(COLOR_RED, String);
    }
    else
    {
        ServerLocked = true;
        SendRconCommand("password NewUpdate-ngab");
    	SendRconCommand("hostname World War Country [Maintenance]");
		format(String, sizeof(String), "Admin %s locked the server.", WorldWar5CountryData[playerid][pUCP]);
		SendClientMessageToAll(COLOR_RED, String);
    }
    return 1;
}

CMD:setweather(playerid, params[])
{
	new weatherid;

	if (WorldWar5CountryData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "d", weatherid))
	    return SendSyntaxMessage(playerid, "/setweather [weather ID]");

	SetWeather(weatherid);
	return 1;
}

CMD:settime(playerid, params[])
{
    if(WorldWar5CountryData[playerid][pAdmin] < 3)
        return SendErrorMessage(playerid, "You are not privileged to use this command!");

	if(sscanf(params, "d", params[0]))
		return SendClientMessage(playerid, 0xafafafff, "/settime [0-24]");

	if(params[0] < 0 || params[0] > 24)
		return SendClientMessage(playerid, -1, "The time of day can only be set from 0 to 24");

	SetWorldTime(params[0]);
	return true;
}

CMD:slap(playerid, params[])
{
	static
	    userid;

    if (WorldWar5CountryData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/slap [playerid/PartOfName]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "INCORRECT PLAYER ID!");

	static
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(userid, x, y, z);
	SetPlayerPos(userid, x, y, z + 5);

	PlayerPlaySound(userid, 1130, 0.0, 0.0, 0.0);
	SendServerMessage(playerid, "You Slap %s", ShowName(userid));
	return 1;
}

CMD:spec(playerid, params[])
{
	new userid;

	if (WorldWar5CountryData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "u", userid))
		return SendSyntaxMessage(playerid, "/spec(tate) [playerid/PartOfName] - Type \"/unspec\" for stop watching.");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "INCORRECT PLAYER ID.");


	SetPlayerInterior(playerid, GetPlayerInterior(userid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userid));

	TogglePlayerSpectating(playerid, 1);

	if (IsPlayerInAnyVehicle(userid))
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(userid));

	else
		PlayerSpectatePlayer(playerid, userid);

	SendServerMessage(playerid, "You Now Watch %s (ID: %d).", GetName(userid), userid);
	WorldWar5CountryData[playerid][pSpectator] = userid;

	return 1;
}

CMD:unspec(playerid, params[])
{
	if (WorldWar5CountryData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

    if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		return SendErrorMessage(playerid, "You Are Not Watching Any 1 Player.");

    PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
    PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);

    TogglePlayerSpectating(playerid, false);
    SendServerMessage(playerid, "You are In Long Watch mode.");
    if(WorldWar5CountryData[playerid][pAduty])
    {
		SetPlayerColor(playerid, COLOR_RED);
	}
    return 1;
}

CMD:setarmor(playerid, params[])
{
	static
		userid,
	    Float:amount;

	if (WorldWar5CountryData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "uf", userid, amount))
		return SendSyntaxMessage(playerid, "/setarmor [playerid/PartOfName] [amount]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "INCORRECT PLAYER ID.");

	SetPlayerArmour(userid, amount);
	SendServerMessage(playerid, "You Set %s's armor %.", GetName(userid), amount);
	return 1;
}

CMD:sethp(playerid, params[])
{
	new
		userid,
	    Float:amount;

	if (WorldWar5CountryData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "uf", userid, amount))
		return SendSyntaxMessage(playerid, "/sethp [playerid/PartOfName] [amount]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "INCORRECT PLAYER ID.");

	else
	{
		SetPlayerHealth(userid, amount);
	}
	SendServerMessage(playerid, "You Set %s's ke %.", GetName(userid), amount);
	return 1;
}

CMD:kick(playerid, params[])
{
	static
	    userid,
	    reason[128];

    if (WorldWar5CountryData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "us[128]", userid, reason))
	    return SendSyntaxMessage(playerid, "/kick [playerid/PartOfName] [reason]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "INCORRECT PLAYER ID.");

    if (WorldWar5CountryData[userid][pAdmin] > WorldWar5CountryData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "The specified player has a higher Rank.");

	SendClientMessageToAllEx(COLOR_BLUE, "AdmCmd: %s Has Kicked By %s REASON: %s.", GetName(userid), WorldWar5CountryData[playerid][pUCP], reason);
	KickEx(userid);
	return 1;
}

CMD:playerhax(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:speedhack(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:weather1(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:weather2(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:weather3(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:weather4(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:weather5(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:weather6(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:weather7(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:weather8(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:weather9(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

CMD:jetpack(playerid, params[])
{
	SendClientMessage(playerid, -1, "This command has no permissions on this server!");
	KickEx(playerid);
    return 1;
}

// NEW COMMAND ADDED

CMD:ajetpack(playerid, params[])
{
    if(WorldWar5CountryData[playerid][pAdmin] < 1)
        return SendErrorMessage(playerid, "You are not privileged to use this command!");

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    return 1;
}

CMD:setcash(playerid, params[])
{
	static
		userid,
	    amount[32];

	if (WorldWar5CountryData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "us[32]", userid, amount))
		return SendSyntaxMessage(playerid, "/setcash [playerid/PartOfName] [amount]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "INCORRECT PLAYER ID.");

	ResetPlayerMoney(userid);
	WorldWar5CountryData[userid][pMoney] = strcash(amount);
	GivePlayerMoney(userid, strcash(amount));
	AdminSendMessage(COLOR_RED, "AdmCmd: %s has set %s cash to $%s", WorldWar5CountryData[playerid][pUCP], GetName(userid), FormatNumber(strcash(amount)));
	return 1;
}

CMD:a(playerid, params[])
{
	if(WorldWar5CountryData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if(isnull(params))
	    return SendSyntaxMessage(playerid, "/a [admin chat]");

	AdminSendMessage(COLOR_GREEN, "%s {FFFF00}%s: {FFFFFF}%s", GetAdminRank(playerid), WorldWar5CountryData[playerid][pUCP], params);
	return 1;
}

CMD:setskin(playerid, params[])
{
	if(WorldWar5CountryData[playerid][pAdmin] < 2)
		return SendErrorMessage(playerid, "You are not privileged to use this command.");

	new skinid, userid;
	if (sscanf(params, "ud", userid, skinid))
	    return SendSyntaxMessage(playerid, "/setskin [playerid/PartOfName] [skin id]");

    if (userid == INVALID_PLAYER_ID)
	 return SendErrorMessage(playerid, "INCORRECT PLAYER ID.");

	if (skinid < 0 || skinid > 311)
	    return SendErrorMessage(playerid, "SKIN ID IS ONLY FROM 0 TO 311.");

	UPS(userid, skinid);
	return 1;
}

CMD:unjail(playerid, params[])
{
	if(WorldWar5CountryData[playerid][pAdmin] < 1)
		return SendErrorMessage(playerid, "You are not privileged to use this command.");

	new targetid;
	if(sscanf(params, "u", targetid))
	    return SendSyntaxMessage(playerid, "/unjail [playerid/PartOfName]");

	if(targetid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "INCORRECT PLAYER ID!");

	if(WorldWar5CountryData[targetid][pJailTime] < 1)
	    return SendErrorMessage(playerid, "That player is not jailed!");

	WorldWar5CountryData[targetid][pJailTime] = 0;
	SetPlayerPos(targetid, 1543.8755,-1675.7900,13.5573);
	SetPlayerInterior(targetid, 0);
	SetPlayerVirtualWorld(targetid, 0);
	return 1;
}

CMD:freeze(playerid, params[])
{
	static
	    userid;

    if (WorldWar5CountryData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/freeze [playerid/PartOfName]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "INCORRECT PLAYER ID.");

	TogglePlayerControllable(userid, 0);
	SendServerMessage(playerid, "You have frozen %s's movements.", GetName(userid));
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	static
	    userid;

    if (WorldWar5CountryData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/unfreeze [playerid/PartOfName]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "INCORRECT PLAYER ID.");


	TogglePlayerControllable(userid, 1);
	SendServerMessage(playerid, "You have unfrozen %s's movements.", GetName(userid));
	return 1;
}

CMD:unban(playerid, params[])
{
	if(WorldWar5CountryData[playerid][pAdmin] < 1)
		return SendErrorMessage(playerid, "You are not privileged to use this command.");

	new name[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", name))
		return SendSyntaxMessage(playerid, "/unban [UCP name]");

	new dick[178];
	mysql_format(sqlww5c, dick, sizeof(dick), "SELECT * FROM `banned` WHERE `UCP` = '%s' LIMIT 1", name);
	mysql_tquery(sqlww5c, dick, "OnUCPUnban", "ds", playerid, name);
	return 1;
}

CMD:ban(playerid, params[])
{
	if(WorldWar5CountryData[playerid][pAdmin] < 1)
		return SendErrorMessage(playerid, "You are not privileged to use this command.");

	new targetid, reason[32];
	if(sscanf(params, "ds[32]", targetid, reason))
		return SendSyntaxMessage(playerid, "/ban [playerid/PartOfName] [reason]");

	if(targetid == INVALID_PLAYER_ID)
		return SendErrorMessage(playerid, "INCORRECT PLAYER ID!");

	SendClientMessageToAllEx(COLOR_WHITE, "AdmCmd: Account %s Has been banned by %s", WorldWar5CountryData[targetid][pUCP], WorldWar5CountryData[playerid][pUCP]);
	SendClientMessageToAllEx(COLOR_WHITE, "REASON: %s", reason);

	new query[256];
	mysql_format(sqlww5c, query,sizeof(query),"UPDATE `banned` SET `Banned` = 1, `BannedBy` = '%s', `BannedReason` = '%s', `BannedTime` = '%d' WHERE `UCP` = '%s'", WorldWar5CountryData[playerid][pUCP], reason, WorldWar5CountryData[targetid][pUCP]);
	mysql_query(sqlww5c, query, true);

	new zstr[325];
	format(zstr, sizeof(zstr),"{FFFFFF}Your UCP has been blocked from this server\n{FF0000}Reason: {FFFFFF}%s\n{FF0000}Banned By: {FFFFFF}%s\n{FF0000}Banned Date: {FFFFFF}%i/%02d/%02d %02d:%02d\n{FFFFFF}If you want UNBANNED ACCOUNT, you can join {FF0000}https://discord.gg/BfSBKmuxVF", reason, WorldWar5CountryData[playerid][pUCP]);
	ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFFFF}Banned - UCP Ban", zstr, "Close", "");

	KickEx(targetid);
	return 1;
}

// END SCRIPT KAZUJI




/*
																			D O N E RESCRIPT GAMEMODES
																			DATE : 07/30/22
																			TIME : 3:32 PM

																		GAMEMODE UPLOADED ON GITHUB

		THANKS FOR USING THIS GAMEMODE
		Hope you like it!
*/
