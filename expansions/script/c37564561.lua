--Nananana Momo
local m=37564561
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,37564765),2,4)
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_LINK)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ex:SetCode(EFFECT_SPSUMMON_CONDITION)
	ex:SetValue(cm.splimit)
	c:RegisterEffect(ex)
	Senya.NegateEffectModule(c,1)
end
function cm.splimit(e,se,sp,st)
	return (st & SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
