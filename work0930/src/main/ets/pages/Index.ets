// xxx.ets
@Entry
@Component
struct ListCollapseExample {
  @State expandedItems: Map<string, boolean> = new Map([
    ['水果', true],  // 初始状态下，水果类别是展开的
    ['蔬菜', false],
    ['肉类', false]
  ]);
  
  private timetable: TimeTable[] = [
    {
      title: '水果',
      projects: ['苹果', '山竹', '荔枝', '西瓜']
    },
    {
      title: '蔬菜',
      projects: ['蔬菜', '西红柿', '黄瓜', '茄子']
    },
    {
      title: '肉类',
      projects: ['五花肉', '里脊肉', '鲈鱼', '鸡翅']
    }
  ]


  // 根据标题获取对应的展开/收起状态
  isItemExpanded(title: string): boolean {
    return this.expandedItems.get(title) === true;
  }

  build() {
    Column() {
      List({ space: 8 }) {
        ForEach(this.timetable, (item: TimeTable, index) => {
          ListItem() {
            Column() {
              // 标题行（点击区域）
              Row() {
                Text(item.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .padding({ left: 15 })
                
                // 展开/收起按钮
                Text(this.isItemExpanded(item.title) ? '▲' : '▼')
                  .fontSize(20)
                  .fontColor('#333333')
                  .width(50)
                  .textAlign(TextAlign.Center)
                  .animation({
                    duration: 300,
                    curve: Curve.EaseInOut,
                    iterations: 1,
                    playMode: PlayMode.Normal
                  })
              }
              .backgroundColor('#F68A8A')
              .width('100%')
              .height(50)
              .borderRadius(5)
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                // 使用动画切换展开/收起状态
                this.getUIContext().animateTo({
                  duration: 300,
                  curve: Curve.EaseInOut,
                  onFinish: () => {
                    console.info('animation end for: ' + item.title);
                  }
                }, () => {
                  // 获取当前项的展开状态
                  let isExpanded = this.expandedItems.get(item.title) === true;
                  // 切换当前项的展开状态
                  this.expandedItems.set(item.title, !isExpanded);
                });
              })

              // 内容区域（仅在展开状态下显示）
              if (this.isItemExpanded(item.title)) {
                Column() {
                  ForEach(item.projects, (project: string) => {
                    Text(project)
                      .width('100%')
                      .height(50)
                      .fontSize(16)
                      .textAlign(TextAlign.Start)
                      .padding({ left: 30 })
                      .backgroundColor(0xFFFFFF)
                  })
                }
                .width('100%')
                .borderRadius(4)
                // 添加过渡动画效果
                .transition({ type: TransitionType.All, opacity: 1 })
              }
            }
            .width('100%')
            .margin({ bottom: 8 })
            .borderRadius(8)
            .animation({
              duration: 300,
              curve: Curve.EaseInOut
            })
          }
        }, (item: TimeTable) => item.title)
      }
      .width('90%')
      .height('100%')
      .scrollBar(BarState.Auto)
      .divider({ strokeWidth: 1, color: '#EEEEEE', startMargin: 10, endMargin: 10 })
      .listDirection(Axis.Vertical)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 20 })
  }
}

interface TimeTable {
  title: string;
  projects: string[];
}