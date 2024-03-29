--灾厄 扰乱
function c14801072.initial_effect(c)
    --end battle phase
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(c14801072.condition)
    e1:SetTarget(c14801072.target)
    e1:SetOperation(c14801072.operation)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(c14801072.handcon)
    c:RegisterEffect(e2)
    --destroy replace
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EFFECT_DESTROY_REPLACE)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetTarget(c14801072.reptg)
    e5:SetValue(c14801072.repval)
    e5:SetOperation(c14801072.repop)
    c:RegisterEffect(e5)
end
function c14801072.repfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x4800) and c:IsLocation(LOCATION_MZONE)
        and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c14801072.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c14801072.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c14801072.repval(e,c)
    return c14801072.repfilter(c,e:GetHandlerPlayer())
end
function c14801072.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c14801072.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp)
end
function c14801072.filter(c,e,tp)
    return c:IsSetCard(0x4800) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801072.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801072.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c14801072.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14801072.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.BreakEffect()
        Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
    end
end
function c14801072.handcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_SZONE,0)==0
end