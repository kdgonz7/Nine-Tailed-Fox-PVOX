if ! PVox then return end

local NT_ENTITIES = {
    ["npc_cpt_scp_049_2"] = true,
    ["npc_cpt_scp_049_2_ntf"] = true,
}

local SCPs = {
    ["npc_cpt_scp_106_old"] = "spot_106",
    ["npc_cpt_scp_106"] = "spot_106",
    ["npc_cpt_scp_096"] = "spot_096",
    ["npc_cpt_scp_096_old"] = "spot_096",
    ["npc_cpt_scp_049_2"] = "spot_zombie",
    ["npc_cpt_scp_049_2_ntf"] = "spot_zombie"
}

local AFFECTED_PRESETS = {
    ["ninetailedfox"] = true,
}

MsgC(Color(255,174,0), "[NTF-SCP UTILS]", Color(255, 255, 255), " loaded!\n")

-- simple way to use extra sounds 

if CLIENT then return end

hook.Add("KeyPress", "NTF_DetectEntity", function (ply, key)
    if key == IN_ATTACK2 then
        local eyeTracer = ply:GetEyeTraceNoCursor()
        if ! eyeTracer.Entity then return end

        local scpSeen = SCPs[eyeTracer.Entity:GetClass()]

        if scpSeen then
            local preset = ply:GetNWString("vox_preset", "none")
            if ! AFFECTED_PRESETS[preset] then return end

            local mod = PVox.Modules[preset]
            if ! mod then return end

            print(mod:GetCachedSound(ply))
            mod:EmitAction(ply, scpSeen) -- custom action
        end
    end
end)

hook.Add("OnNPCKilled", "NTF_DetectKilledEntity", function (ent, attackerPLY, inflictorIDK)
    if NT_ENTITIES[ent:GetClass()] and attackerPLY:IsPlayer() then
        local preset = attackerPLY:GetNWString("vox_preset", nil)
        if ! preset || ! AFFECTED_PRESETS[preset] then return end

        local modul = PVox.Modules[preset]
        if ! modul then return end

        timer.Simple(0.1, function()
            modul:EmitAction(attackerPLY, "kill_zombie")
        end)
    end
end)
