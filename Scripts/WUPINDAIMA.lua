local JYS = GameMain:GetMod("JYS")

-- 初始化时设置固定价格
function JYS:OnBeforeInit()
    -- 设置物品固定价格
    SetItemPrice("Item_HardWood", "Item_LingStone", 7500) --金丝木
    SetItemPrice("Item_LingWood", "Item_LingStone", 15000) --灵木
    SetItemPrice("Item_ParasolWood", "Item_LingStone", 25000) --梧桐木
    SetItemPrice("Item_IronRock", "Item_LingStone", 500) --铁矿
    SetItemPrice("Item_CopperRock", "Item_LingStone", 1000) --火铜矿石
    SetItemPrice("Item_SilverRock", "Item_LingStone", 1000) --寒晶矿石
    SetItemPrice("Item_DarksteelRock", "Item_LingStone", 2500) --玄铁
    SetItemPrice("Item_StarEssence", "Item_LingStone", 5000) --星髓
    SetItemPrice("Item_BrownRock", "Item_LingStone", 500) --棕石
    SetItemPrice("Item_Marble", "Item_LingStone", 1250) --大理石
    SetItemPrice("Item_Jade", "Item_LingStone", 2500) --玉石
    SetItemPrice("Item_SkyStone", "Item_LingStone", 25000) --天柱石
    SetItemPrice("Item_SoulCrystalYou", "Item_LingStone", 1500) --幽珀
    SetItemPrice("Item_SoulCrystalLing", "Item_LingStone", 1500) --灵珀
    SetItemPrice("Item_SoulCrystalNing", "Item_LingStone", 1500) --宁珀
    SetItemPrice("Item_Yao_RabbitLuck", "Item_LingStone", 50000) --兔妖的脚
    SetItemPrice("Item_Yao_WolfAtk", "Item_LingStone", 50000) --妖狼的尖牙
    SetItemPrice("Item_Yao_SnakeHanLin", "Item_LingStone", 50000) --妖蛇的寒鳞
    SetItemPrice("Item_Yao_BearPiMao", "Item_LingStone", 50000) --熊妖的脖颈毛
    SetItemPrice("Item_Yao_TurtleKe", "Item_LingStone", 50000) --巨龟的坚甲
    SetItemPrice("Item_DragonShit", "Item_LingCrystal", 500) --天龙砂
    SetItemPrice("Item_DragonScale", "Item_LingCrystal", 5000) --龙鳞
    SetItemPrice("Item_ZaoHuaYuLu", "Item_LingStone", 250000) --造化玉露
    SetItemPrice("Item_HuoEssence", "Item_LingCrystal", 600) --朱果
    SetItemPrice("Item_ShuiEssence", "Item_LingCrystal", 600) --五色金莲
    SetItemPrice("Item_MuEssence", "Item_LingCrystal", 600) --木枯藤
    SetItemPrice("Item_JinEssence", "Item_LingCrystal", 600) --琅琊果
    SetItemPrice("Item_TuEssence", "Item_LingCrystal", 600) --赭黄精
    SetItemPrice("Item_EarthEssence", "Item_LingStone", 5000) --地母灵液
    SetItemPrice("Item_LifeStream", "Item_LingStone", 5000) --长生泉
    SetItemPrice("Item_SoulPearl", "Item_LingCrystal", 500) --玄牝珠
    SetItemPrice("Item_MonsterBlood", "Item_LingStone", 500) --妖灵血
    SetItemPrice("Item_Cinnabar", "Item_LingStone", 150) --朱砂
    SetItemPrice("Item_LingMuXueJie", "Item_LingCrystal", 50) --灵木血竭
    SetItemPrice("Item_EarthEssence_1", "Item_LingCrystal", 1000) --灵髓脂
    SetItemPrice("Item_YuanHunLu", "Item_LingCrystal", 1000) --元魂露
    SetItemPrice("Item_YanDaoGuo", "Item_LingCrystal", 1500) --演道果
    SetItemPrice("Item_EarthEssence1", "Item_LingCrystal", 50) --邪脉血泉
    SetItemPrice("Item_EarthEssence1_1", "Item_LingCrystal", 1000) --血髓脂
    SetItemPrice("Item_XieHunLu", "Item_LingCrystal", 1000) --邪魂露
    SetItemPrice("Item_QieDaoGuo", "Item_LingCrystal", 1500) --窃道果
    SetItemPrice("Item_ThunderAir", "Item_LingCrystal", 10000) --天劫之息
    SetItemPrice("Item_StoneBox2", "Item_LingCrystal", 500) --古旧石匣
    SetItemPrice("Item_XianBone", "Item_LingCrystal", 5000) --仙人遗骨
    SetItemPrice("Item_ZaoHuaYuZi", "Item_LingCrystal", 250) --造化玉籽
    
    print("JYS mod: 基础购买功能已初始化")
end

-- 设置物品价格
function SetItemPrice(itemName, costItemName, count)
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
            costItem.count = count
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
        newitem.count = count
        ThingDef.Item.BeMade.CostItems:Add(newitem)
    end
    
    return true
end

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
                    
                    -- 获取物品显示名称
                    local displayName = produceDef.ThingDef.ThingName and produceDef.ThingDef.ThingName.Value or itemName
                    
                    -- 在聊天框显示消息
                    if CS.XiaWorld.MainPlayer then
                        CS.XiaWorld.MainPlayer:AddImportantMsg(
                            string.format("[灵石交换处] 已购买 %s", displayName))
                    end
                    
                    print(string.format("物品 %s 已被购买", itemName))
                end
            end
        end
    end)
    
    print("JYS mod 已加载，基础购买功能已启用")
end
