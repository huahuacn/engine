/**
 ******************************************************************************
 * @file    account_data.go
 * @author  MakerYang
 ******************************************************************************
 */

package AccountDataDatabase

import (
	"Game/framework/database"
	"Game/framework/utils"
)

var TableName = "account_data"

type Data struct {
	AccountId              int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:account_id" json:"account_id"`
	AccountPhone           string `gorm:"column:account_phone" json:"account_phone"`
	AccountMail            string `gorm:"column:account_mail" json:"account_mail"`
	AccountNickname        string `gorm:"column:account_nickname" json:"account_nickname"`
	AccountAvatarUrl       string `gorm:"column:account_avatar_url" json:"account_avatar_url"`
	AccountBalance         int    `gorm:"column:account_balance" json:"account_balance"`
	AccountIntegral        int    `gorm:"column:account_integral" json:"account_integral"`
	AccountWechat          string `gorm:"column:account_wechat" json:"account_wechat"`
	AccountOpenId          string `gorm:"column:account_openid" json:"account_openid"`
	AccountUnionId         string `gorm:"column:account_unionid" json:"account_unionid"`
	AccountGroupId         int    `gorm:"column:account_group_id" json:"account_group_id"`
	AccountSubscribeStatus int    `gorm:"column:account_subscribe_status" json:"account_subscribe_status"`
	AccountStatus          int    `gorm:"column:account_status" json:"account_status"`
	Database.DefaultField
}

type ReturnData struct {
	Token                  string        `json:"token"`
	AccountId              int           `json:"account_id"`
	AccountPhone           string        `json:"account_phone"`
	AccountMail            string        `json:"account_mail"`
	AccountNickname        string        `json:"account_nickname"`
	AccountAvatarUrl       string        `json:"account_avatar_url"`
	AccountWechat          string        `json:"account_wechat"`
	AccountBalance         string        `json:"account_balance"`
	AccountBalanceInt      int           `json:"account_balance_int"`
	AccountIntegral        int           `json:"account_integral"`
	Developer              developerData `json:"developer"`
	AccountOpenId          string        `json:"account_openid"`
	AccountUnionId         string        `json:"account_unionid"`
	AccountGroupId         int           `json:"account_group_id"`
	AccountSubscribeStatus int           `json:"account_subscribe_status"`
	AccountIs              bool          `json:"account_is"`
	AccountStatus          int           `json:"account_status"`
}

type developerData struct {
	AppID  string `json:"appid"`
	AppKEY string `json:"appkey"`
}

func FormatData(dataStruct *Data, uid int) ReturnData {

	data := ReturnData{}

	data.AccountNickname = "未登录"
	data.AccountAvatarUrl = "https://cdn.geekros.com/robotchain/upload/avatar/default_avatar.jpg"
	data.AccountPhone = "尚未绑定手机号码"

	if dataStruct.AccountId > 0 {
		data.Token = Utils.EncodeId(32, dataStruct.AccountId)
		data.AccountId = dataStruct.AccountId
		if dataStruct.AccountNickname != "" {
			data.AccountNickname = dataStruct.AccountNickname
		}
		if dataStruct.AccountAvatarUrl != "" {
			data.AccountAvatarUrl = dataStruct.AccountAvatarUrl
		}
		data.AccountSubscribeStatus = dataStruct.AccountSubscribeStatus
		data.AccountStatus = dataStruct.AccountStatus
		data.AccountGroupId = dataStruct.AccountGroupId
		data.AccountIntegral = dataStruct.AccountIntegral
		data.AccountWechat = dataStruct.AccountWechat
		data.AccountOpenId = dataStruct.AccountOpenId
		if dataStruct.AccountId == uid {
			data.AccountBalanceInt = dataStruct.AccountBalance
			data.AccountBalance = Utils.PriceConvert(dataStruct.AccountBalance)
			data.AccountPhone = Utils.MobileFormat(dataStruct.AccountPhone)
			data.AccountUnionId = dataStruct.AccountUnionId
			data.Developer.AppID = Utils.EncodeId(16, dataStruct.AccountId, 16)
			data.Developer.AppKEY = Utils.EncodeId(32, dataStruct.AccountId, 32)
			data.AccountIs = true
		}
	}

	return data
}
