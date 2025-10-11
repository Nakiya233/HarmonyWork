import { Router } from '@ohos.arkui.UIContext';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  //router模块是通过UIContext获取到的
  uiContext:UIContext = this.getUIContext()
  router:Router = this.uiContext.getRouter()
  @State record:Record<string,string>={}

  onPageShow(): void {
    //可能是程序运行就加载、或者是页面2返回
    if(this.router.getParams()){
      console.log('页面2返回的，有数据')
      this.record=this.router.getParams() as Record<string,string>
    }else{
      console.log('第一次程序运行加载的，没有数据')
    }
  }

  build() {
    Column() {
      Text('index')
        .fontSize(20)
        .fontWeight(700)
      Button('跳转第二个页面')
        .onClick(()=>{
          //保留当前页面，把新页面进行入栈显示
            this.router.pushUrl(
              {url:'example/example2',
                //传递数据到Index2页面，通过json键值对的形式
              params:
              {
                name:'李建新',
                age:20,
                sex:'男'
              }
              }
            )
          //销毁当前页面，新页面入栈显示
          // this.router.replaceUrl({url:'example/Index2'})
        })

      Button('返回到第二个页面')
        .onClick(()=>{
          this.router.back({url:'example/example3'})
        })

      //通过键值对获取数据
      Text(`姓名:${this.record['name']}`)
      Text(`年龄:${this.record['age']}`)
      Text(`性别:${this.record['sex']}`)
    }
    .height('100%')
    .width('100%')
  }

}