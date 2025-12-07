local JYS = GameMain:GetMod("JYS")

-- 存储物品的原始基础价格和当前浮动价格
local originalPrices = {}  -- 存储原始价格 {itemName = {costItemName = baseCount}}
local currentPrices = {}   -- 存储当前浮动价格 {itemName = {costItemName = currentCount}}

-- 初始化时设置原始基础价格
function JYS:OnBeforeInit()
    -- 清空价格记录
    originalPrices = {}
    currentPrices = {}
    
    -- 设置物品原始基础价格
    SetBasePrice("Item_HardWood", "Item_LingStone", 7500) --金丝木
    SetBasePrice("Item_LingWood", "Item_LingStone", 15000) --灵木
    SetBasePrice("Item_ParasolWood", "Item_LingStone", 25000) --梧桐木
    SetBasePrice("Item_IronRock", "Item_LingStone", 500) --铁矿
    SetBasePrice("Item_CopperRock", "Item_LingStone", 1000) --火铜矿石
    SetBasePrice("Item_SilverRock", "Item_LingStone", 1000) --寒晶矿石
    SetBasePrice("Item_DarksteelRock", "Item_LingStone", 2500) --玄铁
    SetBasePrice("Item_StarEssence", "Item_LingStone", 5000) --星髓
    SetBasePrice("Item_BrownRock", "Item_LingStone", 500) --棕石
    SetBasePrice("Item_Marble", "Item_LingStone", 1250) --大理石
    SetBasePrice("Item_Jade", "Item_LingStone", 2500) --玉石
    SetBasePrice("Item_SkyStone", "Item_LingStone", 25000) --天柱石
    SetBasePrice("Item_SoulCrystalYou", "Item_LingStone", 1500) --幽珀
    SetBasePrice("Item_SoulCrystalLing", "Item_LingStone", 1500) --灵珀
    SetBasePrice("Item_SoulCrystalNing", "Item_LingStone", 1500) --宁珀
    SetBasePrice("Item_Yao_RabbitLuck", "Item_LingStone", 50000) --兔妖的脚
    SetBasePrice("Item_Yao_WolfAtk", "Item_LingStone", 50000) --妖狼的尖牙
    SetBasePrice("Item_Yao_SnakeHanLin", "Item_LingStone", 50000) --妖蛇的寒鳞
    SetBasePrice("Item_Yao_BearPiMao", "Item_LingStone", 50000) --熊妖的脖颈毛
    SetBasePrice("Item_Yao_TurtleKe", "Item_LingStone", 50000) --巨龟的坚甲
    SetBasePrice("Item_DragonShit", "Item_LingCrystal", 500) --天龙砂
    SetBasePrice("Item_DragonScale", "Item_LingCrystal", 5000) --龙鳞
    SetBasePrice("Item_ZaoHuaYuLu", "Item_LingStone", 250000) --造化玉露
    SetBasePrice("Item_HuoEssence", "Item_LingCrystal", 600) --朱果
    SetBasePrice("Item_ShuiEssence", "Item_LingCrystal", 600) --五色金莲
    SetBasePrice("Item_MuEssence", "Item_LingCrystal", 600) --木枯藤
    SetBasePrice("Item_JinEssence", "Item_LingCrystal", 600) --琅琊果
    SetBasePrice("Item_TuEssence", "Item_LingCrystal", 600) --赭黄精
    SetBasePrice("Item_EarthEssence", "Item_LingStone", 5000) --地母灵液
    SetBasePrice("Item_LifeStream", "Item_LingStone", 5000) --长生泉
    SetBasePrice("Item_SoulPearl", "Item_LingCrystal", 500) --玄牝珠
    SetBasePrice("Item_MonsterBlood", "Item_LingStone", 500) --妖灵血
    SetBasePrice("Item_Cinnabar", "Item_LingStone", 150) --朱砂
    SetBasePrice("Item_LingMuXueJie", "Item_LingCrystal", 50) --灵木血竭
    SetBasePrice("Item_EarthEssence_1", "Item_LingCrystal", 1000) --灵髓脂
    SetBasePrice("Item_YuanHunLu", "Item_LingCrystal", 1000) --元魂露
    SetBasePrice("Item_YanDaoGuo", "Item_LingCrystal", 1500) --演道果
    SetBasePrice("Item_EarthEssence1", "Item_LingCrystal", 50) --邪脉血泉
    SetBasePrice("Item_EarthEssence1_1", "Item_LingCrystal", 1000) --血髓脂
    SetBasePrice("Item_XieHunLu", "Item_LingCrystal", 1000) --邪魂露
    SetBasePrice("Item_QieDaoGuo", "Item_LingCrystal", 1500) --窃道果
    SetBasePrice("Item_ThunderAir", "Item_LingCrystal", 10000) --天劫之息
    SetBasePrice("Item_StoneBox2", "Item_LingCrystal", 500) --古旧石匣
    SetBasePrice("Item_XianBone", "Item_LingCrystal", 5000) --仙人遗骨
    SetBasePrice("Item_ZaoHuaYuZi", "Item_LingCrystal", 250) --造化玉籽
    
    -- 为每个物品初始生成随机价格
    InitializeRandomPrices()
end

function SetBasePrice(itemName, costItemName, baseCount)
    if not originalPrices[itemName] then
        originalPrices[itemName] = {}
    end
    originalPrices[itemName][costItemName] = baseCount
end

-- 生成随机浮动价格（±100%）
function GetRandomPrice(basePrice)
    local minPrice = math.max(1, math.floor(basePrice * 0.01))  -- 最低1%
    local maxPrice = math.floor(basePrice * 2.0)  -- 最高200%
    local randomPrice = math.random(minPrice, maxPrice)
    return randomPrice
end

-- 为单个物品生成新的随机价格
function RandomizeItemPrice(itemName)
    if not originalPrices[itemName] then
        return false
    end
    
    for costItemName, baseCount in pairs(originalPrices[itemName]) do
        if not currentPrices[itemName] then
            currentPrices[itemName] = {}
        end
        
        local randomCount = GetRandomPrice(baseCount)
        currentPrices[itemName][costItemName] = randomCount
        
        -- 更新游戏中的价格
        UpdateItemPrice(itemName, costItemName, randomCount)
        
        -- 获取物品显示名称
        local thingDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, itemName)
        local displayName = thingDef and thingDef.ThingName and thingDef.ThingName.Value or itemName
        
        -- 计算浮动比例
        local ratio = math.floor((randomCount / baseCount) * 100)
        
        print(string.format("物品 %s 价格刷新: %d (%s%%) [%s x %d]", 
            displayName, randomCount, ratio, costItemName, randomCount))
    end
    
    return true
end

-- 初始化所有物品的随机价格
function InitializeRandomPrices()
    for itemName, _ in pairs(originalPrices) do
        RandomizeItemPrice(itemName)
    end
    print("已为所有物品初始化随机价格")
end

-- 更新游戏中的物品价格
function UpdateItemPrice(itemName, costItemName, newCount)
    local ThingDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, itemName)
    if not ThingDef then
        print("不存在的物品：" .. itemName)
        return false
    end
    
    local CostThingDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, costItemName)
    if not CostThingDef then
        print("不存在的需求物品：" .. costItemName)
        return false
    end
    
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
    
    -- 查找并更新价格
    local found = false
    for i = 0, ThingDef.Item.BeMade.CostItems.Count - 1 do
        local costItem = ThingDef.Item.BeMade.CostItems[i]
        if costItem.name == costItemName then
            costItem.count = newCount
            found = true
            break
        end
    end
    
    -- 如果没找到，添加新的
    if not found then
        local newitem = CS.XiaWorld.ItemCostData()
        newitem.name = costItemName
        newitem.minlevel = 1
        newitem.maxlevel = 9999
        newitem.count = newCount
        ThingDef.Item.BeMade.CostItems:Add(newitem)
    end
    
    return true
end

-- 记录每个物品的购买次数
local purchaseCounts = {}
-- 记录价格刷新时间
local lastPriceRefresh = {}

-- 监听购买事件
function JYS:OnInit()
    -- 监听工作完成事件
    CS.XiaWorld.WorkMgr.Instance.WorkEnd:AddAction(function(workData, thing)
        if not thing or not thing.Def or not workData then
            return
        end
        
        -- 检查是否是ExchangePlace建筑
        if thing.Def.Name == "ExchangePlace" then
            local work = workData.Work
            if work and work.Name and work.Name == "Produce" then
                -- 获取生产的物品
                local produceDef = work.Produce
                if produceDef and produceDef.ThingDef then
                    local itemName = produceDef.ThingDef.Name
                    
                    -- 增加购买计数
                    if not purchaseCounts[itemName] then
                        purchaseCounts[itemName] = 0
                    end
                    purchaseCounts[itemName] = purchaseCounts[itemName] + 1
                    
                    -- 记录当前时间
                    lastPriceRefresh[itemName] = CS.UnityEngine.Time.time
                    
                    -- 为该物品重新生成随机价格
                    RandomizeItemPrice(itemName)
                    
                    -- 获取物品显示名称
                    local displayName = produceDef.ThingDef.ThingName and produceDef.ThingDef.ThingName.Value or itemName
                    
                    -- 在聊天框显示消息
                    if CS.XiaWorld.MainPlayer then
                        local currentCount = purchaseCounts[itemName]
                        local currentPrice = currentPrices[itemName] and currentPrices[itemName][produceDef.ThingDef.Name] or "未知"
                        
                        -- 获取原始价格
                        local originalPrice = originalPrices[itemName] and originalPrices[itemName][produceDef.ThingDef.Name] or 0
                        local newPrice = currentPrices[itemName] and currentPrices[itemName][produceDef.ThingDef.Name] or 0
                        local ratio = originalPrice > 0 and math.floor((newPrice / originalPrice) * 100) or 0
                        
                        CS.XiaWorld.MainPlayer:AddImportantMsg(
                            string.format("[灵石交换处] 已购买 %s (第%d次购买)，价格已刷新至: %d (%s%%)", 
                            displayName, currentCount, newPrice, ratio))
                    end
                    
                    print(string.format("物品 %s 已被购买，重新生成随机价格 (购买次数: %d)", 
                        itemName, purchaseCounts[itemName]))
                end
            end
        end
    end)
    
    print("JYS mod 已加载，独立价格浮动系统已启用")
end

-- 保存/加载时保存当前价格状态
function JYS:OnSave()
    local saveData = {
        originalPrices = originalPrices,
        currentPrices = currentPrices,
        purchaseCounts = purchaseCounts
    }
    return CS.SysMgr.save:SaveData("JYS_PriceData", saveData)
end

function JYS:OnLoad()
    local loadedData = CS.SysMgr.save:LoadData("JYS_PriceData")
    if loadedData and loadedData.originalPrices and loadedData.currentPrices then
        originalPrices = loadedData.originalPrices
        currentPrices = loadedData.currentPrices
        purchaseCounts = loadedData.purchaseCounts or {}
        
        -- 应用加载的价格
        for itemName, costData in pairs(currentPrices) do
            for costItemName, count in pairs(costData) do
                UpdateItemPrice(itemName, costItemName, count)
            end
        end
        
        print("JYS mod: 已加载保存的价格数据")
    else
        -- 如果没有保存的数据，重新生成价格
        InitializeRandomPrices()
    end
end

-- 添加控制台命令
function JYS:OnCommand(cmd)
    if cmd == "/jys_refresh_all" then
        -- 重新生成所有物品的价格
        for itemName, _ in pairs(originalPrices) do
            RandomizeItemPrice(itemName)
        end
        
        if CS.XiaWorld.MainPlayer then
            CS.XiaWorld.MainPlayer:AddImportantMsg("[灵石交换处] 已手动刷新所有商品价格！")
        end
        
    elseif cmd:find("^/jys_refresh ") then
        -- 刷新指定物品价格，例如: /jys_refresh Item_HardWood
        local itemName = cmd:match("/jys_refresh (.+)")
        if itemName and originalPrices[itemName] then
            RandomizeItemPrice(itemName)
            
            local thingDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, itemName)
            local displayName = thingDef and thingDef.ThingName and thingDef.ThingName.Value or itemName
            
            if CS.XiaWorld.MainPlayer then
                CS.XiaWorld.MainPlayer:AddImportantMsg(
                    string.format("[灵石交换处] 已手动刷新 %s 的价格！", displayName))
            end
        end
        
    elseif cmd == "/jys_showprices" then
        -- 显示所有物品的当前价格
        local msg = "当前物品价格列表：\n"
        for itemName, costData in pairs(originalPrices) do
            for costItemName, basePrice in pairs(costData) do
                local currentPrice = currentPrices[itemName] and currentPrices[itemName][costItemName] or basePrice
                local ratio = basePrice > 0 and math.floor((currentPrice / basePrice) * 100) or 0
                local purchaseCount = purchaseCounts[itemName] or 0
                
                local thingDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, itemName)
                local displayName = thingDef and thingDef.ThingName and thingDef.ThingName.Value or itemName
                
                msg = msg .. string.format("%s: 基础 %d -> 当前 %d (%s%%), 购买次数: %d\n", 
                    displayName, basePrice, currentPrice, ratio, purchaseCount)
            end
        end
        print(msg)
        
    elseif cmd:find("^/jys_reset ") then
        -- 重置指定物品的购买计数，例如: /jys_reset Item_HardWood
        local itemName = cmd:match("/jys_reset (.+)")
        if itemName and purchaseCounts[itemName] then
            purchaseCounts[itemName] = 0
            
            local thingDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, itemName)
            local displayName = thingDef and thingDef.ThingName and thingDef.ThingName.Value or itemName
            
            if CS.XiaWorld.MainPlayer then
                CS.XiaWorld.MainPlayer:AddImportantMsg(
                    string.format("[灵石交换处] 已重置 %s 的购买次数！", displayName))
            end
        end
        
    elseif cmd == "/jys_reset_all" then
        -- 重置所有物品的购买计数
        purchaseCounts = {}
        if CS.XiaWorld.MainPlayer then
            CS.XiaWorld.MainPlayer:AddImportantMsg("[灵石交换处] 已重置所有物品的购买次数！")
        end
    end
end
