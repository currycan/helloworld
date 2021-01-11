package cmd

import (
	"github.com/spf13/cobra"

	"github.com/currycan/helloworld/common"
	"github.com/currycan/helloworld/jd_seckill"

	"github.com/currycan/helloworld/log"
)

func init() {
	rootCmd.AddCommand(reserveCmd)
}

var reserveCmd = &cobra.Command{
	Use:   "reserve",
	Short: "Open JD Moutai buying appointment",
	Run:   startReserve,
}

func startReserve(cmd *cobra.Command, args []string) {
	session := jd_seckill.NewSession(common.CookieJar)
	err := session.CheckLoginStatus()
	if err != nil {
		log.Error("预约失败，请重新登录")
	} else {
		//开始预约,预约过的就重复预约
		seckill := jd_seckill.NewSeckill(common.Client, common.Config)
		seckill.MakeReserve()
	}
}
