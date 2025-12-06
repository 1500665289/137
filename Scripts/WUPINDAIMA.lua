local JYS = GameMain:GetMod("JYS")

-- 移除购买计数相关的所有逻辑，只保留基础价格设置

function JYS:OnBeforeInit()
    -- 设置物品基础价格（已直接计算5倍价格）
    AddCostItem("Item_HardWood", "Item_LingStone", 7500) --金丝木
    AddCostItem("Item_LingWood", "Item_LingStone", 15000) --灵木
    AddCostItem("Item_ParasolWood", "Item_LingStone", 25000) --梧桐木
    AddCostItem("Item_IronRock", "Item_LingStone", 500) --铁矿
    AddCostItem("Item_CopperRock", "Item_LingStone", 1000) --火铜矿石
    AddCostItem("Item_SilverRock", "Item_LingStone", 1000) --寒晶矿石
    AddCostItem("Item_DarksteelRock", "Item_LingStone", 2500) --玄铁
    AddCostItem("Item_StarEssence", "Item_LingStone", 5000) --星髓
    AddCostItem("Item_BrownRock", "Item_LingStone", 500) --棕石
    AddCostItem("Item_Marble", "Item_LingStone", 1250) --大理石
    AddCostItem("Item_Jade", "Item_LingStone", 2500) --玉石
    AddCostItem("Item_SkyStone", "Item_LingStone", 25000) --天柱石
    AddCostItem("Item_SoulCrystalYou", "Item_LingStone", 1500) --幽珀
    AddCostItem("Item_SoulCrystalLing", "Item_LingStone", 1500) --灵珀
    AddCostItem("Item_SoulCrystalNing", "Item_LingStone", 1500) --宁珀
    AddCostItem("Item_Yao_RabbitLuck", "Item_LingStone", 50000) --兔妖的脚
    AddCostItem("Item_Yao_WolfAtk", "Item_LingStone", 50000) --妖狼的尖牙
    AddCostItem("Item_Yao_SnakeHanLin", "Item_LingStone", 50000) --妖蛇的寒鳞
    AddCostItem("Item_Yao_BearPiMao", "Item_LingStone", 50000) --熊妖的脖颈毛
    AddCostItem("Item_Yao_TurtleKe", "Item_LingStone", 50000) --巨龟的坚甲
    AddCostItem("Item_DragonShit", "Item_LingCrystal", 500) --天龙砂
    AddCostItem("Item_DragonScale", "Item_LingCrystal", 5000) --龙鳞
    AddCostItem("Item_ZaoHuaYuLu", "Item_LingStone", 250000) --造化玉露--灵石
    AddCostItem("Item_HuoEssence", "Item_LingCrystal", 600) --朱果--灵晶
    AddCostItem("Item_ShuiEssence", "Item_LingCrystal", 600) --五色金莲--灵晶
    AddCostItem("Item_MuEssence", "Item_LingCrystal", 600) --木枯藤--灵晶
    AddCostItem("Item_JinEssence", "Item_LingCrystal", 600) --琅琊果--灵晶
    AddCostItem("Item_TuEssence", "Item_LingCrystal", 600) --赭黄精--灵晶
    AddCostItem("Item_EarthEssence", "Item_LingStone", 5000) --地母灵液--玉石
    AddCostItem("Item_LifeStream", "Item_LingStone", 5000) --长生泉--灵木
    AddCostItem("Item_SoulPearl", "Item_LingCrystal", 500) --玄牝珠--
    AddCostItem("Item_MonsterBlood", "Item_LingStone", 500) --妖灵血--大理石
    AddCostItem("Item_Cinnabar", "Item_LingStone", 150) --朱砂--灵石
    AddCostItem("Item_LingMuXueJie", "Item_LingCrystal", 50) --灵木血竭--灵晶
    AddCostItem("Item_EarthEssence_1", "Item_LingCrystal", 1000) --灵髓脂--灵晶
    AddCostItem("Item_YuanHunLu", "Item_LingCrystal", 1000) --元魂露--灵晶
    AddCostItem("Item_YanDaoGuo", "Item_LingCrystal", 1500) --演道果--灵晶
    AddCostItem("Item_EarthEssence1", "Item_LingCrystal", 50) --邪脉血泉--灵晶
    AddCostItem("Item_EarthEssence1_1", "Item_LingCrystal", 1000) --血髓脂--灵晶
    AddCostItem("Item_XieHunLu", "Item_LingCrystal", 1000) --邪魂露--灵晶
    AddCostItem("Item_QieDaoGuo", "Item_LingCrystal", 1500) --窃道果--灵晶
    AddCostItem("Item_ThunderAir", "Item_LingCrystal", 10000) --天劫之息--灵晶
    AddCostItem("Item_StoneBox2", "Item_LingCrystal", 500) --古旧石匣--灵晶
    AddCostItem("Item_XianBone", "Item_LingCrystal", 5000) --仙人遗骨--灵晶
    AddCostItem("Item_ZaoHuaYuZi", "Item_LingCrystal", 250) --造化玉籽--灵晶
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
    
    -- 移除价格递增逻辑，直接使用固定价格
    local finalCount = CostItemCount
    
    -- 修复重新加载存档导致的重复修改的bug
    if ThingDef.Item and ThingDef.Item.BeMade and ThingDef.Item.BeMade.CostItems then
        local found = false
        for i = 0, ThingDef.Item.BeMade.CostItems.Count - 1 do
            local costItem = ThingDef.Item.BeMade.CostItems[i]
            if costItem.name == CostItemName then
                -- 更新现有成本项的数量
                costItem.count = finalCount
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
            newitem.count = finalCount
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
        newitem.count = finalCount
        
        ThingDef.Item.BeMade.CostItems:Add(newitem)
    end
    
    print(string.format("设置物品 %s 的成本: %s x %d", ItemName, CostItemName, finalCount))
end

function JYS:OnInit()
    -- 不需要初始化购买计数
end

function JYS:OnLoad()
    -- 不需要加载购买计数
end
