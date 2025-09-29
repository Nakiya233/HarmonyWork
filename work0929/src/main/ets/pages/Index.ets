@Entry
@Component
struct TabContentExample {
  @State tabItemColor: string = '#182431';
  @State selectedTabItemColor: string = '#E4AE62';
  @State currentIndex: number = 0;
  @State selectedIndex: number = 0;
  private controller: TabsController = new TabsController();

  @Builder tabBuilder(index: number, title: string, image: Resource) {
    Column() {
      if (index == 2) {
        Image(image)
          .width(60)
          .aspectRatio(1)
          .borderRadius(100)
          .margin({ bottom: 20 })
          // .objectFit(ImageFit.Contain)
      } else {
        Image(image)
          .width(24)
          .height(24)
          .margin({ bottom: 4 })
          .objectFit(ImageFit.Contain)
          .fillColor(this.selectedIndex == index ? this.selectedTabItemColor : this.tabItemColor)
        Text(title)
          .fontColor(this.selectedIndex == index ? this.selectedTabItemColor : this.tabItemColor)
          .fontSize(10)
          .fontWeight(500)
          .lineHeight(14)
      }
    }.width('100%')
  }

  @Builder tabViews(tip: string) {
    Text(tip)
      .fontSize(36)
      .fontColor('#182431')
      .fontWeight(500)
      .backgroundColor(Color.White)
      .height('99%')
      .width('95%')
      .borderRadius(5)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          Column() {
            this.tabViews('Tab1')
            Divider()
              .strokeWidth(0.5)
              .color('#182431')
              .opacity(0.05)
          }
          .backgroundColor('#F4F4F4')
          .width('100%')
          .height('100%')
        }.tabBar(this.tabBuilder(0, '首页', $r('app.media.homepage')))

        TabContent() {
          Column() {
            this.tabViews('Tab2')
            Divider()
              .strokeWidth(0.5)
              .color('#182431')
              .opacity(0.05)
          }
          .width('100%')
        }.tabBar(this.tabBuilder(1, '分类', $r('app.media.category')))

        TabContent() {
          // Column() {
          //   this.tabViews('Tab3')
          //   Divider()
          //     .strokeWidth(0.5)
          //     .color('#182431')
          //     .opacity(0.05)
          // }.width('100%')
        }.tabBar(this.tabBuilder(2, '', $r('app.media.phone')))
        .onWillShow(()=>{
          return
        })

        TabContent() {
          Column() {
            this.tabViews('Tab3')
            Divider()
              .strokeWidth(0.5)
              .color('#182431')
              .opacity(0.05)
          }.width('100%')
        }.tabBar(this.tabBuilder(3, '购物车', $r('app.media.shopcart')))

        TabContent() {
          Column() {
            this.tabViews('Tab4')
            Divider()
              .strokeWidth(0.5)
              .color('#182431')
              .opacity(0.05)
          }.width('100%')
        }.tabBar(this.tabBuilder(4, '我的', $r('app.media.my')))
      }
      .vertical(false)
      .barHeight(56)
      .onChange((index: number) => {
        // currentIndex控制TabContent显示页签
          this.currentIndex = index;
          this.selectedIndex = index;
      })
      .onContentWillChange((currentIndex, comingIndex) => {
        if (comingIndex == 2) {
          return false;
        }
        return true;
      })
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        if (index === targetIndex) {
          return;
        }
        // selectedIndex控制自定义TabBar内Image和Text颜色切换
        this.selectedIndex = targetIndex;
      })
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .width('100%')
    .height('100%')
  }
}