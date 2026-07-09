import { LukGameEdgeInsets, LukSDKState, LukGameWebView, ICFBizCallback,LukSDK } from '@luk/luksdk'

interface PageInfo{
  uid:string
  gid:string
  gameUrl:string
  isRoomOwner:boolean
  roomId:string
}

@Entry
@Component
struct GamePage{

  @State pageParams:PageInfo | null = null

  aboutToAppear(): void {

    this.pageParams = this.getUIContext().getRouter().getParams() as PageInfo

  }

  build() {
    Stack() {

      LukGameWebView({ gameId: parseInt(this.pageParams!.gid), gameUrl: this.pageParams!.gameUrl })
        .width('100%').height('100%')

    }
  }
}