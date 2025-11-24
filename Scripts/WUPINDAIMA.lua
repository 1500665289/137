--[[local WUPINDAIMA = GameMain:GetMod("WUPINDAIMA");

--必须在OnBeforeInit中执行，这个时候系统只初始化了ThingDef。但是还没初始化所有物品的实体。StorageRing要改成你自己的名称
function WUPINDAIMA:OnBeforeInit()
	local CostItems = {};
	local newitem = CS.XiaWorld.ItemCostData() 
	newitem.name = "Item_LingStone";
	newitem.count = 1;

	local zaohuayulu = ThingMgr:GetDef(CS.XiaWorld.g_emThingType.Item, "Item_ZaoHuaYuLu") 
	local wupin = {zaohuayulu}
	for k,v in pairs(wupin) do
		if not v.Item then
			v.Item = CS.XiaWorld.ItemData();
		end
		if not v.Item.BeMade then
			v.Item.BeMade = CS.XiaWorld.ItemBeMadeData();
		end
		v.Item.BeMade.CostItems:Add(newitem)
	end
end
]]--

local JYS = GameMain:GetMod("JYS")

-- 存储每个物品的购买次数
local purchaseCounts = {}
-- 存储基础价格配置
local basePrices = {}

local function InitializePurchaseCounts()
    -- 从存档中加载购买次数，如果没有则初始化为空表
    if not JYS.purchaseData then
        JYS.purchaseData = {}
    end
    purchaseCounts = JYS.purchaseData
    
    -- 初始化基础价格配置
    if not JYS.basePriceData then
        JYS.basePriceData = {}
    end
    basePrices = JYS.basePriceData
end

local function SavePurchaseCounts()
    -- 确保数据被保存到mod中
    JYS.purchaseData = purchaseCounts
    JYS.basePriceData = basePrices
end

local function GetAdjustedCostCount(ItemName, baseCount)
    if not purchaseCounts[ItemName] then
        purchaseCounts[ItemName] = 0
    end
    
    -- 每购买一次价格增加1
    local adjustedCount = baseCount + purchaseCounts[ItemName]
    return adjustedCount
end

local function ResetItemPurchaseCount(ItemName)
    -- 重置单个物品的购买次数
    if purchaseCounts[ItemName] then
        purchaseCounts[ItemName] = 0
        print(string.format("物品 %s 购买次数已重置", ItemName))
        SavePurchaseCounts()
        return true
    end
    return false
end

local function OnItemPurchased(ItemName)
    -- 增加购买计数
    if not purchaseCounts[ItemName] then
        purchaseCounts[ItemName] = 0
    end
    
    purchaseCounts[ItemName] = purchaseCounts[ItemName] + 1
    
    -- 检查是否达到100次购买
    if purchaseCounts[ItemName] >= 100 then
        print(string.format("物品 %s 购买次数达到 %d 次，重置价格和次数", ItemName, purchaseCounts[ItemName]))
        ResetItemPurchaseCount(ItemName)
        -- 重新应用基础价格
        if basePrices[ItemName] then
            local costItemName, baseCount = basePrices[ItemName].costItem, basePrices[ItemName].count
            AddCostItem(ItemName, costItemName, baseCount)
        end
    else
        -- 更新价格（每次购买后立即更新）
        if basePrices[ItemName] then
            local costItemName, baseCount = basePrices[ItemName].costItem, basePrices[ItemName].count
            AddCostItem(ItemName, costItemName, baseCount)
        end
    end
    
    SavePurchaseCounts()
    print(string.format("物品 %s 购买次数: %d", ItemName, purchaseCounts[ItemName]))
end

local function AddCostItem(ItemName, CostItemName, CostItemCount)
    local ThingDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, ItemName)
    if not ThingDef then
        print("不存在的物品：" .. ItemName)
        return
    end
    
    local CostThingDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, CostItemName)
    if not CostThingDef then
        print("不存在的需求物品：" .. CostItemName)
        return
    end
    
    -- 保存基础价格配置
    if not basePrices[ItemName] then
        basePrices[ItemName] = {
            costItem = CostItemName,
            count = CostItemCount
        }
    end
    
    -- 获取调整后的价格（基于购买次数）
    local adjustedCount = GetAdjustedCostCount(ItemName, CostItemCount)
    
    -- 修复重新加载存档导致的重复修改的bug
    if ThingDef.Item and ThingDef.Item.BeMade and ThingDef.Item.BeMade.CostItems then
        local found = false
        for i = 0, ThingDef.Item.BeMade.CostItems.Count - 1 do
            local costItem = ThingDef.Item.BeMade.CostItems[i]
            if costItem.name == CostItemName then
                -- 更新现有成本项的数量
                costItem.count = adjustedCount
                found = true
                break
            end
        end
        
        -- 如果没找到对应的成本项，添加新的
        if not found then
            local newitem = CS.XiaWorld.ItemCostData()
            newitem.name = CostItemName
            newitem.minlevel = 1
            newitem.maxlevel = 9999
            newitem.count = adjustedCount
            ThingDef.Item.BeMade.CostItems:Add(newitem)
        end
    else
        -- 初始化物品数据
        if not ThingDef.Item then
            ThingDef.Item = CS.XiaWorld.ItemData()
        end
        
        -- 手动处理DrugBase子类别的BUG
        if ThingDef.Parent == "DrugBase" then
            local ParentDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, "DrugBase")
            if ParentDef and ThingDef.Item.BeMade == ParentDef.Item.BeMade then
                ThingDef.Item.BeMade = CS.XiaWorld.ThingBeMadeData()
                ThingDef.Item.BeMade.WorkToMake = 100
                ThingDef.Item.BeMade.CostStuffCount = 0
            end
        end
        
        if not ThingDef.Item.BeMade then
            ThingDef.Item.BeMade = CS.XiaWorld.ThingBeMadeData()
        end
        
        if not ThingDef.Item.BeMade.CostItems then
            ThingDef.Item.BeMade.CostItems = CS.System.Collections.Generic["List`1[XiaWorld.ItemCostData]"]()
        end
        
        local newitem = CS.XiaWorld.ItemCostData()
        newitem.name = CostItemName
        newitem.minlevel = 1
        newitem.maxlevel = 9999
        newitem.count = adjustedCount
        
        ThingDef.Item.BeMade.CostItems:Add(newitem)
    end
    
    print(string.format("设置物品 %s 的成本: %s x %d (基础价格: %d, 购买次数: %d)", 
          ItemName, CostItemName, adjustedCount, CostItemCount, purchaseCounts[ItemName] or 0))
end

-- 钩子函数：检测物品购买事件
local function HookIntoPurchaseSystem()
    -- 这里需要根据游戏实际的购买系统来挂钩子
    -- 以下是示例代码，需要根据实际游戏API调整
    
    -- 方法1：监听商店交易事件
    if CS.XiaWorld.ShopMgr then
        -- 假设有ShopMgr和交易完成事件
        -- CS.XiaWorld.ShopMgr.OnTradeComplete:Add(function(itemName)
        --     OnItemPurchased(itemName)
        -- end)
    end
    
    -- 临时测试函数（用于测试功能）
    function JYS:TestPurchase(itemName)
        print("测试购买: " .. itemName)
        OnItemPurchased(itemName)
    end
end

function JYS:OnInit()
    InitializePurchaseCounts()
    HookIntoPurchaseSystem()
end

function JYS:OnLoad()
    InitializePurchaseCounts()
end

function JYS:OnBeforeInit()
    InitializePurchaseCounts()
    
    -- 设置基础价格
    AddCostItem("Item_HardWood", "Item_LingStone", 1500) --金丝木
    AddCostItem("Item_LingWood", "Item_LingStone", 3000) --灵木
    AddCostItem("Item_ParasolWood", "Item_LingStone", 5000) --梧桐木
    AddCostItem("Item_IronRock", "Item_LingStone", 100) --铁矿
    AddCostItem("Item_CopperRock", "Item_LingStone", 200) --火铜矿石
    AddCostItem("Item_SilverRock", "Item_LingStone", 200) --寒晶矿石
    AddCostItem("Item_DarksteelRock", "Item_LingStone", 500) --玄铁
    AddCostItem("Item_StarEssence", "Item_LingStone", 1000) --星髓
    AddCostItem("Item_BrownRock", "Item_LingStone", 100) --棕石
    AddCostItem("Item_Marble", "Item_LingStone", 250) --大理石
    AddCostItem("Item_Jade", "Item_LingStone", 500) --玉石
    AddCostItem("Item_SkyStone", "Item_LingStone", 5000) --天柱石
    AddCostItem("Item_SoulCrystalYou", "Item_LingStone", 300) --幽珀
    AddCostItem("Item_SoulCrystalLing", "Item_LingStone", 300) --灵珀
    AddCostItem("Item_SoulCrystalNing", "Item_LingStone", 300) --宁珀
    AddCostItem("Item_Yao_RabbitLuck", "Item_LingStone", 10000) --兔妖的脚
    AddCostItem("Item_Yao_WolfAtk", "Item_LingStone", 10000) --妖狼的尖牙
    AddCostItem("Item_Yao_SnakeHanLin", "Item_LingStone", 10000) --妖蛇的寒鳞
    AddCostItem("Item_Yao_BearPiMao", "Item_LingStone", 10000) --熊妖的脖颈毛
    AddCostItem("Item_Yao_TurtleKe", "Item_LingStone", 10000) --巨龟的坚甲
    AddCostItem("Item_DragonShit", "Item_LingCrystal", 100) --天龙砂
    AddCostItem("Item_DragonScale", "Item_LingCrystal", 1000) --龙鳞
    AddCostItem("Item_ZaoHuaYuLu", "Item_LingStone", 50000) --造化玉露--灵石
    AddCostItem("Item_HuoEssence", "Item_LingCrystal", 120) --朱果--灵晶
    AddCostItem("Item_ShuiEssence", "Item_LingCrystal", 120) --五色金莲--灵晶
    AddCostItem("Item_MuEssence", "Item_LingCrystal", 120) --木枯藤--灵晶
    AddCostItem("Item_JinEssence", "Item_LingCrystal", 120) --琅琊果--灵晶
    AddCostItem("Item_TuEssence", "Item_LingCrystal", 120) --赭黄精--灵晶
    AddCostItem("Item_EarthEssence", "Item_LingStone", 1000) --地母灵液--玉石
    AddCostItem("Item_LifeStream", "Item_LingStone", 1000) --长生泉--灵木
    AddCostItem("Item_SoulPearl", "Item_LingCrystal", 100) --玄牝珠--
    AddCostItem("Item_MonsterBlood", "Item_LingStone", 100) --妖灵血--大理石
    AddCostItem("Item_Cinnabar", "Item_LingStone", 30) --朱砂--灵石
    AddCostItem("Item_LingMuXueJie", "Item_LingCrystal", 10) --灵木血竭--灵晶
    AddCostItem("Item_EarthEssence_1", "Item_LingCrystal", 200) --灵髓脂--灵晶
    AddCostItem("Item_YuanHunLu", "Item_LingCrystal", 200) --元魂露--灵晶
    AddCostItem("Item_YanDaoGuo", "Item_LingCrystal", 300) --演道果--灵晶
    AddCostItem("Item_EarthEssence1", "Item_LingCrystal", 10) --邪脉血泉--灵晶
    AddCostItem("Item_EarthEssence1_1", "Item_LingCrystal", 200) --血髓脂--灵晶
    AddCostItem("Item_XieHunLu", "Item_LingCrystal", 200) --邪魂露--灵晶
    AddCostItem("Item_QieDaoGuo", "Item_LingCrystal", 300) --窃道果--灵晶
    AddCostItem("Item_ThunderAir", "Item_LingCrystal", 2000) --天劫之息--灵晶
    AddCostItem("Item_StoneBox2", "Item_LingCrystal", 100) --古旧石匣--灵晶
    AddCostItem("Item_XianBone", "Item_LingCrystal", 1000) --仙人遗骨--灵晶
    AddCostItem("Item_ZaoHuaYuZi", "Item_LingCrystal", 50) --造化玉籽--灵晶
end

-- 提供重置价格的函数
function JYS:ResetPurchaseCounts()
    purchaseCounts = {}
    SavePurchaseCounts()
    print("所有物品购买次数已重置")
end

-- 重置单个物品的购买次数
function JYS:ResetItemPurchaseCount(itemName)
    if ResetItemPurchaseCount(itemName) then
        -- 重新应用基础价格
        if basePrices[itemName] then
            local costItemName, baseCount = basePrices[itemName].costItem, basePrices[itemName].count
            AddCostItem(itemName, costItemName, baseCount)
        end
    end
end

-- 查看物品当前购买次数和价格
function JYS:GetItemPurchaseInfo(itemName)
    if basePrices[itemName] then
        local costItemName, baseCount = basePrices[itemName].costItem, basePrices[itemName].count
        local currentCount = purchaseCounts[itemName] or 0
        local currentPrice = baseCount + currentCount
        return {
            itemName = itemName,
            basePrice = baseCount,
            purchaseCount = currentCount,
            currentPrice = currentPrice,
            costItem = costItemName
        }
    end
    return nil
end
