
import { LukSDK,LukGameModel, LukGameEdgeInsets, LukGameAudioModel, LukInitModel } from '@luk/luksdk';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  @State uid: string = '10086';
  @State roomId: string = '10010';

  @State gameList: LukGameModel[] = []

  aboutToAppear(): void {

    this.uid = (Math.floor(Math.random() * 90000) + 10000).toString()
    this.roomId = (Math.floor(Math.random() * 90000) + 10000).toString()

    // run luksdk step 2: set callback
    this.setSdkCallBack()
  }

  build() {
    Column() {

      Column({space:5}){
        Text(`userid : ${this.uid}`)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })

        Button('login')
          .onClick(() => {

            // run luksdk step 3: set user info (login)
            LukSDK.setUserInfo(this.uid,'',{
              onLoginSuccess:()=>{
                AlertDialog.show({
                  message: `用户 ${this.uid} 登录成功`
                })




                LukSDK.getGameList({
                  onSuccess:(gameList:LukGameModel[]) => {

                    this.gameList = gameList

                  },
                  onError:(code:number, msg:string) => {
                  }
                })


              },
              onLoginFail:(code:number, msg:string) => {
                AlertDialog.show({
                  message: `用户 ${this.uid} 登录失败：${msg}}`
                })
              },
              onRefreshToken:(token:string) => {
                console.info('onRefreshToken：'+token)
              }
            })

          })

        Button('show game list')
          .onClick(() => {

            // run luksdk step 4: show game list
            console.info('show game list：'+this.getUIContext().getWindowName())
            LukSDK.showGameListDialog(this.getUIContext())

          })

        Button('show game page')
          .onClick(() => {

            if (this.gameList) {
              for (let index = 0; index < this.gameList.length; index++) {
                const element = this.gameList[index];
                if (element.g_id == 53) {

                  // run luksdk step 4 (other ways): open gamePage
                  this.getUIContext().getRouter().pushUrl({
                    url: 'pages/GamePage',
                    params: {
                      gid: element.g_id,
                      gameUrl: element.g_url,
                      uid: this.uid,
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      scale: 0.5,
                      isRoomOwner: true,
                      roomId: this.roomId
                    }
                  })
                }
              }
            }

          })
      }

    }
    .height('100%')
    .width('100%')
    // .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }


  setSdkCallBack(){


    LukSDK.setBizCallback({
      onOpenChargePage : () : void => {

      },
      onGetCurrentRoomId : () : string => {
        return this.roomId;
      },
      onIsRoomOwner : () : boolean => {
        return true;
      },
      onWindowSafeArea : () : LukGameEdgeInsets => {

        return {top:0,bottom:0,right:0,left:0,minScaleLimit:0.5};
      },
      onGamePageClose : () : void => {
        console.debug("on Game page Close")
        LukSDK.finishGameWindow()
      },
      onOpenPlatformPage : (path: string, data: string) : void => {

        console.debug("on platform page" + `path: ${path}, data: ${data}`)

      },
      onGetGameConfig: (dataJson: string) : string => {

        console.debug("on Get Game Config" + `dataJson: ${dataJson}`)

        return ""
      }

    })

    LukSDK.setCFGameLifecycle({
      onGameLoadFail() : void {
        console.debug("on Game Load Fail")
      },
      onPreJoinGame : (uid: string, seatIndex: number): boolean => {
        return true
      },
      onCanStartGame : (udi: string) : boolean => {
        return true
      },
      onGamePrepare(uid: string): void {
        console.debug("on Game Prepare :",uid)
      },
      onCancelPrepare(uid: string): void {
        console.debug("on Game Cancel Prepare :",uid)
      },
      onGameOver(): void {
        console.debug("on Game Over")
      },
      onGameDidFinishLoad: () : void => {
        console.debug("on Game Did Finish Load")

      },
      onSeatAvatarTouch(uid: string, seatIndex: number): void {
        console.debug(`on Seat Avatar Touch Uid: ${uid}, seat: ${seatIndex}`)
      },
      onGameStateChangeState(state: string, dataJson: string): void {
        console.debug(`on Game State Change State: ${state}, dataJson: ${dataJson}`)
      },
      onPlayerStateChangeState(state: string, uid: string, dataJson: string): void {
        console.debug(`on Player State Change State: ${state}, uid: ${uid}， dataJson: ${dataJson}`)
      },
      onGamePurchaseResult(code: number, orderId: string): void {
        console.debug(`on Game Purchase Result code: ${code}, orderId: ${orderId}`)
      },
      onGameMusicStartPlay(musicId: number, musicUrl: string, isLoop: boolean): boolean {
        console.debug(`on Game Music Start Play: ${musicId}, orderId: ${musicUrl}, orderId: ${isLoop}`)
        return true
      },
      onGameMusicStopPlay(musicId: number): boolean {
        console.debug(`on Game Music Stop Play: ${musicId}`)
        return true
      },
      onGameEffectSoundStartPlay(soundId: number, soundUrl:string, isLoop: boolean): boolean {
        console.debug(`on Game Sound Start Play: ${soundId}, orderId: ${soundUrl}, orderId: ${isLoop}`)
        return true
      },
      onGameEffectSoundStopPlay(soundId: number): boolean {
        console.debug(`on Game Sound Stop Play: ${soundId}`)
        return true
      },
      onGameScreenShotBaseData(base64String: string, dataJson: string): void {
        console.debug(`on Game Screen Shot BaseData: ${base64String}, dataJson: ${dataJson}`)
      }
    })
  }
}