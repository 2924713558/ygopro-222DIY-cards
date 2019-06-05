--我的朋友
local m=33700502
local cm=_G["c"..m]
cm.dfc_back_side=m-1
cm.card_code_list={33700056}
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.DFCBackSideCommonEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		return g:GetClassCount(Card.GetCode)<g:GetCount() or not g:IsExists(function(c) return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x442) end,1,nil)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e,re,val,r,rp,rc)
		local tp=e:GetHandlerPlayer()
		local g=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x442) and c:IsAbleToDeckAsCost() end,tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()<=0 then
			return val
		end
		local ct=math.min(g:GetCount(),math.ceil(val/500))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(ct)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local g=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x442) and c:IsAbleToDeckAsCost() end,tp,LOCATION_GRAVE,0,nil)
			Duel.Hint(HINT_CARD,0,e:GetOwner():GetOriginalCode())
			local sg=g:Select(tp,1,e:GetLabel(),nil)
			Duel.SendtoDeck(sg,nil,1,REASON_COST)
			e:Reset()
		end)
		Duel.RegisterEffect(e1,e:GetHandlerPlayer())
		return math.max(val-(ct*500),0)
	end)
	c:RegisterEffect(e1)
end
