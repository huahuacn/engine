/**
 ******************************************************************************
 * @file    game_level_data.go
 * @author  MakerYang
 ******************************************************************************
 */

package GameLevelDataDatabase

import (
	"Game/framework/database"
	"Game/framework/utils"
)

var TableName = "game_level_data"

type Data struct {
	LevelId            int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:level_id" json:"level_id"`
	LevelGameId        int    `gorm:"column:level_game_id" json:"level_game_id"`
	LevelGameAccountId int    `gorm:"column:level_game_account_id" json:"level_game_account_id"`
	LevelAreaId        int    `gorm:"column:level_area_id" json:"level_area_id"`
	LevelCareer        string `gorm:"column:level_career" json:"level_career"`
	LevelName          int    `gorm:"column:level_name" json:"level_name"`
	LevelMin           int    `gorm:"column:level_min" json:"level_min"`
	LevelMax           int    `gorm:"column:level_max" json:"level_max"`
	LevelLifeValue     int    `gorm:"column:level_life_value" json:"level_life_value"`
	LevelMagicValue    int    `gorm:"column:level_magic_value" json:"level_magic_value"`
	LevelStatus        int    `gorm:"column:level_status" json:"level_status"`
	Database.DefaultField
}

type ReturnData struct {
	Token           string `json:"token"`
	LevelName       int    `json:"level_name"`
	LevelMin        int    `json:"level_min"`
	LevelMax        int    `json:"level_max"`
	LevelLifeValue  int    `json:"level_life_value"`
	LevelMagicValue int    `json:"level_magic_value"`
}

func FormatData(dataStruct *Data) ReturnData {

	data := ReturnData{}

	data.Token = Utils.EncodeId(32, dataStruct.LevelId, dataStruct.LevelGameId, dataStruct.LevelGameAccountId)
	data.LevelName = dataStruct.LevelName
	data.LevelMin = dataStruct.LevelMin
	data.LevelMax = dataStruct.LevelMax
	data.LevelLifeValue = dataStruct.LevelLifeValue
	data.LevelMagicValue = dataStruct.LevelMagicValue

	return data
}
