class VideoInfo{
  cover: Resource
  time: string
  title: string
  vloggerImg: Resource
  vloggerName: string
  like: string

  constructor(cover: Resource, time: string, title: string, vloggerImg: Resource, vloggerName: string,
    like: string) {
    this.cover = cover
    this.time = time
    this.title = title
    this.vloggerImg = vloggerImg
    this.vloggerName = vloggerName
    this.like = like
  }
}


@Entry
@Component
struct Index {
 @State videoInfoList: Array<VideoInfo> = [
   new VideoInfo($r("app.media.1"), "99:99", "哈雪大帽险", $r('app.media.vloggerImg'), "暗杠读秒p", "47.5"),
   new VideoInfo($r("app.media.2"), "99:99", "听完全家因果循环《哈基米Sleepwalking》⭐️⭐️⭐️⭐️", $r('app.media.vloggerImg'), "DJGenji", "2.9"),
   new VideoInfo($r("app.media.3"), "99:99", "【哈基米音乐】基米说（伯虎说停顿卡点&完整版）", $r('app.media.vloggerImg'), "慎啸", "21.3"),
   new VideoInfo($r("app.media.4"), "99:99", "哈基米：Billie Jean", $r('app.media.vloggerImg'), "tukirin-", "33.8"),
   new VideoInfo($r("app.media.5"), "99:99", "🐱哈基山的基米美如水啊🐱", $r('app.media.vloggerImg'), "初小晓Dawn", "41.3"),
   new VideoInfo($r("app.media.6"), "99:99", "【补档】🎵曼波 𝑵𝒐 𝑴𝒐𝒓𝒆🎵不再曼波（完整版）", $r('app.media.vloggerImg'), "还给我神ID", "28.2"),
   new VideoInfo($r("app.media.7"), "99:99", "【哈基米】哈得太逼真", $r('app.media.vloggerImg'), "枯萎穿心哈基", "8.2"),
   new VideoInfo($r("app.media.8"), "18:33", "《蓝莲哈》哈基米来洗涤你浮躁的心", $r('app.media.vloggerImg'), "猫猫怕痛惹", "7.1"),
 ]
  build() {
      List(){
        ForEach(this.videoInfoList, (item: VideoInfo) => {
          ListItem(){
            // Flex({ wrap: FlexWrap.Wrap , direction:FlexDirection.Row }) {
              Column() {
                Stack() {
                  // 封面
                  Image(item.cover)
                    .width('100%')
                    .height('15%')
                    .border({
                      radius: {
                        topLeft: 9,
                        topRight: 9
                      }
                    })
                  Row() {
                    Text(item.time)
                      .fontSize(13)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Regular)
                      .textAlign(TextAlign.End)
                      .width('100%')
                      .padding(5)
                  }
                  .width('100%')
                  .linearGradient({
                    angle: 180,
                    colors: [['transparent', 0.0], ['#ff000000', 1.0]]
                  })
                }
                .alignContent(Alignment.Bottom)
                // 标题
                Text(item.title)
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('100%')
                  .height('6%')
                  .align(Alignment.TopStart)
                  .padding(6)
                // 底部信息
                Row() {
                  Row({ space: 3 }) {
                    Image(item.vloggerImg)
                      .width('10%')
                      .aspectRatio(1)
                      .borderRadius(100)
                    Text(item.vloggerName)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(1)
                      .fontSize(13)
                      .fontColor(Color.Gray)
                  }
                  Row() {
                    Image($r('app.media.like'))
                      .width('15%')
                      .aspectRatio(1)
                      .fillColor(Color.Gray)
                    Text(item.like + '万')
                      .fontSize(11)
                      .fontColor(Color.Gray)
                      .margin({left: -2})
                  }
                }
                .padding(5)
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
              }
              .width('100%')
              .borderRadius(9)
            .backgroundColor('#fffffb')
          }
          .padding(2)
        })
      }
      .backgroundColor('#ffefefef')
      .width('100%')
      .height('100%')
      .lanes(2)
      .alignListItem(ListItemAlign.Center)
    }
}
