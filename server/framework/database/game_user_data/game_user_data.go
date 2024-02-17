/**
 ******************************************************************************
 * @file    game_user_data.go
 * @author  MakerYang
 ******************************************************************************
 */

package GameUserDataDatabase

import (
	"Game/framework/database"
	"Game/framework/utils"
)

var TableName = "game_user_data"

type Data struct {
	UserId            int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:user_id" json:"user_id"`
	UserGameId        int    `gorm:"column:user_game_id" json:"user_game_id"`
	UserGameAccountId int    `gorm:"column:user_game_account_id" json:"user_game_account_id"`
	UserAccount       string `gorm:"column:user_account" json:"user_account"`
	UserPassword      string `gorm:"column:user_password" json:"user_password"`
	UserName          string `gorm:"column:user_name" json:"user_name"`
	UserNumber        string `gorm:"column:user_number" json:"user_number"`
	UserQuestionA     string `gorm:"column:user_question_a" json:"user_question_a"`
	UserQuestionB     string `gorm:"column:user_question_b" json:"user_question_b"`
	UserAnswerA       string `gorm:"column:user_answer_a" json:"user_answer_a"`
	UserAnswerB       string `gorm:"column:user_answer_b" json:"user_answer_b"`
	UserStatus        int    `gorm:"column:user_status" json:"user_status"`
	Database.DefaultField
}

type ReturnData struct {
	Token string `json:"token"`
}

func FormatData(dataStruct *Data) ReturnData {

	data := ReturnData{}

	data.Token = Utils.EncodeId(32, dataStruct.UserId, dataStruct.UserGameId, dataStruct.UserGameAccountId)

	return data
}
