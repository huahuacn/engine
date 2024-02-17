/**
 ******************************************************************************
 * @file    game_role_data.go
 * @author  MakerYang
 ******************************************************************************
 */

package GameRoleDataDatabase

import (
	"Game/framework/database"
	"Game/framework/utils"
)

var TableName = "game_role_data"

type Data struct {
	RoleId              int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:role_id" json:"role_id"`
	RoleGameId          int    `gorm:"column:role_game_id" json:"role_game_id"`
	RoleGameAccountId   int    `gorm:"column:role_game_account_id" json:"role_game_account_id"`
	RoleUserAccountId   int    `gorm:"column:role_user_account_id" json:"role_user_account_id"`
	RoleAreaId          int    `gorm:"column:role_area_id" json:"role_area_id"`
	RoleNickname        string `gorm:"column:role_nickname" json:"role_nickname"`
	RoleCareer          string `gorm:"column:role_career" json:"role_career"`
	RoleGender          string `gorm:"column:role_gender" json:"role_gender"`
	RoleAngle           int    `gorm:"column:role_angle" json:"role_angle"`
	RoleMap             string `gorm:"column:role_map" json:"role_map"`
	RoleMapX            int    `gorm:"column:role_map_x" json:"role_map_x"`
	RoleMapY            int    `gorm:"column:role_map_y" json:"role_map_y"`
	RoleAssetLife       int    `gorm:"column:role_asset_life" json:"role_asset_life"`
	RoleAssetMagic      int    `gorm:"column:role_asset_magic" json:"role_asset_magic"`
	RoleAssetExperience int    `gorm:"column:role_asset_experience" json:"role_asset_experience"`
	RoleBodyClothe      string `gorm:"column:role_body_clothe" json:"role_body_clothe"`
	RoleBodyWeapon      string `gorm:"column:role_body_weapon" json:"role_body_weapon"`
	RoleBodyWing        string `gorm:"column:role_body_wing" json:"role_body_wing"`
	RoleGroupId         int    `gorm:"column:role_group_id" json:"role_group_id"`
	RoleStatus          int    `gorm:"column:role_status" json:"role_status"`
	Database.DefaultField
}

type ReturnData struct {
	Token                  string `json:"token"`
	RoleNickname           string `json:"role_nickname"`
	RoleCareer             string `json:"role_career"`
	RoleGender             string `json:"role_gender"`
	RoleAngle              int    `json:"role_angle"`
	RoleMap                string `json:"role_map"`
	RoleMapName            string `json:"role_map_name"`
	RoleMapX               int    `json:"role_map_x"`
	RoleMapY               int    `json:"role_map_y"`
	RoleAssetLevel         int    `json:"role_asset_level"`
	RoleAssetLife          int    `json:"role_asset_life"`
	RoleAssetLifeMax       int    `json:"role_asset_life_max"`
	RoleAssetMagic         int    `json:"role_asset_magic"`
	RoleAssetMagicMax      int    `json:"role_asset_magic_max"`
	RoleAssetExperience    int    `json:"role_asset_experience"`
	RoleAssetExperienceMax int    `json:"role_asset_experience_max"`
	RoleBodyClothe         string `json:"role_body_clothe"`
	RoleBodyWeapon         string `json:"role_body_weapon"`
	RoleBodyWing           string `json:"role_body_wing"`
}

func FormatData(dataStruct *Data) ReturnData {

	data := ReturnData{}

	data.Token = Utils.EncodeId(32, dataStruct.RoleId, dataStruct.RoleGameId, dataStruct.RoleGameAccountId, dataStruct.RoleUserAccountId, dataStruct.RoleAreaId)
	data.RoleNickname = dataStruct.RoleNickname
	data.RoleCareer = dataStruct.RoleCareer
	data.RoleGender = dataStruct.RoleGender
	data.RoleAngle = dataStruct.RoleAngle
	data.RoleMap = dataStruct.RoleMap
	data.RoleMapX = dataStruct.RoleMapX
	data.RoleMapX = dataStruct.RoleMapY
	data.RoleAssetLevel = 0
	data.RoleAssetLife = dataStruct.RoleAssetLife
	data.RoleAssetLifeMax = 0
	data.RoleAssetMagic = dataStruct.RoleAssetMagic
	data.RoleAssetMagicMax = 0
	data.RoleAssetExperience = dataStruct.RoleAssetExperience
	data.RoleAssetExperienceMax = 0
	data.RoleBodyClothe = dataStruct.RoleBodyClothe
	data.RoleBodyWeapon = dataStruct.RoleBodyWeapon
	data.RoleBodyWing = dataStruct.RoleBodyWing

	return data
}
