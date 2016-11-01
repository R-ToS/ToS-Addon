-----------------------------------
-- 特性[ヒールダメージ除去]と[プロヴォック]を
-- ボタンでON/OFF出来るようにしたアドオン
-- 2016.11.02
-----------------------------------
local load = false
function TKB_ON_INIT(addon, frame)
	local a = require('acutil')
	a.slashCommand('/tkb', TKB)
	a.slashCommand('/tkbfn', TKBfn)
	addon:RegisterMsg('GAME_START', 'TKB')
	if not load then
		load = true
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

	local function TKBtogbtn(Cabi)
		frame:ShowWindow(1)
		local state = GetIES(Cabi:GetObject()).ActiveState
		if state == 0 then
			btn:SetText('OFF')
		elseif state == 1 then
			btn:SetText('ON')
		end
	end

	local cl = session.GetAbility(401016)
	local sw = session.GetAbility(101020)
	if cl then
		TKBtogbtn(cl)
	elseif sw then
		TKBtogbtn(sw)
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

	local function TKBtogfn(Cabi,Cname,Cid)
		local name = Cname
		local id = Cid
		local abi = GetIES(Cabi:GetObject())
		local state = abi.ActiveState
		if state == 0 then
			CHAT_SYSTEM('[ON] '..abi.Name)
			btn:SetText('ON')
		elseif state == 1 then
			CHAT_SYSTEM('[OFF] '..abi.Name)
			btn:SetText('OFF')
		end
		TOGGLE_ABILITY_ACTIVE(nil, nil, name, id)
	end

	local cl = session.GetAbility(401016)
	local sw = session.GetAbility(101020)
	if cl then
		TKBtogfn(cl, 'Cleric10', 401016)
	elseif sw then
		TKBtogfn(sw, 'Swordman28', 101020)
	end
end