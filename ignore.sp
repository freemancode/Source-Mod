#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <adminmenu>
#include <morecolors>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo = 
{
	name = "Player Mute List",
	author = "Mr. Freeman",
	description = "Client Mute Player Option (Player List)",
	version = PLUGIN_VERSION,
	url = ":)"
}

new Handle:g_hMenuMain = INVALID_HANDLE;

public OnPluginStart() 
{	
    LoadTranslations("common.phrases");
    CreateConVar("sm_ignore_version", PLUGIN_VERSION, "Version of Self-Mute", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
    RegAdminCmd("sm_ignore", OpenMenuCmd, 0, "Open's Mute/UnMute Player Menu");
}


public OnClientPutInServer(client)
{
	new maxplayers = GetMaxClients();
	for (new id = 1; id <= maxplayers ; id++){
        if (id != client && IsClientInGame(id)){
            SetListenOverride(id, client, Listen_Yes);
        }
    }
}

public OnConfigsExecuted()
{
    g_hMenuMain = CreateMenu(MenuMainHandler);
    SetMenuTitle(g_hMenuMain, "PB Fortess Exclusive");
    AddMenuItem(g_hMenuMain, "1", "Mute Player");
    AddMenuItem(g_hMenuMain, "2", "Unmute Player");
}

public Action:OpenMenuCmd(client, args)
{
    if (client == 0)
    {
        ReplyToCommand(client, "Cannot use command from RCON.");
        return Plugin_Handled;
    }
    
    DisplayMenuSafely(g_hMenuMain, client);
    return Plugin_Handled;
}

public MenuMainHandler(Handle:menu, MenuAction:action, param1, param2)
{
    if (action == MenuAction_Select && IsClientInGame(param1))
    {
        switch (param2)
        {
            case 0:
            {
                 DisplayMuteMenu(param1);                
            }
            case 1:
            {
				 DisplayUnMuteMenu(param1);
            }
        }
    }
}

stock DisplayMenuSafely(Handle:menu, client)
{
    if (client != 0)
    {
        if (menu == INVALID_HANDLE)
        {
            PrintToConsole(client, "ERROR: Unable to open menu.");
        }
        else
        {
            DisplayMenu(menu, client, MENU_TIME_FOREVER);
        }
    }
}

public OnMapEnd()
{
    if (g_hMenuMain != INVALID_HANDLE)
    {
        CloseHandle(g_hMenuMain);
        g_hMenuMain = INVALID_HANDLE;
    }
}  

stock DisplayMuteMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandler_MuteMenu);
	SetMenuTitle(menu, "Choose a player to mute");
	SetMenuExitBackButton(menu, true);
	
	AddTargetsToMenu2(menu, 0, COMMAND_FILTER_NO_BOTS);
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public MenuHandler_MuteMenu(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
		case MenuAction_Select:
		{
			decl String:info[32];
			new target;
			
			GetMenuItem(menu, param2, info, sizeof(info));
			new userid = StringToInt(info);

			if ((target = GetClientOfUserId(userid)) == 0)
			{
				CPrintToChat(param1, "{black}[{fullred}Ignore{black}]{default} Player no longer available");
			}
			else
			{
				muteTargetedPlayer(param1, target);
			}
		}
	}
}

public muteTargetedPlayer(client, target)
{
    SetListenOverride(client, target, Listen_No);
    decl String:chkNick[256];
    GetClientName(target, chkNick, sizeof(chkNick));
    CPrintToChat(client, "{black}[{fullred}Ignore{black}]{default} You have muted:{goldenrod} %s", chkNick);
}

stock DisplayUnMuteMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandler_UnMuteMenu);
	SetMenuTitle(menu, "Choose a player to unmute");
	SetMenuExitBackButton(menu, true);
	
	AddTargetsToMenu2(menu, 0, COMMAND_FILTER_NO_BOTS);
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public MenuHandler_UnMuteMenu(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
		case MenuAction_Select:
		{
			decl String:info[32];
			new target;
			
			GetMenuItem(menu, param2, info, sizeof(info));
			new userid = StringToInt(info);

			if ((target = GetClientOfUserId(userid)) == 0)
			{
				CPrintToChat(param1, "{black}[{fullred}Ignore{black}]{default} Player no longer available");
			}
			else
			{
				unMuteTargetedPlayer(param1, target);
			}
		}
	}
}

public unMuteTargetedPlayer(client, target)
{
    SetListenOverride(client, target, Listen_Yes);
    decl String:chkNick[256];
    GetClientName(target, chkNick, sizeof(chkNick));
    CPrintToChat(client, "{black}[{fullred}Ignore{black}]{default} You have unmuted:{goldenrod} %s", chkNick);
}
