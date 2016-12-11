#include <a_samp>

#define KEY_AIM 128

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

new b1;
new b2;

new positionCorrectionTimer[MAX_PLAYERS];
new timer[MAX_PLAYERS];

new isInBalloon[MAX_PLAYERS];
	
public OnFilterScriptInit()
{
    b1 = CreateObject(19332, 198.9927, -1832.8091, 3.0, 0.00, 0.00, 0.00);
    b2 = CreateObject(2255, 364.71, 2537.19, 15.68, 90.00, 0.00, 0.00);
    AttachObjectToObject(b2, b1, 0, 0, -0.37, 90, 0, 0, 0);
    print("Controllable Balloon");
    return 1;
}

public OnFilterScriptExit()
{
    DestroyObject(b1);
    DestroyObject(b2);
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys & KEY_SECONDARY_ATTACK)
    {
        new Float:X, Float:Y, Float:Z;
        GetObjectPos(b1, X, Y, Z);
        if (isInBalloon[playerid] == 0)
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.32, X, Y, Z))
            {
                isInBalloon[playerid] = 1;
                SetPlayerPos(playerid, X, Y, Z+ 1);
                SetPlayerFacingAngle(playerid, 0);
                timer[playerid] = 1;
                positionCorrectionTimer[playerid] = SetTimer("correctPlayerPosition", 28, true);
                SendClientMessage(playerid, 0xDEEE20FF, "You have entered the balloon, from now on, you can only control the balloon");
            }
        }
        else if (isInBalloon[playerid] == 1)
        {
            KillTimer(positionCorrectionTimer[playerid]);
            SendClientMessage(playerid, 0xDEEE20FF, "You have left the balloon");
            isInBalloon[playerid] = 0;
            timer[playerid] = 0;
            SetCameraBehindPlayer(playerid);
        }
    }
    if (isInBalloon[playerid] == 1)
    {
        new Float:x, Float:y, Float:z;
        GetObjectPos(b1, x, y, z);
        if (PRESSED(KEY_FIRE))
        {
            MoveObject(b1, x, y + 10000, z, 2.5);
        }
        if (RELEASED(KEY_FIRE))
        {
            StopObject(b1);
        }
        if (PRESSED(KEY_AIM))
        {
            MoveObject(b1, x, y - 10000, z, 2.5);
        }
        if (RELEASED(KEY_AIM))
        {
            StopObject(b1);
        }
        if (PRESSED(KEY_ANALOG_LEFT))
        {
            MoveObject(b1, x - 10000, y, z, 2.5);
        }
        if (RELEASED(KEY_ANALOG_LEFT))
        {
            StopObject(b1);
        }
        if (PRESSED(KEY_ANALOG_RIGHT))
        {
            MoveObject(b1, x + 10000, y, z, 2.5);
        }
        if (RELEASED(KEY_ANALOG_RIGHT))
        {
            StopObject(b1);
        }
        if (PRESSED(KEY_JUMP))
        {
            new Float:X, Float:Y, Float:Z;
            GetPlayerPos(playerid, X, Y, Z);
            
            if (Z >= 815)
            {
                StopObject(b1);
            }
            else
            {
                MoveObject(b1, x, y, z - 10000, 2.5);
            }
        }
        if (RELEASED(KEY_JUMP))
        {
            StopObject(b1);
        }
        if (PRESSED(KEY_SPRINT))
        {
            MoveObject(b1, x, y, z + 10000, 2.5);
        }
        if (RELEASED(KEY_SPRINT))
        {
            StopObject(b1);
        }
    }
    return 1;
}
forward correctPlayerPosition(playerid);
public correctPlayerPosition(playerid)
{
    if (timer[playerid] == 1)
    {
        new Float:x, Float:y, Float:z;
        GetObjectPos(b1, x, y, z);
        SetPlayerPos(playerid, x, y, z + 1);
    }
    return 1;
}
