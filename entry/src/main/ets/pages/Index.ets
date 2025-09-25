@Entry
@Component
struct Index {

  build() {
    Column(){
      Stack(){
        Image($r('app.media.cover'))
          .borderRadius(10)
          .width('100%')
          .height('30%')
        Row({space : 15}){
          Row({space : 3}){
            Image($r('app.media.views'))
              .fillColor(Color.White)
              .width('7%')
              .aspectRatio(1)
            Text('4821')
              .fontColor(Color.White)
              .fontSize(15)
          }
          .margin({left: 10})
          Row({space : 3}){
            Image($r('app.media.bullet'))
              .fillColor(Color.White)
              .width('7%')
              .aspectRatio(1)
            Text('24')
              .fontColor(Color.White)
              .fontSize(15)
          }
          Row(){
            Text('37:37')
              .fontColor(Color.White)
          }
          .markAnchor({x: -148})
        }
        .borderRadius(10)
        .linearGradient({
          angle: 180,
          colors: [['transparent', 0.0], ['#ff000000', 1.0]]
        })
        .width('100%')
        .height('6%')
      }
      .padding(10)
      .alignContent(Alignment.Bottom)

      Column(){
        Text('一人一首成名曲《祝你一路顺风》《勇气》《听闻远方有你》《该死的温柔》《原来你也在这里》《遇见》《桥边姑娘-张茜》《江南》《好心分手》《偏爱》')
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .maxLines(2)
          .fontSize(18)
          .margin({left: 10, top: 8})
          .width('80%')
          .fontWeight(FontWeight.Bold)
        Row({space: 2}) {
          Image($r('app.media.up'))
            .width('6%')
          Text('侠女梧桐雨 · 9-11')
            .fontColor('#959ca3')
            .fontWeight(FontWeight.Medium)
        }
        .padding(10)
        .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
    }
  }
}