/**
 ******************************************************************************
 * @file    game_map_data.go
 * @author  MakerYang
 ******************************************************************************
 */

package GameMapDataDatabase

import (
	"Game/framework/database"
	"Game/framework/utils"
)

var TableName = "game_map_data"

type Data struct {
	MapId            int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:map_id" json:"map_id"`
	MapGameId        int    `gorm:"column:map_game_id" json:"map_game_id"`
	MapGameAccountId int    `gorm:"column:map_game_account_id" json:"map_game_account_id"`
	MapAreaId        int    `gorm:"column:map_area_id" json:"map_area_id"`
	MapNumber        string `gorm:"column:map_number" json:"map_number"`
	MapName          string `gorm:"column:map_name" json:"map_name"`
	MapDefaultX      int    `gorm:"column:map_default_x" json:"map_default_x"`
	MapDefaultY      int    `gorm:"column:map_default_y" json:"map_default_y"`
	MapStatus        int    `gorm:"column:map_status" json:"map_status"`
	Database.DefaultField
}

type ReturnData struct {
	Token       string `json:"token"`
	MapNumber   string `json:"map_number"`
	MapName     string `json:"map_name"`
	MapDefaultX int    `json:"map_default_x"`
	MapDefaultY int    `json:"map_default_y"`
}

func FormatData(dataStruct *Data) ReturnData {

	data := ReturnData{}

	data.Token = Utils.EncodeId(32, dataStruct.MapId, dataStruct.MapGameId, dataStruct.MapGameAccountId)
	data.MapNumber = dataStruct.MapNumber
	data.MapName = dataStruct.MapName
	data.MapDefaultX = dataStruct.MapDefaultX
	data.MapDefaultY = dataStruct.MapDefaultY

	return data
}
