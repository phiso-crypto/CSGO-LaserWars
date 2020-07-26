#pragma semicolon 1
#define DEBUG

#define PLUGIN_AUTHOR "quantum"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <clientprefs>
#include <cstrike>
#include <emitsoundany>
#include <warden>

public Plugin myinfo = 
{
	name = "[JB] Lazer Savaslari", 
	author = PLUGIN_AUTHOR, 
	description = "Lazer Savaşları jailbreak plugini", 
	version = PLUGIN_VERSION, 
	url = "https://steamcommunity.com/id/quascave"
};

int takimNumarasi[MAXPLAYERS + 1];
int oyuncuTakimDurumu[MAXPLAYERS + 1];
int g_iBeam = -1;

int SilahDurumu;
int TakimDurumu;
bool MuzikDurumu;
bool SinirsizMermi;
bool Sekmeme;
bool EkranEfekt;

bool Lazer_Savaslari_Aktif;
bool TakimYapildi;
bool M4A1;
bool USP;
bool MP5SD;

Handle SekmemeHandle;
Handle h_timer = INVALID_HANDLE;
Handle g_Model;

public void OnMapStart()
{
	char mapismi[128];
	GetCurrentMap(mapismi, sizeof(mapismi));
	char EklentiIsmi[128];
	GetPluginFilename(INVALID_HANDLE, EklentiIsmi, sizeof(EklentiIsmi));
	if (StrContains(mapismi, "jb_", false) || StrContains(mapismi, "jail_", false) || StrContains(mapismi, "ba_jail", false))
	{
		ServerCommand("sm plugins unload %s", EklentiIsmi);
	}
	else
	{
		PrintToServer("!-------Lazer Savaslari eklentisi basari ile calistirildi-------!");
		
		AddFileToDownloadsTable("sound/misc/LaserWarsSounds/Countdown/3.mp3");
		PrecacheSoundAny("misc/LaserWarsSounds/Countdown/3.mp3", false);
		AddFileToDownloadsTable("sound/misc/LaserWarsSounds/Countdown/2.mp3");
		PrecacheSoundAny("misc/LaserWarsSounds/Countdown/2.mp3", false);
		AddFileToDownloadsTable("sound/misc/LaserWarsSounds/Countdown/1.mp3");
		PrecacheSoundAny("misc/LaserWarsSounds/Countdown/1.mp3", false);
		AddFileToDownloadsTable("sound/misc/LaserWarsSounds/Ambiance/starwars.mp3");
		PrecacheSoundAny("misc/LaserWarsSounds/Ambiance/starwars.mp3", false);
		AddFileToDownloadsTable("sound/misc/LaserWarsSounds/End/end.mp3");
		PrecacheSoundAny("misc/LaserWarsSounds/End/end.mp3", false);
		AddFileToDownloadsTable("sound/misc/LaserWarsSounds/Start/start.mp3");
		PrecacheSoundAny("misc/LaserWarsSounds/Start/start.mp3", false);
		AddFileToDownloadsTable("materials/laserwars/lazer.vmt");
		AddFileToDownloadsTable("materials/laserwars/lazer.vtf");
		
		g_iBeam = PrecacheModel("materials/laserwars/lazer.vmt", true);
		
		AddFileToDownloadsTable("sound/misc/LaserWarsSounds/Weapon/1.mp3");
		PrecacheSound("misc/LaserWarsSounds/Weapon/1.mp3", false);
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_cape_normal.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_glove_c.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_glove_c.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_glove_normal.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_helmet_c.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_helmet_c.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_helmet_env.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_helmet_normal.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_innercape_c.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_innercape_inv.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_innercape_normal.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/black.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_body_c.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_body_c.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_body_evn.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_body2_normal.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_cape_c.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_cape_c.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/vader/t_hero_jedi_darthvader_cape_inv.vmt");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/vader/vader.dx90.vtx");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/vader/vader.mdl");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/vader/vader.phy");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/vader/vader.vvd");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/vader/vader_arms.dx90.vtx");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/vader/vader_arms.mdl");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/vader/vader_arms.vvd");
		PrecacheModel("models/player/custom_player/kuristaja/vader/vader_arms.mdl", false);
		PrecacheModel("models/player/custom_player/kuristaja/vader/vader.mdl", false);
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_body.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_body_normal.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_body2.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_hands.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_hands.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_hands_normal.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_hands2.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_helmet.vmt");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_helmet.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_helmet_normal.vtf");
		AddFileToDownloadsTable("materials/models/player/kuristaja/stormtrooper/stormtrooper_body.vmt");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/stormtrooper/stormtrooper.vvd");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/stormtrooper/stormtrooper.dx90.vtx");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/stormtrooper/stormtrooper.mdl");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/stormtrooper/stormtrooper.phy");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/stormtrooper/stormtrooper_arms.dx90.vtx");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/stormtrooper/stormtrooper_arms.mdl");
		AddFileToDownloadsTable("models/player/custom_player/kuristaja/stormtrooper/stormtrooper_arms.vvd");
		PrecacheModel("models/player/custom_player/kuristaja/stormtrooper/stormtrooper_arms.mdl", false);
		PrecacheModel("models/player/custom_player/kuristaja/stormtrooper/stormtrooper.mdl", false);
	}
}

public void OnPluginStart()
{
	RegConsoleCmd("sm_laserwar", Lazer_Savaslari);
	RegConsoleCmd("sm_lws", Lazer_Savaslari);
	RegConsoleCmd("sm_laserdur", Lazer_Savaslari_Durdur);
	
	g_Model = RegClientCookie("LWS_Model", "Oyuncuların modellerinin saklandığı cookie", CookieAccess_Protected);
	
	HookEvent("round_start", El_Basi_Sonu);
	HookEvent("round_end", El_Basi_Sonu);
	HookEvent("player_death", Oyuncu_Oldugunde);
	HookEvent("bullet_impact", Event_OnBulletImpact);
	
	AddNormalSoundHook(Hook_NormalSound);
	
	SekmemeHandle = CreateConVar("sm_lssekmeme", "0", "Mermi Sekmeme");
	HookConVarChange(SekmemeHandle, OnConVarChanged);
	
	AddTempEntHook("Shotgun Shot", Hook_BlockTE);
	AddTempEntHook("Blood Sprite", Hook_BlockTE);
}

public void OnClientPutInServer(int client)
{
	if (!AreClientCookiesCached(client))
	{
		SetClientCookie(client, g_Model, "");
	}
}

public Action Lazer_Savaslari(int client, int args)
{
	Lazer_SavaslariFirstMenu(client);
}

public Action Lazer_SavaslariFirstMenu(int client)
{
	if (warden_iswarden(client) || CheckCommandAccess(client, "generic_admin", 32, false))
	{
		Handle menuhandle = CreateMenu(Lazer_Savaslari_Silah, MENU_ACTIONS_DEFAULT);
		SetMenuTitle(menuhandle, /*----------------------------------\n*/"           Lazer Savaşları         \n----------------------------------");
		char secenek[128];
		
		if (!Lazer_Savaslari_Aktif)
		{
			AddMenuItem(menuhandle, "Baslat", "       ! Oyunu Başlat !\n----------------------------------\n  ");
		}
		else
		{
			AddMenuItem(menuhandle, "Durdur", "       ! Oyunu Durdur !\n----------------------------------\n  ");
		}
		
		if (SilahDurumu == 0)
		{
			Format(secenek, sizeof(secenek), "|Silah: M4A1-S");
			M4A1 = true;
			USP = false;
			MP5SD = false;
		}
		else if (SilahDurumu == 1)
		{
			Format(secenek, sizeof(secenek), "|Silah: USP-S");
			M4A1 = false;
			USP = true;
			MP5SD = false;
		}
		else if (SilahDurumu == 2)
		{
			Format(secenek, sizeof(secenek), "|Silah: MP5-SD");
			M4A1 = false;
			USP = false;
			MP5SD = true;
		}
		AddMenuItem(menuhandle, "sec1", secenek, ITEMDRAW_DEFAULT);
		
		if (TakimDurumu == 0)
		{
			Format(secenek, sizeof(secenek), "|Takım Durumu: Takımlı");
		}
		else if (TakimDurumu == 1)
		{
			Format(secenek, sizeof(secenek), "|Takım Durumu: Herkes Tek");
		}
		
		AddMenuItem(menuhandle, "sec2", secenek, ITEMDRAW_DEFAULT);
		
		if (MuzikDurumu)
		{
			Format(secenek, sizeof(secenek), "|Müzik Durumu: Aktif");
		}
		else
		{
			Format(secenek, sizeof(secenek), "|Müzik Durumu: Deaktif");
		}
		
		AddMenuItem(menuhandle, "sec3", secenek, ITEMDRAW_DEFAULT);
		
		if (SinirsizMermi)
		{
			Format(secenek, sizeof(secenek), "|Sinirsiz Mermi: Aktif");
		}
		else
		{
			Format(secenek, sizeof(secenek), "|Sinirsiz Mermi: Deaktif");
		}
		
		AddMenuItem(menuhandle, "sec4", secenek, ITEMDRAW_DEFAULT);
		
		if (Sekmeme)
		{
			Format(secenek, sizeof(secenek), "|Mermi Sekmeme: Aktif");
		}
		else
		{
			Format(secenek, sizeof(secenek), "|Mermi Sekmeme: Deaktif");
		}
		
		AddMenuItem(menuhandle, "sec5", secenek, ITEMDRAW_DEFAULT);
		
		if (EkranEfekt)
		{
			Format(secenek, sizeof(secenek), "|Ekran Efekt: Aktif");
		}
		else
		{
			Format(secenek, sizeof(secenek), "|Ekran Efekt: Deaktif");
		}
		
		AddMenuItem(menuhandle, "sec6", secenek, ITEMDRAW_DEFAULT);
		
		SetMenuPagination(menuhandle, 0);
		SetMenuExitBackButton(menuhandle, false);
		SetMenuExitButton(menuhandle, true);
		DisplayMenu(menuhandle, client, MENU_TIME_FOREVER);
	}
	else
	{
		PrintToChat(client, " \x02[LazerSavaşları] \x01Lazer Savaşını sadece \x0CKomutçular \x01başlatabilir!");
	}
	return Plugin_Continue;
}

public Lazer_Savaslari_Silah(Handle menuhandle, MenuAction action, int client, int position)
{
	if (action == MenuAction_Select)
	{
		char Item[32];
		GetMenuItem(menuhandle, position, Item, sizeof(Item));
		if (warden_iswarden(client) || CheckCommandAccess(client, "generic_admin", 32, false))
		{
			if (StrEqual(Item, "Baslat", true))
			{
				if (GetTeamClientCount(CS_TEAM_T) == 1)
				{
					PrintCenterText(client, " \x02[LazerSavaşları] \x0E%N \x01yaşayan sadece 1 oyuncu var.", client);
				}
				for (int i = 1; i < MaxClients; i++)
				{
					if (IsClientInGame(i) && GetClientTeam(i) == CS_TEAM_T)
					{
						ModelKaydet(i);
					}
				}
				if (TakimDurumu == 0)
				{
					TakimYapildi = true;
					int yasayanTSayisi;
					for (int i = 1; i <= MaxClients; i++)
					{
						oyuncuTakimDurumu[i] = 0;
						if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i) && GetClientTeam(i) == CS_TEAM_T && IsPlayerAlive(i))
						{
							yasayanTSayisi++;
						}
					}
					if (yasayanTSayisi % 2 == 1)
					{
						PrintToChat(client, " \x02[LazerSavaşları] \x01Bu komutu kullanabilmek için yaşayan \x0ET Takımı Sayısı \x01çift sayıda olmalıdır.");
					}
					if (yasayanTSayisi % 2 == 0 && yasayanTSayisi != 0)
					{
						int j;
						int i = 1;
						while (i <= MaxClients)
						{
							if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i) && GetClientTeam(i) == CS_TEAM_T && IsPlayerAlive(i))
							{
								takimNumarasi[i] = j % 2 + 1;
								oyuncuTakimDurumu[i] = j % 2 + 1;
								j++;
							}
							i++;
						}
						i = 1;
						while (i <= MaxClients)
						{
							if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
							{
								if (GetClientTeam(i) == CS_TEAM_T && IsPlayerAlive(i))
								{
									if (takimNumarasi[i] == 1)
									{
										PrintCenterText(i, "Takımınız: !! Karanlık Takım !!");
										Ekran_Renk_Olustur(i, 0, 0, 0, 160);
									}
									if (takimNumarasi[i] == 2)
									{
										PrintCenterText(i, "Takımınız: !! Beyaz Takım !!");
										Ekran_Renk_Olustur(i, 255, 255, 255, 160);
									}
								}
							}
							i++;
						}
						i = 1;
						while (i <= MaxClients)
						{
							if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
							{
								if (GetClientTeam(i) == CS_TEAM_T && IsPlayerAlive(i))
								{
									if (takimNumarasi[i] == 1)
									{
										SetEntityModel(i, "models/player/custom_player/kuristaja/vader/vader.mdl");
										SetEntPropString(i, Prop_Send, "m_szArmsModel", "models/player/custom_player/kuristaja/vader/vader_arms.mdl");
										Handle hHudText = CreateHudSynchronizer();
										SetHudTextParams(-1.0, -0.3, 3.0, 255, 0, 0, 0, 0, 6.0, 0.1, 0.2);
										ShowSyncHudText(i, hHudText, "KARANLIK TARAFTASIN!");
										delete hHudText;
										PrintToChat(i, " \x02[LazerSavaşları] \x01Takımınız: ! KARANLIK TARAF !");
									}
									if (takimNumarasi[i] == 2)
									{
										SetEntityModel(i, "models/player/custom_player/kuristaja/stormtrooper/stormtrooper.mdl");
										SetEntPropString(i, Prop_Send, "m_szArmsModel", "models/player/custom_player/kuristaja/stormtrooper/stormtrooper_arms.mdl");
										Handle hHudText = CreateHudSynchronizer();
										SetHudTextParams(-1.0, -0.3, 3.0, 0, 0, 255, 0, 0, 6.0, 0.1, 0.2);
										ShowSyncHudText(i, hHudText, "BEYAZ TARAFTASIN!");
										delete hHudText;
										PrintToChat(i, " \x02[LazerSavaşları] \x01Takımınız: ! BEYAZ TARAF !");
									}
								}
							}
							i++;
						}
						h_timer = CreateTimer(1.0, GeriSayim3, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
						Lazer_Savaslari_Aktif = true;
					}
				}
				else if (TakimDurumu == 1)
				{
					Takim_Kapat();
					Lazer_Savaslari_Aktif = true;
					h_timer = CreateTimer(1.0, GeriSayim3, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
					for (int i = 1; i <= MaxClients; i++)
					{
						if (IsClientInGame(i) && GetClientTeam(i) == CS_TEAM_T)
						{
							SetEntityModel(i, "models/player/custom_player/kuristaja/stormtrooper/stormtrooper.mdl");
							SetEntPropString(i, Prop_Send, "m_szArmsModel", "models/player/custom_player/kuristaja/stormtrooper/stormtrooper_arms.mdl", 0);
							Handle hHudText = CreateHudSynchronizer();
							SetHudTextParams(-1.0, -0.3, 3.0, 0, 0, 255, 0, 0, 6.0, 0.1, 0.2);
							ShowSyncHudText(i, hHudText, "HERKES TEK !");
							delete hHudText;
							Ekran_Renk_Olustur(i, 255, 255, 255, 160);
							PrintToChat(i, " \x02[LazerSavaşları] \x01Herkes Tek !");
						}
					}
				}
			}
			else if (StrEqual(Item, "Durdur", true))
			{
				PrintToChatAll(" \x02[LazerSavaşları] \x01Lazer Savaşları \x0E%N \x01tarafından durduruldu!", client);
				Takim_Kapat();
				SetCvar("sv_infinite_ammo", 0);
				SetCvar("mp_teammates_are_enemies", 0);
				SetCvar("sm_lssekmeme", 0);
				StopSoundAny(-2, 0, "misc/LaserWarsSounds/Ambiance/starwars.mp3");
				EmitSoundToAllAny("misc/LaserWarsSounds/End/end.mp3", -2, 0, 100, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
				Lazer_Savaslari_Aktif = false;
				M4A1 = false;
				USP = false;
				MP5SD = false;
				for (int i = 1; i < MaxClients; i++)
				{
					if (IsClientInGame(i) && GetClientTeam(i) == CS_TEAM_T)
					{
						ModelVer(i);
						Silahlari_Sil(i);
						GivePlayerItem(i, "weapon_knife");
						if (EkranEfekt)
						{
							SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
						}
					}
				}
				if (h_timer != INVALID_HANDLE)
				{
					h_timer = INVALID_HANDLE;
				}
			}
			else if (StrEqual(Item, "sec1", true))
			{
				if (SilahDurumu == 0)
				{
					SilahDurumu = 1;
				}
				else if (SilahDurumu == 1)
				{
					SilahDurumu = 2;
				}
				else if (SilahDurumu == 2)
				{
					SilahDurumu = 0;
				}
				Lazer_SavaslariFirstMenu(client);
			}
			else if (StrEqual(Item, "sec2", true))
			{
				if (TakimDurumu == 0)
				{
					TakimDurumu = 1;
				}
				else if (TakimDurumu == 1)
				{
					TakimDurumu = 0;
				}
				Lazer_SavaslariFirstMenu(client);
			}
			else if (StrEqual(Item, "sec3", true))
			{
				if (MuzikDurumu)
				{
					MuzikDurumu = false;
				}
				else if (!MuzikDurumu)
				{
					MuzikDurumu = true;
				}
				Lazer_SavaslariFirstMenu(client);
			}
			else if (StrEqual(Item, "sec4", true))
			{
				if (SinirsizMermi)
				{
					SinirsizMermi = false;
				}
				else if (!SinirsizMermi)
				{
					SinirsizMermi = true;
				}
				Lazer_SavaslariFirstMenu(client);
			}
			else if (StrEqual(Item, "sec5", true))
			{
				if (Sekmeme)
				{
					Sekmeme = false;
				}
				else if (!Sekmeme)
				{
					Sekmeme = true;
				}
				Lazer_SavaslariFirstMenu(client);
			}
			else if (StrEqual(Item, "sec6", true))
			{
				if (EkranEfekt)
				{
					EkranEfekt = false;
				}
				else if (!EkranEfekt)
				{
					EkranEfekt = true;
				}
				Lazer_SavaslariFirstMenu(client);
			}
		}
		else
		{
			ReplyToCommand(client, " \x02[LazerSavaşları] \x0ELazer Savaşını \x01Sadece \x0CKomutçular \x01Yapabilir!");
		}
	}
	else if (action == MenuAction_End)
	{
		delete menuhandle;
	}
}

public Action GeriSayim3(Handle Timer, any data)
{
	int client = GetClientOfUserId(data);
	h_timer = CreateTimer(1.0, GeriSayim2, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	EmitSoundToAllAny("misc/LaserWarsSounds/Countdown/3.mp3", -2, 0, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
	int i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			PrintHintText(i, "Lazer Savaşlarının Başlamasına Son 3 Saniye");
		}
		i++;
	}
	return Plugin_Continue;
}

public Action GeriSayim2(Handle Timer, any data)
{
	int client = GetClientOfUserId(data);
	h_timer = CreateTimer(1.0, GeriSayim1, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	EmitSoundToAllAny("misc/LaserWarsSounds/Countdown/2.mp3", -2, 0, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
	int i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			PrintHintText(i, "Lazer Savaşlarının Başlamasına Son 2 Saniye");
		}
		i++;
	}
	return Plugin_Continue;
}

public Action GeriSayim1(Handle Timer, any data)
{
	int client = GetClientOfUserId(data);
	h_timer = CreateTimer(1.0, Baslat, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	EmitSoundToAllAny("misc/LaserWarsSounds/Countdown/1.mp3", -2, 0, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
	int i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			PrintHintText(i, "Lazer Savaşlarının Başlamasına Son 1 Saniye");
		}
		i++;
	}
	return Plugin_Continue;
}

public Action Baslat(Handle Timer)
{
	EmitSoundToAllAny("misc/LaserWarsSounds/Start/start.mp3", -2, 0, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
	SetCvar("mp_teammates_are_enemies", 1);
	if (Sekmeme)
	{
		SetCvar("sm_lssekmeme", 1);
	}
	if (SinirsizMermi)
	{
		SetCvar("sv_infinite_ammo", 1);
	}
	if (MuzikDurumu)
	{
		EmitSoundToAllAny("misc/LaserWarsSounds/Ambiance/starwars.mp3", -2, 0, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
	}
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == CS_TEAM_T && IsPlayerAlive(i))
		{
			SDKHook(i, SDKHook_OnTakeDamage, OnTakeDamage);
			SetEntityHealth(i, 100);
			if (EkranEfekt)
			{
				SetEntProp(i, Prop_Send, "m_bNightVisionOn", 1);
			}
			Silahlari_Sil(i);
			PrintHintText(i, "Lazer Savaşları BAŞLADI!\n[---!Güç Sizinle Olsun!---]");
		}
	}
	h_timer = INVALID_HANDLE;
	return Plugin_Handled;
}


public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (IsValidClient(attacker) && IsValidClient(victim))
	{
		if (Lazer_Savaslari_Aktif && GetClientTeam(victim) == CS_TEAM_CT && GetClientTeam(attacker) == CS_TEAM_T)
		{
			damage = 0.0;
			return Plugin_Handled;
		}
		else if (Lazer_Savaslari_Aktif && GetClientTeam(victim) == CS_TEAM_T && GetClientTeam(attacker) == CS_TEAM_CT)
		{
			damage = 0.0;
			return Plugin_Handled;
		}
		else if (Lazer_Savaslari_Aktif && GetClientTeam(victim) == CS_TEAM_CT && GetClientTeam(attacker) == CS_TEAM_CT)
		{
			damage = 0.0;
			return Plugin_Handled;
		}
		if (TakimYapildi && Lazer_Savaslari_Aktif && GetClientTeam(victim) == CS_TEAM_T && GetClientTeam(attacker) == CS_TEAM_T)
		{
			int iAttacker;
			if (attacker > 64)
			{
				iAttacker = GetClientOfUserId(attacker);
			}
			else
			{
				iAttacker = attacker;
			}
			if (iAttacker > 0)
			{
				if (oyuncuTakimDurumu[victim] == oyuncuTakimDurumu[iAttacker])
				{
					damage = 0.0;
					return Plugin_Handled;
				}
				if (GetClientTeam(victim) == CS_TEAM_T && GetClientTeam(attacker) && CS_TEAM_T)
				{
					char SilahIsmi[64];
					GetClientWeapon(attacker, SilahIsmi, 64);
					if (StrEqual(SilahIsmi, "weapon_m4a1_silencer", true))
					{
						damage = 25.0;
						return Plugin_Changed;
					}
					else if (StrEqual(SilahIsmi, "weapon_usp_silencer", true))
					{
						damage = 25.0;
						return Plugin_Changed;
					}
					else if (StrEqual(SilahIsmi, "weapon_mp5sd", true))
					{
						damage = 25.0;
						return Plugin_Changed;
					}
				}
			}
		}
		if (!TakimYapildi && Lazer_Savaslari_Aktif)
		{
			if (GetClientTeam(victim) == CS_TEAM_T && GetClientTeam(attacker) == CS_TEAM_T)
			{
				char SilahIsmi[64];
				GetClientWeapon(attacker, SilahIsmi, sizeof(SilahIsmi));
				if (StrEqual(SilahIsmi, "weapon_m4a1_silencer", true))
				{
					damage = 25.0;
					return Plugin_Changed;
				}
				else if (StrEqual(SilahIsmi, "weapon_usp_silencer", true))
				{
					damage = 25.0;
					return Plugin_Changed;
				}
				else if (StrEqual(SilahIsmi, "weapon_mp5sd", true))
				{
					damage = 25.0;
					return Plugin_Changed;
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action Event_OnBulletImpact(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (GetClientTeam(client) == CS_TEAM_T && Lazer_Savaslari_Aktif)
	{
		if (TakimYapildi)
		{
			if (takimNumarasi[client] == 1)
			{
				float m_fOrigin[3];
				float m_fImpact[3];
				GetClientEyePosition(client, m_fOrigin);
				m_fImpact[0] = GetEventFloat(event, "x", 0.0);
				m_fImpact[1] = GetEventFloat(event, "y", 0.0);
				m_fImpact[2] = GetEventFloat(event, "z", 0.0);
				m_fOrigin[2] = m_fOrigin[2] - 20;
				int Renk[4];
				Renk[0] = 0;
				Renk[1] = 0;
				Renk[2] = 0;
				Renk[3] = 255;
				TE_SetupBeamPoints(m_fOrigin, m_fImpact, g_iBeam, 0, 0, 0, 0.1, 8.0, 8.0, 1, 0.0, Renk, 0);
				TE_SendToAll(0.1);
				float position[3] = 0.0;
				GetEntPropVector(client, Prop_Send, "m_vecOrigin", position);
				EmitSoundToAll("misc/LaserWarsSounds/Weapon/1.mp3", 0, 0, 75, 0, 1.0, 100, -1, position, NULL_VECTOR, true, 0.0);
			}
			else
			{
				if (takimNumarasi[client] == 2)
				{
					float m_fOrigin[3];
					float m_fImpact[3];
					GetClientEyePosition(client, m_fOrigin);
					m_fImpact[0] = GetEventFloat(event, "x", 0.0);
					m_fImpact[1] = GetEventFloat(event, "y", 0.0);
					m_fImpact[2] = GetEventFloat(event, "z", 0.0);
					m_fOrigin[2] = m_fOrigin[2] - 20;
					int Renk[4];
					Renk[0] = 255;
					Renk[1] = 255;
					Renk[2] = 255;
					Renk[3] = 255;
					TE_SetupBeamPoints(m_fOrigin, m_fImpact, g_iBeam, 0, 0, 0, 0.1, 8.0, 8.0, 1, 0.0, Renk, 0);
					TE_SendToAll(0.1);
					float position[3] = 0.0;
					GetEntPropVector(client, Prop_Send, "m_vecOrigin", position);
					EmitSoundToAll("misc/LaserWarsSounds/Weapon/1.mp3", 0, 0, 75, 0, 1.0, 100, -1, position, NULL_VECTOR, true, 0.0);
				}
			}
		}
		float m_fOrigin[3];
		float m_fImpact[3];
		GetClientEyePosition(client, m_fOrigin);
		m_fImpact[0] = GetEventFloat(event, "x", 0.0);
		m_fImpact[1] = GetEventFloat(event, "y", 0.0);
		m_fImpact[2] = GetEventFloat(event, "z", 0.0);
		m_fOrigin[2] = m_fOrigin[2] - 20;
		int Renk[4];
		Renk[0] = GetRandomInt(1, 255);
		Renk[1] = GetRandomInt(1, 255);
		Renk[2] = GetRandomInt(1, 255);
		Renk[3] = 255;
		TE_SetupBeamPoints(m_fOrigin, m_fImpact, g_iBeam, 0, 0, 0, 0.1, 8.0, 8.0, 1, 0.0, Renk, 0);
		TE_SendToAll(0.1);
		float position[3] = 0.0;
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", position);
		EmitSoundToAll("misc/LaserWarsSounds/Weapon/1.mp3", 0, 0, 75, 0, 1.0, 100, -1, position, NULL_VECTOR, true, 0.0);
	}
	return Plugin_Continue;
}

public Action Hook_NormalSound(int clients[64], int & numClients, char sample[255], int & entity, int & channel, float & volume, int & level, int & pitch, int & flags)
{
	if (strncmp(sample, "weapons", 7, true) && strncmp(sample[0], "weapons", 7, true))
	{
		return Plugin_Continue;
	}
	/*if (Lazer_Savaslari_Aktif)
	{
		int i = 0;
		while (numClients > i)
		{
			int j = i;
			while (numClients + -1 > j)
			{
				clients[j] = clients[j + 1];
				j++;
			}
			int var3 = numClients;
			var3--;
			numClients = var3;
			i--;
			i++;
		}
		bool var2;
		if (numClients > 0)
		{
			var2 = true;
		}
		else
		{
			var2 = false;
		}
		return var2;
	}*/
	return Plugin_Continue;
}

public El_Basi_Sonu(Handle event, const char[] name, bool dontBroadcast)
{
	if (Lazer_Savaslari_Aktif)
	{
		Takim_Kapat();
		SetCvar("sv_infinite_ammo", 0);
		SetCvar("mp_teammates_are_enemies", 0);
		SetCvar("sm_lssekmeme", 0);
		StopSoundAny(-2, 0, "misc/LaserWarsSounds/Ambiance/starwars.mp3");
		EmitSoundToAllAny("misc/LaserWarsSounds/End/end.mp3", -2, 0, 200, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
		Lazer_Savaslari_Aktif = false;
		M4A1 = false;
		USP = false;
		MP5SD = false;
		int i = 1;
		while (i <= MaxClients)
		{
			if (IsClientInGame(i))
			{
				SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
			}
			i++;
		}
		if (h_timer != INVALID_HANDLE)
		{
			delete h_timer;
		}
	}
}

public Action Oyuncu_Oldugunde(Handle event, const char[] name, bool dontBroadcast)
{
	if (Lazer_Savaslari_Aktif && !TakimYapildi)
	{
		char Kazanan_Ismi[32];
		int T_Sayisi;
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && GetClientTeam(i) == CS_TEAM_T && IsPlayerAlive(i))
			{
				GetClientName(i, Kazanan_Ismi, 32);
				T_Sayisi++;
			}
		}
		if (T_Sayisi == 1)
		{
			PrintToChatAll(" \x02[LazerSavaşları] \x04Lazer Savaşlarını \x01%s \x04Kazandı!", Kazanan_Ismi);
			SetCvar("sv_infinite_ammo", 0);
			SetCvar("mp_teammates_are_enemies", 0);
			SetCvar("sm_lssekmeme", 0);
			StopSoundAny(-2, 0, "misc/LaserWarsSounds/Ambiance/starwars.mp3");
			EmitSoundToAllAny("misc/LaserWarsSounds/End/end.mp3", -2, 0, 100, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
			Lazer_Savaslari_Aktif = false;
			M4A1 = false;
			USP = false;
			MP5SD = false;
			for (int j = 1; j < MaxClients; j++)
			{
				SDKUnhook(j, SDKHook_OnTakeDamage, OnTakeDamage);
				if (IsClientInGame(j) && GetClientTeam(j) == CS_TEAM_T)
				{
					ModelVer(j);
					Silahlari_Sil(j);
					GivePlayerItem(j, "weapon_knife");
					if (EkranEfekt)
					{
						SetEntProp(j, Prop_Send, "m_bNightVisionOn", 0);
					}
				}
			}
		}
		g_iBeam = -1;
		if (h_timer != INVALID_HANDLE)
		{
			delete h_timer;
		}
	}
	else if (Lazer_Savaslari_Aktif && TakimYapildi)
	{
		int Siyah_Sayisi;
		int Beyaz_Sayisi;
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				if (GetClientTeam(i) == CS_TEAM_T && IsPlayerAlive(i))
				{
					if (takimNumarasi[i] == 1)
					{
						Siyah_Sayisi++;
					}
					if (takimNumarasi[i] == 2)
					{
						Beyaz_Sayisi++;
					}
				}
			}
		}
		if (Siyah_Sayisi >= 1 && Beyaz_Sayisi == 0)
		{
			PrintToChatAll(" \x02[LazerSavaşları] \x04Lazer Savaşlarını \nSiyah Taraf \x04Kazandı!");
			SetCvar("sv_infinite_ammo", 0);
			SetCvar("mp_teammates_are_enemies", 0);
			SetCvar("sm_lssekmeme", 0);
			Takim_Kapat();
			StopSoundAny(-2, 0, "misc/LaserWarsSounds/Ambiance/starwars.mp3");
			EmitSoundToAllAny("misc/LaserWarsSounds/End/end.mp3", -2, 0, 100, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
			Lazer_Savaslari_Aktif = false;
			M4A1 = false;
			USP = false;
			MP5SD = false;
			for (int j = 1; j < MaxClients; j++)
			{
				SDKUnhook(j, SDKHook_OnTakeDamage, OnTakeDamage);
				if (IsClientInGame(j) && GetClientTeam(j) == CS_TEAM_T)
				{
					ModelVer(j);
					Silahlari_Sil(j);
					GivePlayerItem(j, "weapon_knife");
					if (EkranEfekt)
					{
						SetEntProp(j, Prop_Send, "m_bNightVisionOn", 0);
					}
				}
			}
		}
		else if (Siyah_Sayisi == 0 && Beyaz_Sayisi >= 1)
		{
			PrintToChatAll(" \x02[LazerSavaşları] \x04Lazer Savaşlarını \x01Beyaz Taraf \x04Kazandı!");
			SetCvar("sv_infinite_ammo", 0);
			SetCvar("mp_teammates_are_enemies", 0);
			SetCvar("sm_lssekmeme", 0);
			Takim_Kapat();
			StopSoundAny(-2, 0, "misc/LaserWarsSounds/Ambiance/starwars.mp3");
			EmitSoundToAllAny("misc/LaserWarsSounds/End/end.mp3", -2, 0, 100, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
			Lazer_Savaslari_Aktif = false;
			M4A1 = false;
			USP = false;
			MP5SD = false;
			for (int j = 1; j < MaxClients; j++)
			{
				SDKUnhook(j, SDKHook_OnTakeDamage, OnTakeDamage);
				SetEntProp(j, Prop_Send, "m_bNightVisionOn", 0);
			}
		}
		g_iBeam = -1;
		if (h_timer != INVALID_HANDLE)
		{
			delete h_timer;
		}
	}
}

/*
OyunuBaslat()
{
	EmitSoundToAllAny("misc/LaserWarsSounds/Start/start.mp3", -2, 0, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
	SetCvar("mp_teammates_are_enemies", 1);
	if (Sekmeme)
	{
		SetCvar("sm_lssekmeme", 1);
	}
	if (SinirsizMermi)
	{
		SetCvar("sv_infinite_ammo", 1);
	}
	if (MuzikDurumu)
	{
		EmitSoundToAllAny("misc/LaserWarsSounds/Ambiance/starwars.mp3", -2, 0, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
	}
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == CS_TEAM_T && IsPlayerAlive(i))
		{
			SDKHook(i, SDKHook_OnTakeDamage, OnTakeDamage);
			SetEntityHealth(i, 100);
			if (EkranEfekt)
			{
				SetEntProp(i, Prop_Send, "m_bNightVisionOn", 1);
			}
			Silahlari_Sil(i);
			PrintHintText(i, "Lazer Savaşları BAŞLADI!\n[---!Güç Sizinle Olsun!---]");
		}
	}
}
*/

Takim_Kapat()
{
	TakimYapildi = false;
	int i = 1;
	while (i <= MaxClients)
	{
		oyuncuTakimDurumu[i] = false;
		if (IsClientConnected(i) && IsClientInGame(i) && GetClientTeam(i) != CS_TEAM_NONE && GetClientTeam(i) != CS_TEAM_SPECTATOR && IsPlayerAlive(i))
		{
			SetEntityRenderColor(i, 255, 255, 255, 255);
		}
		i++;
	}
}

public void OnConVarChanged(Handle hConvar, const char[] chOldValue, const char[] chNewValue)
{
	UpdateConVars();
}

public void UpdateConVars()
{
	//if (GetConVarBool(hCvarPluginEnabled))
	if (GetConVarBool(SekmemeHandle))
	{
		SetConVarInt(FindConVar("weapon_accuracy_nospread"), 1, false, false);
		SetConVarInt(FindConVar("weapon_recoil_cooldown"), 0, false, false);
		SetConVarInt(FindConVar("weapon_recoil_cooldown"), 0, false, false);
		SetConVarInt(FindConVar("weapon_recoil_decay1_exp"), 99999, false, false);
		SetConVarInt(FindConVar("weapon_recoil_decay2_exp"), 99999, false, false);
		SetConVarInt(FindConVar("weapon_recoil_decay2_lin"), 99999, false, false);
		SetConVarInt(FindConVar("weapon_recoil_scale"), 0, false, false);
		SetConVarInt(FindConVar("weapon_recoil_suppression_shots"), 500, false, false);
	}
	else
	{
		SetConVarInt(FindConVar("weapon_accuracy_nospread"), 0, false, false);
		SetConVarFloat(FindConVar("weapon_recoil_cooldown"), 0.55, false, false);
		SetConVarFloat(FindConVar("weapon_recoil_decay1_exp"), 3.5, false, false);
		SetConVarInt(FindConVar("weapon_recoil_decay2_exp"), 8, false, false);
		SetConVarInt(FindConVar("weapon_recoil_decay2_lin"), 18, false, false);
		SetConVarInt(FindConVar("weapon_recoil_scale"), 2, false, false);
		SetConVarInt(FindConVar("weapon_recoil_suppression_shots"), 4, false, false);
	}
}

public Action Hook_BlockTE(const char[] te_name, const int[] Players, int numClients, float delay)
{
	if (Lazer_Savaslari_Aktif)
	{
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

Silahlari_Sil(int client)
{
	int j;
	while (j < 5)
	{
		int weapon = GetPlayerWeaponSlot(client, j);
		if (weapon != -1)
		{
			RemovePlayerItem(client, weapon);
			RemoveEdict(weapon);
		}
		j++;
	}
	if (M4A1)
	{
		GivePlayerItem(client, "weapon_m4a1_silencer");
	}
	else if (USP)
	{
		GivePlayerItem(client, "weapon_usp_silencer");
	}
	else if (MP5SD)
	{
		GivePlayerItem(client, "weapon_mp5sd");
	}
}

public Action Lazer_Savaslari_Durdur(int client, int args)
{
	if (warden_iswarden(client) || CheckCommandAccess(client, "generic_admin", 32, false))
	{
		if (Lazer_Savaslari_Aktif)
		{
			PrintToChatAll(" \x02[LazerSavaşları] \x01Lazer Savaşları \x0E%N \x01tarafından durduruldu!", client);
			Takim_Kapat();
			SetCvar("sv_infinite_ammo", 0);
			SetCvar("mp_teammates_are_enemies", 0);
			SetCvar("sm_lssekmeme", 0);
			StopSoundAny(-2, 0, "misc/LaserWarsSounds/Ambiance/starwars.mp3");
			EmitSoundToAllAny("misc/LaserWarsSounds/End/end.mp3", -2, 0, 100, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
			Lazer_Savaslari_Aktif = false;
			M4A1 = false;
			USP = false;
			MP5SD = false;
			if (EkranEfekt)
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if (IsClientInGame(i) && GetClientTeam(i) == CS_TEAM_T)
					{
						SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
					}
				}
			}
			if (h_timer != INVALID_HANDLE)
			{
				delete h_timer;
			}
		}
		else
		{
			PrintToChat(client, "  \x02[LazerSavaşları] \x01Şuanda aktif bir \x0ELazer Savaşı \x01yok!");
		}
	}
	else
	{
		ReplyToCommand(client, " \x02[LazerSavaşları] \x0ELazer Savaşını \x01Sadece \x0Ckomutçular \x01durdurabilir!");
	}
	return Plugin_Continue;
}

bool IsValidClient(iClient)
{
	if (iClient <= 0 || iClient > MaxClients || !IsClientInGame(iClient))
	{
		return false;
	}
	return true;
}

ModelKaydet(int client)
{
	char PlayerModel[PLATFORM_MAX_PATH];
	GetClientModel(client, PlayerModel, sizeof(PlayerModel));
	SetClientCookie(client, g_Model, PlayerModel);
}

ModelVer(int client)
{
	char PlayerModel[PLATFORM_MAX_PATH];
	GetClientCookie(client, g_Model, PlayerModel, sizeof(PlayerModel));
	SetEntityModel(client, PlayerModel);
}

SetCvar(const char cvarName[64], value)
{
	Handle IntCvar = FindConVar(cvarName);
	if (IntCvar)
	{
		int flags = GetConVarFlags(IntCvar);
		flags &= ~FCVAR_NOTIFY;
		SetConVarFlags(IntCvar, flags);
		SetConVarInt(IntCvar, value, true, false);
		flags |= FCVAR_NOTIFY;
		SetConVarFlags(IntCvar, flags);
	}
}

Ekran_Renk_Olustur(client, Renk1, Renk2, Renk3, Renk4)
{
	int clients[2];
	clients[0] = client;
	int Sure = 200;
	int holdtime = 40;
	int flags = 17;
	int Renk[4];
	Renk[0] = Renk1;
	Renk[1] = Renk2;
	Renk[2] = Renk3;
	Renk[3] = Renk4;
	Handle message = StartMessageEx(GetUserMessageId("Fade"), clients, 1, 0);
	if (GetUserMessageType() == UM_Protobuf)
	{
		Protobuf pb = UserMessageToProtobuf(message);
		PbSetInt(pb, "duration", Sure);
		PbSetInt(pb, "hold_time", holdtime);
		PbSetInt(pb, "flags", flags);
		PbSetColor(pb, "clr", Renk);
	}
	else
	{
		BfWriteShort(message, Sure);
		BfWriteShort(message, holdtime);
		BfWriteShort(message, flags);
		BfWriteByte(message, Renk[0]);
		BfWriteByte(message, Renk[1]);
		BfWriteByte(message, Renk[2]);
		BfWriteByte(message, Renk[3]);
	}
	EndMessage();
	return;
}
