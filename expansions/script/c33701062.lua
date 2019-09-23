--魔法的第三惑精 奇迹☆篝酱
function c33701062.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c33701062.ovfilter,aux.Stringid(33701062,0),3,c33701062.xyzop)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33701062.spcost)
	e1:SetTarget(c33701062.target)
	e1:SetOperation(c33701062.operation)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c33701062.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c33701062.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701062,1))
end
function c33701062.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33701062.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x440) and c:IsType(TYPE_MONSTER)
end
function c33701062.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33701062)==0 end
	Duel.RegisterFlagEffect(tp,33701062,RESET_PHASE+PHASE_END,0,1)
end
function c33701062.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c33701062.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetCondition(c33701062.rcon)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e6,true)
		local e7=e1:Clone()
		e7:SetCode(EFFECT_UNRELEASABLE_SUM)
		tc:RegisterEffect(e7,true)
		local e8=e1:Clone()
		e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e8,true)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_SET_ATTACK_FINAL)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e9:SetCondition(c33701062.rcon)
		e9:SetValue(0)
		tc:RegisterEffect(e9)
		local e10=e9:Clone()
		e10:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e10,true)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701062,1))
end
function c33701062.rcon(e)
	return not e:GetHandler():IsImmuneToEffect(e) and e:GetOwner():IsRelateToCard(e:GetHandler())
end