-----------------------------------
-- 特性[ヒールダメージ除去]と[プロヴォック]を
-- ボタンでON/OFF出来るようにしたアドオン
-- 2016.10.26
-----------------------------------
local load = false;
function TKB_ON_INIT(addon, frame)
	local a = require('acutil')
	a.slashCommand('/tkb', TKB)
	a.slashCommand('/tkbfn', TKBfn)
	addon:RegisterMsg('GAME_START', 'TKB')
	if not load then
		load = true;
		CHAT_SYSTEM('TKB Loaded')
	end
end

-----------------------------------
-- フレームとボタンの設定
-----------------------------------
function TKB(frame, control)
	local frame = ui.GetFrame('tkb')
	local btn = frame:GetChild('btn')
	frame:SetSkinName('')
	frame:ShowTitleBar(0)
	frame:ShowWindow(0)
	frame:SetOffset(1300, 900)
	btn:Resize(80, 40)
	btn:SetOffset(0, 0)
	btn:SetEventScript(ui.LBUTTONUP, 'TKBfn')
	local cl = session.GetAbility(401016)
	local sw = session.GetAbility(101020)
	if cl then frame:ShowWindow(1)
		local state = GetIES(cl:GetObject()).ActiveState;
		if state == 0 then
			btn:SetText('OFF')
		elseif state == 1 then
			btn:SetText('ON')
		end
	elseif sw then
		frame:ShowWindow(1)
		local state = GetIES(sw:GetObject()).ActiveState;
		if state == 0 then
			btn:SetText('OFF')
		elseif state == 1 then
			btn:SetText('ON')
		end
	else
		frame:ShowWindow(0)
	end
end

-----------------------------------
-- ボタンの動作設定
-----------------------------------
function TKBfn(frame, control)
	local frame = ui.GetFrame('tkb')
	local btn = frame:GetChild('btn')
	local sframe = ui.GetFrame('skilltree')
	sframe:SetUserValue('CLICK_ABIL_ACTIVE_TIME', imcTime.GetAppTime()-10)
	local cl = session.GetAbility(401016)
	local sw = session.GetAbility(101020)
	if cl then
		local name = 'Cleric10'
		local id = 401016;
		local abil = GetIES(cl:GetObject())
		local state = abil.ActiveState;
		if state == 0 then
			CHAT_SYSTEM('[ON] '..abil.Name)
			btn:SetText('ON')
		elseif state == 1 then
			CHAT_SYSTEM('[OFF] '..abil.Name)
			btn:SetText('OFF')
		end
		TOGGLE_ABILITY_ACTIVE(nil, nil, name, id)
	elseif sw then
		local name = 'Swordman28'
		local id = 101020;
		local abil = GetIES(sw:GetObject())
		local state = abil.ActiveState;
		if state == 0 then
			CHAT_SYSTEM('[ON] '..abil.Name)
			btn:SetText('ON')
		elseif state == 1 then
			CHAT_SYSTEM('[OFF] '..abil.Name)
			btn:SetText('OFF')
		end
		TOGGLE_ABILITY_ACTIVE(nil, nil, name, id)
	end
end