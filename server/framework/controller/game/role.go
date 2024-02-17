/**
 ******************************************************************************
 * @file    role.go
 * @author  MakerYang
 ******************************************************************************
 */

package GameController

import (
	"Game/framework/database"
	"Game/framework/database/game_level_data"
	"Game/framework/database/game_map_data"
	"Game/framework/database/game_role_data"
	"Game/framework/utils"
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
)

type responseUserRoleList struct {
	Roles []GameRoleDataDatabase.ReturnData `json:"roles"`
}

func UserRoleList(c *gin.Context) {

	returnData := responseUserRoleList{}
	returnData.Roles = make([]GameRoleDataDatabase.ReturnData, 0)

	CheckUserAgent := Utils.CheckUserAgent(c.Request.Header.Get("User-Agent"))
	if !CheckUserAgent {
		Utils.Warning(c, 10000, "非法的请求", Utils.EmptyData{})
		return
	}

	GameId, GameAccountId, CheckGame := Utils.CheckGame(c.Request.Header.Get("Game-Token"))
	if !CheckGame {
		Utils.Warning(c, 10000, "非法的请求", Utils.EmptyData{})
		return
	}

	Uid, CheckUid := Utils.CheckUser(c.Request.Header.Get("User-Token"))
	if !CheckUid {
		Utils.Warning(c, 10000, "非法的请求", Utils.EmptyData{})
		return
	}

	areaToken := c.DefaultQuery("token", "")
	if areaToken == "" {
		Utils.Warning(c, 10000, "非法的请求", Utils.EmptyData{})
		return
	}

	areaId, _ := Utils.DecodeId(32, areaToken)
	if len(areaId) != 3 {
		Utils.Warning(c, 10000, "非法的请求", Utils.EmptyData{})
		return
	}

	roleDatabase := Database.New(GameRoleDataDatabase.TableName)
	where := fmt.Sprintf("role_game_account_id = %d AND role_game_id = %d AND role_area_id = %d AND role_user_account_id = %d AND role_status = %d", GameAccountId, GameId, areaId[0], Uid, 2)
	roleData := make([]GameRoleDataDatabase.Data, 0)
	err := roleDatabase.ListData(&roleData, where, "role_id DESC", 9)
	if err == nil {
		for _, v := range roleData {
			item := GameRoleDataDatabase.FormatData(&v)
			// 地图数据查询
			mapDatabase := Database.New(GameMapDataDatabase.TableName)
			where = fmt.Sprintf("map_game_account_id = %d AND map_game_id = %d AND map_area_id = %d AND map_number = %q", GameAccountId, GameId, areaId[0], item.RoleMap)
			mapData := GameMapDataDatabase.Data{}
			err := mapDatabase.GetData(&mapData, where, "")
			if err == nil {
				if item.RoleMapX == 0 || item.RoleMapY == 0 {
					item.RoleMapName = mapData.MapName
					item.RoleMapX = mapData.MapDefaultX
					item.RoleMapY = mapData.MapDefaultY
				}
			}
			// 等级数据查询
			levelDatabase := Database.New(GameLevelDataDatabase.TableName)
			where = fmt.Sprintf("level_game_account_id = %d AND level_game_id = %d AND level_area_id = %d AND level_career = %q AND (level_min >= %d AND level_max > %d)", GameAccountId, GameId, areaId[0], item.RoleCareer, item.RoleAssetExperience, item.RoleAssetExperience)
			levelData := GameLevelDataDatabase.Data{}
			err = levelDatabase.GetData(&levelData, where, "")
			if err == nil {
				item.RoleAssetLevel = levelData.LevelName
				item.RoleAssetLifeMax = levelData.LevelLifeValue
				item.RoleAssetMagicMax = levelData.LevelMagicValue
				item.RoleAssetExperienceMax = levelData.LevelMax
			}
			returnData.Roles = append(returnData.Roles, item)
		}
	}

	Utils.Success(c, returnData)
	return
}

type requestUserRoleCreate struct {
	Token    string `json:"token"`
	Nickname string `json:"nickname"`
	Gender   string `json:"gender"`
	Career   string `json:"career"`
}

type responseUserRoleCreate struct {
	Role GameRoleDataDatabase.ReturnData `json:"role"`
}

func UserRoleCreate(c *gin.Context) {

	returnData := responseUserRoleCreate{}

	CheckUserAgent := Utils.CheckUserAgent(c.Request.Header.Get("User-Agent"))
	if !CheckUserAgent {
		Utils.Warning(c, 10000, "非法的请求", returnData)
		return
	}

	GameId, GameAccountId, CheckGame := Utils.CheckGame(c.Request.Header.Get("Game-Token"))
	if !CheckGame {
		Utils.Warning(c, 10000, "非法的请求", returnData)
		return
	}

	Uid, CheckUid := Utils.CheckUser(c.Request.Header.Get("User-Token"))
	if !CheckUid {
		Utils.Warning(c, 10000, "非法的请求", returnData)
		return
	}

	jsonData := requestUserRoleCreate{}
	requestJson, _ := ioutil.ReadAll(c.Request.Body)
	fmt.Println(string(requestJson))
	err := json.Unmarshal(requestJson, &jsonData)
	if err != nil {
		Utils.Warning(c, 10000, "非法的请求", returnData)
		return
	}

	areaId, _ := Utils.DecodeId(32, jsonData.Token)
	if len(areaId) != 3 {
		Utils.Warning(c, 10000, "非法的请求", returnData)
		return
	}

	roleDatabase := Database.New(GameRoleDataDatabase.TableName)
	where := fmt.Sprintf("role_game_account_id = %d AND role_game_id = %d AND role_area_id = %d AND role_nickname = %q", GameAccountId, GameId, areaId[0], jsonData.Nickname)
	roleData := GameRoleDataDatabase.Data{}
	err = roleDatabase.GetData(&roleData, where, "")
	if err == nil || roleData.RoleId > 0 {
		Utils.Warning(c, 10000, "昵称已经被使用，请换一个", returnData)
		return
	}

	setData := &GameRoleDataDatabase.Data{}
	setData.RoleGameId = GameId
	setData.RoleGameAccountId = GameAccountId
	setData.RoleAreaId = areaId[0]
	setData.RoleUserAccountId = Uid
	setData.RoleNickname = jsonData.Nickname
	setData.RoleCareer = jsonData.Career
	setData.RoleGender = jsonData.Gender
	setData.RoleAngle = 2
	setData.RoleMap = "001"
	setData.RoleMapX = 0
	setData.RoleMapY = 0
	setData.RoleAssetLife = 1
	setData.RoleAssetMagic = 1
	setData.RoleAssetExperience = 1
	setData.RoleBodyClothe = "000"
	setData.RoleBodyWeapon = "000"
	setData.RoleBodyWing = "000"
	setData.RoleGroupId = 1
	setData.RoleStatus = 2
	err = roleDatabase.CreateData(setData)
	if err != nil || setData.RoleId == 0 {
		Utils.Warning(c, 10000, "角色创建失败，请重新尝试", returnData)
		return
	}

	where = fmt.Sprintf("role_id = %d", setData.RoleId)
	roleInfo := GameRoleDataDatabase.Data{}
	err = roleDatabase.GetData(&roleInfo, where, "")
	if err != nil || roleInfo.RoleId == 0 {
		Utils.Warning(c, 10000, "角色创建失败，请重新尝试", returnData)
		return
	}

	returnData.Role = GameRoleDataDatabase.FormatData(&roleInfo)

	// 地图数据查询
	mapDatabase := Database.New(GameMapDataDatabase.TableName)
	where = fmt.Sprintf("map_game_account_id = %d AND map_game_id = %d AND map_area_id = %d AND map_number = %q", GameAccountId, GameId, areaId[0], returnData.Role.RoleMap)
	mapData := GameMapDataDatabase.Data{}
	err = mapDatabase.GetData(&mapData, where, "")
	if err == nil {
		if returnData.Role.RoleMapX == 0 || returnData.Role.RoleMapY == 0 {
			returnData.Role.RoleMapName = mapData.MapName
			returnData.Role.RoleMapX = mapData.MapDefaultX
			returnData.Role.RoleMapY = mapData.MapDefaultY
		}
	}

	// 等级数据查询
	levelDatabase := Database.New(GameLevelDataDatabase.TableName)
	where = fmt.Sprintf("level_game_account_id = %d AND level_game_id = %d AND level_area_id = %d AND level_career = %q AND (level_min >= %d AND level_max > %d)", GameAccountId, GameId, areaId[0], returnData.Role.RoleCareer, returnData.Role.RoleAssetExperience, returnData.Role.RoleAssetExperience)
	levelData := GameLevelDataDatabase.Data{}
	err = levelDatabase.GetData(&levelData, where, "")
	if err == nil {
		returnData.Role.RoleAssetLevel = levelData.LevelName
		returnData.Role.RoleAssetLifeMax = levelData.LevelLifeValue
		returnData.Role.RoleAssetMagicMax = levelData.LevelMagicValue
		returnData.Role.RoleAssetExperienceMax = levelData.LevelMax
	}

	Utils.Success(c, returnData)
	return
}
