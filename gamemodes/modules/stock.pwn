stock IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
    new Float:X, Float:Y, Float:Z;

    GetPlayerPos(playerid, X, Y, Z);
    if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) {
        return 1;
    }
    return 0;
}

stock GetAdminRank(playerid)
{
 	new astring[28];
 	if(WorldWar5CountryData[playerid][pAdmin] == 0) format(astring, sizeof(astring), "None");
	else if (WorldWar5CountryData[playerid][pAdmin] == 1)format(astring, sizeof(astring), "Junior Admin");
	else if (WorldWar5CountryData[playerid][pAdmin] == 2)format(astring, sizeof(astring), "Senior Admin");
	else if (WorldWar5CountryData[playerid][pAdmin] == 3)format(astring, sizeof(astring), "Management");
	else if (WorldWar5CountryData[playerid][pAdmin] == 4)format(astring, sizeof(astring), "Developer");
	return astring;
}

stock AdminSendMessage(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player) if(WorldWar5CountryData[i][pSpawn])
		{
			if (WorldWar5CountryData[i][pAdmin] >= 1)
			{
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player) if(WorldWar5CountryData[i][pSpawn])
	{
		if (WorldWar5CountryData[i][pAdmin] >= 1)
		{
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

stock UPS(playerid, skinid)
{
	SetPlayerSkin(playerid, skinid);
	WorldWar5CountryData[playerid][pSkin] = skinid;
}

stock GiveMoney(playerid, amount)
{
	new string[128];
	if(amount < 0) format(string, sizeof(string), "~r~%s", FormatNumber(amount));
	else format(string, sizeof(string), "~g~+%s", FormatNumber(amount));

	WorldWar5CountryData[playerid][pMoney] += amount;
	GivePlayerMoney(playerid, amount);
	return 1;
}

stock GetMoney(playerid)
{
	return WorldWar5CountryData[playerid][pMoney];
}

stock FormatNumber(Float:amount, delimiter[2]=".", comma[2]=",")
{
	#define MAX_MONEY_String 16
	new txt[MAX_MONEY_String];
	format(txt, MAX_MONEY_String, "%d", floatround(amount));
	new l = strlen(txt);
	if (amount < 0) // -
	{
		if (l > 2) strins(txt,delimiter,l-2);
		if (l > 5) strins(txt,comma,l-5);
		if (l > 8) strins(txt,comma,l-8);
	}
	else
	{//1000000
		if (l > 2) strins(txt,delimiter,l-2);
		if (l > 5) strins(txt,comma,l-5);
		if (l > 9) strins(txt,comma,l-8);
	}
	return txt;
}

stock strcash(value[])
{
	new dollars, cents, totalcash[25];
	if(strfind(value, ".", true) != -1)
	{
		sscanf(value, "p<.>dd", dollars, cents);
		format(totalcash, sizeof(totalcash), "%d%02d", dollars, cents);
	}
	else
	{
		sscanf(value, "d", dollars);
		format(totalcash, sizeof(totalcash), "%d00", dollars);
	}
	return strval(totalcash);
}

stock ShowName(playerid)
{
    static
        name[MAX_PLAYER_NAME + 1];

    GetPlayerName(playerid, name, sizeof(name));
	{
	    for (new i = 0, len = strlen(name); i < len; i ++)
		{
	        if (name[i] == '_') name[i] = ' ';
		}
	}
    return name;
}


stock PlayerPlayNearbySound(playerid, soundid)
{
	new Float:plPos[3];
	GetPlayerPos(playerid, plPos[0], plPos[1], plPos[2]);
	foreach(new p: Player)
	{
		if(IsPlayerInRangeOfPoint(p, 5.0, plPos[0], plPos[1], plPos[2]))
		{
			PlayerPlaySound(p, soundid, plPos[0], plPos[1], plPos[2]);
		}
	}
	return true;
}

stock SendClientMessageToAllEx(color, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	/*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
	*/
	if ((args = numargs()) == 2)
	{
	    SendClientMessageToAll(color, text);
	}
	else
	{
		while (--args >= 2)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessageToAll(color, str);

		#emit RETN
	}
	return 1;
}

stock Slap(playerid)
{
   new Float:x, Float:y, Float:z;
   GetPlayerPos(playerid, x, y, z); SetPlayerPos(playerid,x,y,z+1);
   return 1;
}