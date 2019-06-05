--ルシフェル
local m=17082102
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+2
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()
	--xyz summon
    local e_0=Effect.CreateEffect(c)
    e_0:SetDescription(aux.Stringid(17082102,0))
    e_0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e_0:SetType(EFFECT_TYPE_FIELD)
    e_0:SetCode(EFFECT_SPSUMMON_PROC)
    e_0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e_0:SetRange(LOCATION_EXTRA)
    e_0:SetValue(SUMMON_TYPE_XYZ)
    e_0:SetCondition(cm.exyzcon)
    e_0:SetOperation(cm.exyzop)
    c:RegisterEffect(e_0)
	--remove
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(17082102,1))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(cm.remcon)
	e0:SetOperation(cm.remop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17082102,2))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(cm.aclcon)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17082102,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.reccon)
	e3:SetOperation(cm.recop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(cm.sumsuc)
	c:RegisterEffect(e5)
	--atk bgm
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetOperation(cm.atksuc)
	c:RegisterEffect(e6)
	--destroy bgm
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(cm.descon)
	e7:SetOperation(cm.dessuc)
	c:RegisterEffect(e7)
	--summon success
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetOperation(cm.sumsuc)
	c:RegisterEffect(e9)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.exyzfilter(c,xyzcard)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsLevel(8) and not c:IsType(TYPE_TOKEN)
end
function cm.exyzfilter1(c,xyzcard)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_TOKEN)
end
function cm.exyzcon(e,c)    
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	and (Duel.IsExistingMatchingCard(cm.exyzfilter,tp,LOCATION_MZONE,0,3,nil) or Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,0,1,nil)) and Duel.GetFlagEffect(tp,17082102)==0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false,POS_FACEUP,tp) and Duel.GetLocationCountFromEx(tp)>0
end
function cm.ndcfilter(c,code)
	local code1,code2=c:GetOriginalCodeRule()
	return c:IsFaceup() and (code1==code or code2==code)
end
function cm.exyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit1)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,17082102,RESET_PHASE+PHASE_END,0,1)
	if Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.ndcfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,47500007)
		and Duel.IsExistingMatchingCard(cm.exyzfilter1,tp,LOCATION_MZONE,0,3,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(17082102,0)) then
		local sg1=Duel.SelectMatchingCard(tp,cm.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
		c:SetMaterial(sg1)
		Duel.Overlay(c,sg1)
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
		c:RegisterFlagEffect(0,RESET_EVENT+RESET_LEAVE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(17082102,4))
	elseif Duel.IsExistingMatchingCard(cm.ndcfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,47500007)
		and Duel.IsExistingMatchingCard(cm.exyzfilter1,tp,LOCATION_MZONE,0,3,nil) then
		local sg2=Duel.SelectMatchingCard(tp,cm.exyzfilter1,tp,LOCATION_MZONE,0,3,3,nil)
		c:SetMaterial(sg2)
		Duel.Overlay(c,sg2)
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
		sg2:DeleteGroup()
	elseif Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.exyzfilter,tp,LOCATION_MZONE,0,3,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(17082102,0)) then
		local sg1=Duel.SelectMatchingCard(tp,cm.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
		c:SetMaterial(sg1)
		Duel.Overlay(c,sg1)
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
		c:RegisterFlagEffect(0,RESET_EVENT+RESET_LEAVE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(17082102,4))
	elseif Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.GetMatchingGroupCount(cm.exyzfilter,c:GetControler(),LOCATION_MZONE,0,nil)<3 then 
		local sg1=Duel.SelectMatchingCard(tp,cm.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
		c:SetMaterial(sg1)
		Duel.Overlay(c,sg1)
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
		c:RegisterFlagEffect(0,RESET_EVENT+RESET_LEAVE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(17082102,4))
	else
		local sg=Duel.SelectMatchingCard(tp,cm.exyzfilter,tp,LOCATION_MZONE,0,3,3,nil)
		c:SetMaterial(sg)
		Duel.Overlay(c,sg)
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
		sg:DeleteGroup()
	end
end
function cm.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_PENDULUM)
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 and not tc:IsLocation(LOCATION_HAND+LOCATION_DECK) then
		if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (not tc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0)
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and tc:IsSSetable() then
			Duel.BreakEffect()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_RULE)
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.remcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1600,REASON_EFFECT)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(17082102,11))
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE+LOCATION_SZONE) and c:IsFaceup()
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(17082102,8))
end	
function cm.atksuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(17082102,9))
end
function cm.dessuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(17082102,10))
end
function cm.aclcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) 
end
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end