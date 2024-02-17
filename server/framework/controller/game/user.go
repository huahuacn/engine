/**
 ******************************************************************************
 * @file    user.go
 * @author  MakerYang
 ******************************************************************************
 */

package GameController

import (
	"Game/framework/database"
	"Game/framework/database/game_area_data"
	"Game/framework/database/game_user_data"
	"Game/framework/utils"
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
)

type requestUserLogin struct {
	Account  string `json:"account"`
	Password string `json:"password"`
}

type responseUserLogin struct {
	Token string                    `json:"token"`
	Areas []GameAreaData.ReturnData `json:"areas"`
}

func UserLogin(c *gin.Context) {

	returnData := responseUserLogin{}
	returnData.Areas = make([]GameAreaData.ReturnData, 0)

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

	jsonData := requestUserLogin{}
	requestJson, _ := ioutil.ReadAll(c.Request.Body)
	fmt.Println(string(requestJson))
	err := json.Unmarshal(requestJson, &jsonData)
	if err != nil {
		Utils.Warning(c, 10000, "非法的请求", Utils.EmptyData{})
		return
	}

	userDatabase := Database.New(GameUserDataDatabase.TableName)
	userData := GameUserDataDatabase.Data{}
	where := fmt.Sprintf("user_game_id = %d AND user_game_account_id = %d AND user_account = %q", GameId, GameAccountId, jsonData.Account)
	err = userDatabase.GetData(&userData, where, "")
	if err != nil {
		Utils.Warning(c, 10000, "账号登录失败，请重新尝试", Utils.EmptyData{})
		return
	}

	if !Utils.VerifyPassword(userData.UserPassword, jsonData.Password) {
		Utils.Warning(c, 10000, "账号或密码错误，请重新尝试", Utils.EmptyData{})
		return
	}

	areaDatabase := Database.New(GameAreaData.TableName)
	where = fmt.Sprintf("area_account_id = %d AND area_game_id = %d AND area_status = %d", GameAccountId, GameId, 2)
	areaData := make([]GameAreaData.Data, 0)
	err = areaDatabase.ListData(&areaData, where, "area_id ASC", 6)
	if err == nil {
		for _, v := range areaData {
			item := GameAreaData.FormatData(&v)
			returnData.Areas = append(returnData.Areas, item)
		}
	}

	userLogin := GameUserDataDatabase.FormatData(&userData)
	returnData.Token = userLogin.Token

	Utils.Success(c, returnData)
	return
}

type requestUserRegister struct {
	Account   string `json:"account"`
	Password  string `json:"password"`
	Name      string `json:"name"`
	Number    string `json:"number"`
	QuestionA string `json:"question_a"`
	QuestionB string `json:"question_b"`
	AnswerA   string `json:"answer_a"`
	AnswerB   string `json:"answer_b"`
}

func UserRegister(c *gin.Context) {

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

	jsonData := requestUserRegister{}
	requestJson, _ := ioutil.ReadAll(c.Request.Body)
	fmt.Println(string(requestJson))
	err := json.Unmarshal(requestJson, &jsonData)
	if err != nil {
		Utils.Warning(c, 10000, "非法的请求", Utils.EmptyData{})
		return
	}

	userDatabase := Database.New(GameUserDataDatabase.TableName)
	userData := GameUserDataDatabase.Data{}
	where := fmt.Sprintf("user_game_id = %d AND user_game_account_id = %d AND user_account = %q", GameId, GameAccountId, jsonData.Account)
	_ = userDatabase.GetData(&userData, where, "")
	if userData.UserId > 0 {
		Utils.Warning(c, 10000, "邮箱已被注册，请换一个", Utils.EmptyData{})
		return
	}

	setData := &GameUserDataDatabase.Data{}
	setData.UserGameId = GameId
	setData.UserGameAccountId = GameAccountId
	setData.UserAccount = jsonData.Account
	setData.UserPassword = Utils.MD5Hash(jsonData.Password)
	setData.UserName = jsonData.Name
	setData.UserNumber = jsonData.Number
	setData.UserQuestionA = jsonData.QuestionA
	setData.UserQuestionB = jsonData.QuestionB
	setData.UserAnswerA = jsonData.AnswerA
	setData.UserAnswerB = jsonData.AnswerB
	setData.UserStatus = 2
	err = userDatabase.CreateData(setData)
	if err != nil {
		Utils.Warning(c, 10000, "账号注册失败，请重新尝试", Utils.EmptyData{})
		return
	}

	Utils.Success(c, Utils.EmptyData{})
	return
}

type requestUserChangePassword struct {
	Account     string `json:"account"`
	Password    string `json:"password"`
	NewPassword string `json:"new_password"`
}

func UserChangePassword(c *gin.Context) {

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

	jsonData := requestUserChangePassword{}
	requestJson, _ := ioutil.ReadAll(c.Request.Body)
	fmt.Println(string(requestJson))
	err := json.Unmarshal(requestJson, &jsonData)
	if err != nil {
		Utils.Warning(c, 10000, "非法的请求", Utils.EmptyData{})
		return
	}

	userDatabase := Database.New(GameUserDataDatabase.TableName)
	userData := GameUserDataDatabase.Data{}
	where := fmt.Sprintf("user_game_id = %d AND user_game_account_id = %d AND user_account = %q", GameId, GameAccountId, jsonData.Account)
	err = userDatabase.GetData(&userData, where, "")
	if err != nil {
		Utils.Warning(c, 10000, "密码修改失败，请重新尝试", Utils.EmptyData{})
		return
	}

	if !Utils.VerifyPassword(userData.UserPassword, jsonData.Password) {
		Utils.Warning(c, 10000, "原始密码错误", Utils.EmptyData{})
		return
	}

	update := map[string]interface{}{"user_password": Utils.MD5Hash(jsonData.NewPassword)}
	err = userDatabase.UpdateData(where, update)
	if err != nil {
		Utils.Warning(c, 10000, "密码修改失败，请重新尝试", Utils.EmptyData{})
		return
	}

	Utils.Success(c, Utils.EmptyData{})
	return
}
