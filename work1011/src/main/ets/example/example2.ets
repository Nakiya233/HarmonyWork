import { Router } from '@kit.ArkUI'

@Entry
@Component
struct Index2{
  router:Router = this.getUIContext().getRouter()
  @State record:Record<string,string>={}

  //自定义组件的声明周期函数，组件显示的时候触发这个函数
  onPageShow(): void {
    //把数据类型转换成map结构
    this.record=this.router.getParams() as Record<string,string>

  }
  build() {
    Column(){
      Row(){
        Image($r('app.media.back'))
          .width(25)
          .onClick(()=>{
            //返回页面，不传递数据
            // this.router.back()
            //返回页面，传递数据
            this.router.back({
              url:'example/example',
              params:{
              name:'孙佳浩',
              age:'21',
              sex:'男'
            }})
          })
      }
      .width('100%')
      .padding(6)
      .backgroundColor('#f6f6f6')
      Text('Index2')
        .fontSize(20)
        .fontWeight(700)
      Button('跳转第三个页面')
        .onClick(()=>{
          this.router.pushUrl({url:'example/example3'})
        })
      //通过键值对获取数据
      Text(`姓名:${this.record['name']}`)
      Text(`年龄:${this.record['age']}`)
      Text(`性别:${this.record['sex']}`)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}