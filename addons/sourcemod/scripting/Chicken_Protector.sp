
#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Levi2288"
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>
#include <smlib>
//#include <sdkhooks>

//#pragma newdecls required

ConVar sm_enable_cp, sm_enable_cpdamage, sm_damage_cp;

public Plugin myinfo = 
{
	name = "Chicken Protector",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = "https://github.com/Levi2288"
};

public void OnPluginStart()
{
	sm_enable_cp = CreateConVar("sm_enable_cp", "1", "Enable Chicken Protector");
	sm_enable_cpdamage = CreateConVar("sm_enable_cpdamage", "1", "Punish players shoot they chickens?");
	sm_damage_cp = CreateConVar("sm_damage_cp", "10", "Chicken Damage (100 = Instant Kill)");
	
	AutoExecConfig(true, "Levi2288_chicken_protector");
}
	
public void OnEntityCreated(int entity, const char[] classname)
{
	if(StrEqual(classname, "chicken", false))
	{
		SDKHook(entity, SDKHook_OnTakeDamage, OnTakeDamage);
	}
}


public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype) 
{
	char name[MAX_NAME_LENGTH];
	GetClientName(attacker, name, sizeof(name));
	if(attacker > 0 && attacker <= MaxClients && sm_enable_cp)
	{
		PrintToChat(attacker, "[\x03Chicken Protector\x01] Please dont \x02hurt\x01 the chickens.");
		damage = 0.0;
		if (sm_enable_cpdamage)
		{
			if (GetClientHealth(attacker) < sm_damage_cp.IntValue)
			{
				PrintToChatAll("[\x03Chicken Protector\x01] %s got killed by a chicken.", name);
			}
			Entity_Hurt(attacker, sm_damage_cp.IntValue, victim, 7);
		}
		return Plugin_Changed;
	}
	return Plugin_Continue;
}