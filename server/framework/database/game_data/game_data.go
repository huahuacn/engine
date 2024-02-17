/**
 ******************************************************************************
 * @file    game_data.go
 * @author  MakerYang
 ******************************************************************************
 */

package GameDataDatabase

import (
	"Game/framework/database"
	"Game/framework/utils"
)

var TableName = "game_data"

type Data struct {
	GameId        int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:game_id" json:"game_id"`
	GameAccountId int    `gorm:"column:game_account_id" json:"game_account_id"`
	GameName      string `gorm:"column:game_name" json:"game_name"`
	GameStatus    int    `gorm:"column:game_status" json:"game_status"`
	Database.DefaultField
}

type ReturnData struct {
	Token         string `json:"token"`
	GameId        int    `json:"game_id"`
	GameAccountId int    `json:"game_account_id"`
	GameName      string `json:"game_name"`
	GameStatus    int    `json:"game_status"`
}

func FormatData(dataStruct *Data) ReturnData {

	data := ReturnData{}

	data.Token = Utils.EncodeId(128, dataStruct.GameId, dataStruct.GameAccountId)
	data.GameId = dataStruct.GameId
	data.GameAccountId = dataStruct.GameAccountId
	data.GameName = dataStruct.GameName
	data.GameStatus = dataStruct.GameStatus

	return data
}
