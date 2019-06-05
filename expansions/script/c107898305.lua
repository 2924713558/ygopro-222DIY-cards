--
function c107898305.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c107898305.spcon)
	e0:SetOperation(c107898305.spop)
	c:RegisterEffect(e0)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898305,2))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCondition(c107898305.condition)
	e1:SetTarget(c107898305.target)
	e1:SetOperation(c107898305.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(107898305,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(c107898305.rmtg)
	e2:SetOperation(c107898305.rmop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(107898305,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetTarget(c107898305.atktg2)
	e3:SetOperation(c107898305.atkop2)
	c:RegisterEffect(e3)
end
function c107898305.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898101)
end
function c107898305.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local clv=math.floor(c:GetLevel()/2)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c107898305.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and (lv==1 or Duel.IsCanRemoveCounter(tp,1,0,0x1,clv,REASON_COST))
end
function c107898305.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if c:GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(c:GetLevel()/2),REASON_COST)
	end
end
function c107898305.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c107898305.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dam+400)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,dam+400)
end
function c107898305.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c107898305.atktg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898305.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898305.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c107898305.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898305.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e)) then return end
	local atk=tc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
end
function c107898305.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c107898305.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end