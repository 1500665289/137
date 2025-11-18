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

local JYS = GameMain:GetMod("JYS");

local function AddCostItem(ItemName,CostItemName,CostItemCount)
	local ThingDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, ItemName);
	if not ThingDef then
		print("不存在的物品：" .. ItemName)
	end
	if not CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, CostItemName) then
		print("不存在的需求物品：" .. CostItemName)
	end
	--修复重新加载存档导致的重复修改的bug。
	if ThingDef.Item and ThingDef.Item.BeMade and ThingDef.Item.BeMade.CostItems then
		for k,v in pairs(ThingDef.Item.BeMade.CostItems) do
			if v.name == CostItemName then
				return;
			end
		end
	end

	local newitem = CS.XiaWorld.ItemCostData()
	newitem.name = CostItemName;
	newitem.minlevel = 1;
	newitem.maxlevel = 9999;
	newitem.count = CostItemCount;

	if not ThingDef.Item then
		ThingDef.Item = CS.XiaWorld.ItemData();
	end
	--手动处理DrugBase子类别的BUG。检测 如果DrugBase的子类别的BeMade是一致的，重新创建一个空白的。
	if ThingDef.Parent == "DrugBase" then
		local ParentDef = CS.XiaWorld.ThingMgr.Instance:GetDef(CS.XiaWorld.g_emThingType.Item, "DrugBase");
		if ThingDef.Item.BeMade == ParentDef.Item.BeMade then
			ThingDef.Item.BeMade = CS.XiaWorld.ThingBeMadeData();
			ThingDef.Item.BeMade.WorkToMake = 100;
			ThingDef.Item.BeMade.CostStuffCount = 0;
		end
	end
	
	if not ThingDef.Item.BeMade then
		ThingDef.Item.BeMade = CS.XiaWorld.ThingBeMadeData();
	end
	if not ThingDef.Item.BeMade.CostItems then
		ThingDef.Item.BeMade.CostItems = CS.System.Collections.Generic["List`1[XiaWorld.ItemCostData]"]()
	end
	ThingDef.Item.BeMade.CostItems:Add(newitem)
end

function JYS:OnBeforeInit()
	AddCostItem("Item_HardWood","Item_LingStone", 100);--金丝木
	AddCostItem("Item_LingWood","Item_LingStone", 300);--灵木
	AddCostItem("Item_ParasolWood","Item_LingStone", 500);--梧桐木
	AddCostItem("Item_IronRock","Item_LingStone", 10);--铁矿
	AddCostItem("Item_CopperRock","Item_LingStone", 100);--火铜矿石
	AddCostItem("Item_SilverRock","Item_LingStone", 100);--寒晶矿石
	AddCostItem("Item_DarksteelRock","Item_LingStone", 500);--玄铁
	AddCostItem("Item_StarEssence","Item_LingStone", 1000);--星髓
	AddCostItem("Item_BrownRock","Item_LingStone", 10);--棕石
	AddCostItem("Item_Marble","Item_LingStone", 250);--大理石
	AddCostItem("Item_Jade","Item_LingStone", 500);--玉石
	AddCostItem("Item_SkyStone","Item_LingStone", 5000);--天柱石
	AddCostItem("Item_SoulCrystalYou","Item_LingStone", 300);--幽珀
	AddCostItem("Item_SoulCrystalLing","Item_LingStone", 300);--灵珀
	AddCostItem("Item_SoulCrystalNing","Item_LingStone", 300);--宁珀
	AddCostItem("Item_Yao_RabbitLuck","Item_LingStone", 10000);--兔妖的脚
	AddCostItem("Item_Yao_WolfAtk","Item_LingStone", 10000);--妖狼的尖牙
	AddCostItem("Item_Yao_SnakeHanLin","Item_LingStone", 10000);--妖蛇的寒鳞
	AddCostItem("Item_Yao_BearPiMao","Item_LingStone", 10000);--熊妖的脖颈毛
	AddCostItem("Item_Yao_TurtleKe","Item_LingStone", 10000);--巨龟的坚甲
	AddCostItem("Item_DragonShit","Item_LingCrystal", 100);--天龙砂
	AddCostItem("Item_DragonScale","Item_LingCrystal", 1000);--龙鳞
	AddCostItem("Item_ZaoHuaYuLu","Item_LingStone", 50000);--造化玉露--灵石
	AddCostItem("Item_HuoEssence","Item_LingCrystal", 120);--朱果--灵晶
	AddCostItem("Item_ShuiEssence","Item_LingCrystal", 120);--五色金莲--灵晶
	AddCostItem("Item_MuEssence","Item_LingCrystal", 120);--木枯藤--灵晶
	AddCostItem("Item_JinEssence","Item_LingCrystal", 120);--琅琊果--灵晶
	AddCostItem("Item_TuEssence","Item_LingCrystal", 120);--赭黄精--灵晶
	AddCostItem("Item_EarthEssence","Item_LingStone", 1000);--地母灵液--玉石
	AddCostItem("Item_LifeStream","Item_LingStone", 1000);--长生泉--灵木
	AddCostItem("Item_SoulPearl","Item_LingCrystal", 100);--玄牝珠--
	AddCostItem("Item_MonsterBlood","Item_LingStone", 100);--妖灵血--大理石
	AddCostItem("Item_Cinnabar","Item_LingStone", 30);--朱砂--灵石
	AddCostItem("Item_LingMuXueJie","Item_LingCrystal", 10);--灵木血竭--灵晶
	AddCostItem("Item_EarthEssence_1","Item_LingCrystal", 200);--灵髓脂--灵晶
	AddCostItem("Item_YuanHunLu","Item_LingCrystal", 200);--元魂露--灵晶
	AddCostItem("Item_YanDaoGuo","Item_LingCrystal", 300);--演道果--灵晶
	AddCostItem("Item_EarthEssence1","Item_LingCrystal", 10);--邪脉血泉--灵晶
	AddCostItem("Item_EarthEssence1_1","Item_LingCrystal", 200);--血髓脂--灵晶
	AddCostItem("Item_XieHunLu","Item_LingCrystal", 200);--邪魂露--灵晶
	AddCostItem("Item_QieDaoGuo","Item_LingCrystal", 300);--窃道果--灵晶
	AddCostItem("Item_ThunderAir","Item_LingCrystal", 2000);--天劫之息--灵晶
	AddCostItem("Item_StoneBox2","Item_LingCrystal", 100);--古旧石匣--灵晶
	AddCostItem("Item_XianBone","Item_LingCrystal", 1000);--仙人遗骨--灵晶
	AddCostItem("Item_ZaoHuaYuZi","Item_LingCrystal", 50);--造化玉籽--灵晶
end