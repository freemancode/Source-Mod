//////////////////////////
//G L O B A L  S T U F F//
//////////////////////////
#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>
#include <morecolors>

#pragma semicolon 1

#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR "Mr. Freeman"
#define PLUGIN_NAME "[LG] Legacy Gamerz - !join & !register"
#define PLUGIN_URL "http://legacygamerz.com"
#define PLUGIN_DESCRIPTION "Join Steam Group / Register on Forums"

////////////////////////
//P L U G I N  I N F O//
////////////////////////
public Plugin:myinfo =
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
}

/////////////////////////////
// P L U G I N   S T A R T //
////////////////////////////
public OnPluginStart()
{
	CreateConVar("LG_version", PLUGIN_VERSION, "Plugin version", FCVAR_NOTIFY);

	/*Other*/
	AutoExecConfig();
	LoadTranslations("common.phrases");
	
	RegConsoleCmd("sm_join", Command_Join);
}

/////////////////////////////
// J O I N   C O M M A N D //
/////////////////////////////
public Action:Command_Join(client, args)
{
	if(IsClientInGame(client))
	{
		decl String:url[256];
		Format(url, sizeof(url), "http://steamcommunity.com/groups/LegacyGamerz");
		new Handle:Kv = CreateKeyValues("data");
		KvSetString(Kv, "title", "");
		KvSetString(Kv, "type", "2");
		KvSetString(Kv, "msg", url);
		KvSetNum(Kv, "customsvr", 1);
		ShowVGUIPanel(client, "info", Kv);
		CloseHandle(Kv);
		CPrintToChat(client, "{black}[{fullred}LG{black}]{default} Thank you for joining our steam group.");
	}
	else
	{
		ReplyToCommand(client, "This only work when you are connect to our server");
	}
}
