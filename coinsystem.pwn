/*
								   _____      _                       _                        __ 
								  / ____|    (_)                     | |                      /_ |
								 | |     ___  _ _ __    ___ _   _ ___| |_ ___ _ __ ___   __   _| |
								 | |    / _ \| | '_ \  / __| | | / __| __/ _ \ '_ ` _ \  \ \ / / |
								 | |___| (_) | | | | | \__ \ |_| \__ \ ||  __/ | | | | |  \ V /| |
								  \_____\___/|_|_| |_| |___/\__, |___/\__\___|_| |_| |_|   \_/ |_| By:B3x7K
											     __/ |                                
											    |___/                                    
Description:  

	This script has been developed now by B3x7K, and i dont care about it.
	Well i thing thats it
	Enjoy :)
	
	Oh i'm forget, this version is most responsible for anyone who want to give their coin
	to other people whitch you can easily use this in your gamemode
	And i'm make this for firstime, so if you fond any bugs, please contact me or reply in comment section on samp/facebook
	
	Thank you for downloading my project.
	- B3x7K

	Things to consider:
    *  Always read what i say in comment section, and if you need some suggestion
		or if you want to ask something about this script please let me know
		cuz any your question or suggestion it's makes me feels better :3
		
		Well i think thats it, enjoy :)
	  
	Bug List:
	* I've been try this before, just lemme know if you found any bugs
		and i'll try to fix it ASAP

	Credits:
	* B3x7K

	Copyright(c) 2014-2018 B3x7K (All rights reserved)
*/

//"THIS CODE CAN BE COPYPASTED, BUT THIS CODE CAN'T WORK WITH YOUR IDEA" - B3x7K.//

#define FILTERSCRIPT

//Includes
#include <a_samp>
#include <foreach>
#include <streamer>
#include <sscanf2>
#include <YSI\y_ini>
#include <zcmd>

//User Path
#define UserPathuuuu "/CoinSystem/%s.ini"

//DONT TOUCH IF YOU DONT UNDERSTAND >:(
#define KasihTauGembel(%0,%1) \
	SendClientMessage(%0,-1,%1)

#define jika(%0) \ 
	if(%0)
	
#define tapi \
	else

#define JikaPlayerAdaDiPosisi(%0,%1,%2,%3) \
	if(IsPlayerInRangeOfPoint(playerid,%0,%1,%2,%3))

#define JikaPlayerBukanDiPosisi(%0,%1,%2,%3) \
	if(!IsPlayerInRangeOfPoint(playerid,%0,%1,%2,%3))

#define PlayerTerkoneksi(%0) \
	IsPlayerConnected(%0)

#define BesarText(%0) \
	sizeof(%0)

#define PanjangText(%0) \
	strlen(%0)
	
#define KasihTauTextdraw(%0,%1) \
	TextDrawShowForPlayer(%0,%1)

#define UpdateStringTextdraw(%0,%1) \
	TextDrawSetString(%0,%1)
	
#define UmpetinTextdrawnya(%0,%1) \
	TextDrawHideForPlayer(%0,%1)

//Enums
enum GembelInfo 
{
	GembelKoin
};

//New's stuff
new 
	GembelData[MAX_PLAYERS][GembelInfo],
	pelername[24];

new Text:GembelItem;

//Forwards
forward LoadUser_data(playerid,name[],value[]);

// Public
public OnFilterScriptInit()
{
	GembelItem = TextDrawCreate(18.725851, 327.083312, "My Coin: ~w~0");
	TextDrawLetterSize(GembelItem, 0.400000, 1.600000);
	TextDrawAlignment(GembelItem, 1);
	TextDrawColor(GembelItem, 16711935);
	TextDrawSetShadow(GembelItem, 0);
	TextDrawBackgroundColor(GembelItem, 255);
	TextDrawFont(GembelItem, 1);
	TextDrawSetProportional(GembelItem, 1);

	print("\n---------------------------------------");
	print(" Coin System v1 By B3x7k Loaded Master :)");
	print("---------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	foreach(new i : Player)
		return UmpetinTextdrawnya(i, GembelItem);

	print("\n--------------------------------------");
	print("   Coin System v1 By B3x7k Unloaded :(  ");
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	new 
		coin[122];

	KasihTauTextdraw(playerid, GembelItem);

	GembelData[playerid][GembelKoin] = 0;
	jika(fexist(UserPath(playerid))) 
	{
		UmpetinTextdrawnya(playerid, GembelItem);
		INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
		format(coin, sizeof(coin), "My Coin: ~w~%d", GembelData[playerid][GembelKoin]);
		UpdateStringTextdraw(GembelItem, coin);
		KasihTauTextdraw(playerid, GembelItem);
	}
	tapi
	{
		DuarItem(playerid);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SimpanKoin(playerid);
	GembelData[playerid][GembelKoin] = 0;
	return 1;
}

public OnPlayerUpdate(playerid)
{
	new 
		coin[122];

    UmpetinTextdrawnya(playerid, GembelItem);
    format(coin, sizeof(coin), "My Coin: ~w~%d", GembelData[playerid][GembelKoin]);
    UpdateStringTextdraw(GembelItem, coin);
    KasihTauTextdraw(playerid, GembelItem);
    return 1;
}

public LoadUser_data(playerid,name[],value[]) 
{
    INI_Int("CoinSystem", GembelData[playerid][GembelKoin]); // Get user ini data.
    return 1;
}

//Begin Command's
CMD:kasihgembelkoin(playerid, params[])
{
	new
		targetid,
		jumlah,
		str[220],
		alasan[52];

	jika(sscanf(params, "uis[25]",targetid, jumlah, alasan))
		return KasihTauGembel(playerid, "{787878}SYNTAX:{FFFFFF} /kasihgembelkoin [playerid] [jumlah] [alasan lo kasih dia koin]");
	
	jika(!PlayerTerkoneksi(targetid))
		return KasihTauGembel(playerid, "{FF0000}ERROR:{FFFFFF} Dia ga online cok");
		
	jika(PanjangText(alasan) > 52)
		return KasihTauGembel(playerid, "{FF0000}ERROR:{FFFFFF} Jangan kepanjangan woi textnya, 50 kek minimal");
	
	GembelData[playerid][GembelKoin] += jumlah;
	
	format(str, BesarText(str),  "{FFF000}COIN:{FFFFFF} Player %s dikasih koin sama %s sebanyak %d karena %s", PlayerName(targetid), PlayerName(playerid), jumlah, alasan);
	KasihTauGembel(playerid, str);
	return 1;
}

CMD:kurangigembelkoin(playerid, params[])
{
	new
		targetid,
		jumlah,
		str[220],
		alasan[52];
		
	jika(sscanf(params, "uis[25]",targetid, jumlah, alasan))
		return KasihTauGembel(playerid, "{787878}SYNTAX:{FFFFFF}/kurangigembelkoin [playerid] [jumlah] [alasan lo kurangi dia koin]");
	
	jika(!PlayerTerkoneksi(targetid))
		return KasihTauGembel(playerid, "{FF0000}ERROR:{FFFFFF} Dia ga online cok");
		
	jika(PanjangText(alasan) > 52)
		return KasihTauGembel(playerid, "{FF0000}ERROR:{FFFFFF} Jangan kepanjangan woi textnya, 50 kek minimal");
	
	GembelData[playerid][GembelKoin] -= jumlah;
	
	format(str, BesarText(str), "{FFF000}COIN:{FFFFFF} Player %s dikurangin koinnya sama %s sebanyak %d karena %s", PlayerName(targetid), PlayerName(playerid), jumlah, alasan);
	KasihTauGembel(playerid, str);
	return 1;
}

CMD:cekgembelkoin(playerid, params[])
{
	new
		targetid,
		str[200];

	jika(sscanf(params, "u", targetid))
		return KasihTauGembel(playerid, "{787878}SYNTAX:{FFFFFF} /cekgembelkoin [playerid]");
		
	jika(!PlayerTerkoneksi(targetid))
		return KasihTauGembel(playerid, "{FF0000}ERROR:{FFFFFF} Dia ga online cok");
			
	format(str, BesarText(str), "{FFF000}COIN:{FFFFFF} %s mempunyai koin sebanyak %d", PlayerName(targetid), GembelData[targetid][GembelKoin]);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Coin Status", str, "Close", "");
	return 1;
}

CMD:belipakekoin(playerid, params[])
{
	JikaPlayerAdaDiPosisi(7.0, -1609.62622, 778.24481, 25.41070) //Ganti coordinatenya berserta range nya sesuka kalian
	{
		KasihTauGembel(playerid, "{00DCFF}SERVER:{FFFFFF} Selamat datang di toko loli onii-chan, Mau beli apa mas ?");
		// taruh kode kamu disini //
	}
	tapi
	{
		KasihTauGembel(playerid, "{FF0000}ERROR:{FFFFFF} Kamu tidak berada di tempat beli koin >:(");
	}
	return 1;
}

CMD:gotopos(playerid, params[])
{
	new
		Float:x,
		Float:y,
		Float:z;

	jika(sscanf(params, "fff", x,y,z))
		return KasihTauGembel(playerid, "{787878}SYNTAX:{FFFFFF} /gotopos [x] [y] [z]");
		
	SetPlayerPos(playerid, x, y, z);
	return 1;
}

//Stocks
stock UserPath(playerid) 
{
    new 
		string[128];

    format(string,BesarText(string),UserPathuuuu,PlayerName(playerid));
    return string;
}

stock PlayerName(playerid) 
{
	GetPlayerName(playerid, pelername, 24);
	return pelername;
}

stock SimpanKoin(playerid) 
{
	jika(fexist(UserPath(playerid))) 
	{
		new 
			INI:File = INI_Open(UserPath(playerid));
			
		INI_SetTag(File,"CoinSystem");
		INI_WriteInt(File,"CoinSystem", GembelData[playerid][GembelKoin]);
		INI_Close(File);
	}
	return 1;
}

stock DuarItem(playerid) 
{
	new 
		INI:File = INI_Open(UserPath(playerid));
		
	INI_SetTag(File,"CoinSystem");
	INI_WriteInt(File,"CoinSystem",0);
	INI_Close(File);
	return 1;
}
