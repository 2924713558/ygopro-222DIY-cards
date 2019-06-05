--椿与骸骨与恋眠的他
local m=62210001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000")end,function() require("script/c62200000") end)
cm.named_with_AnoKare=true

function cm.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(cm.cost)
    e1:SetCondition(cm.thcon)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)
    --token
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCost(cm.tokencost)
    e2:SetCondition(cm.tokencon)
    e2:SetTarget(cm.tokentg)
    e2:SetOperation(cm.tokenop)
    c:RegisterEffect(e2)
    --xyzlimit
    local e100=Effect.CreateEffect(c)
    e100:SetType(EFFECT_TYPE_SINGLE)
    e100:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e100:SetValue(cm.mlimit)
    c:RegisterEffect(e100)
    local e110=e100:Clone()
    e110:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e110)
    local e120=e100:Clone()
    e120:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e120)
    local e130=e100:Clone()
    e130:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e130)    
end
--
function cm.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local fa=Duel.GetFlagEffect(tp,622100000)
    local fb=Duel.GetFlagEffect(tp,622100001)
    local c=e:GetHandler()
    local fc=fa-fb
    if chk==0 then return fc<3 and Duel.CheckLPCost(tp,1000) end
    Duel.RegisterFlagEffect(tp,622100000,RESET_PHASE+PHASE_END,0,1)
    Duel.PayLPCost(tp,1000)
end
function cm.thconfilter(c)
    return c:GetBaseAttack()~=0
end
function cm.thcon(e)
    return not Duel.IsExistingMatchingCard(cm.thconfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.thfilter(c)
    return c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--
function cm.tokencost(e,tp,eg,ep,ev,re,r,rp,chk)
    local fa=Duel.GetFlagEffect(tp,622100000)
    local fb=Duel.GetFlagEffect(tp,622100001)
    local c=e:GetHandler()
    local fc=fa-fb
    if chk==0 then return fc<3 and e:GetHandler():IsReleasable() end
    Duel.RegisterFlagEffect(tp,622100000,RESET_PHASE+PHASE_END,0,1)
    Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.tokencfilter(c,tp)
    return c:GetBaseAttack()==0 and c:IsControler(tp)
end
function cm.tokencon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.tokencfilter,1,nil,tp)
end
function cm.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,62219999,nil,0x4011,0,0,4,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.tokenop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,62219999,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then
    local token=Duel.CreateToken(tp,62219999)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetValue(cm.mlimit)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    token:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    token:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    token:RegisterEffect(e3)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    token:RegisterEffect(e4)
    end
end