/**
 ******************************************************************************
 * @file    game_area_data.go
 * @author  MakerYang
 ******************************************************************************
 */

package GameAreaData

import (
	"Game/framework/database"
	"Game/framework/utils"
)

var TableName = "game_area_data"

type Data struct {
	AreaId        int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:area_id" json:"area_id"`
	AreaAccountId int    `gorm:"column:area_account_id" json:"area_account_id"`
	AreaGameId    int    `gorm:"column:area_game_id" json:"area_game_id"`
	AreaName      string `gorm:"column:area_name" json:"area_name"`
	AreaStatus    int    `gorm:"column:area_status" json:"area_status"`
	Database.DefaultField
}

type ReturnData struct {
	Token      string `json:"token"`
	AreaName   string `json:"area_name"`
	AreaStatus int    `json:"area_status"`
}

func FormatData(dataStruct *Data) ReturnData {

	data := ReturnData{}

	data.Token = Utils.EncodeId(32, dataStruct.AreaId, dataStruct.AreaGameId, dataStruct.AreaAccountId)
	data.AreaName = dataStruct.AreaName
	data.AreaStatus = dataStruct.AreaStatus

	return data
}
