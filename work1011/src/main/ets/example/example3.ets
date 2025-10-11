import { Router } from '@kit.ArkUI';

@Entry
@Component
struct Index3 {
  @State message: string = 'example3';
  router:Router = this.getUIContext().getRouter()

  build() {
    Column() {
      Row(){
        Image($r('app.media.back'))
          .width(25)
          .onClick(()=>{
            this.router.back({url:'example/example'})
          })
      }
      .width('100%')
      .padding(6)
      .backgroundColor('#f6f6f6')
      Text(this.message)
        .id('Index3HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)

    }
    .height('100%')
    .width('100%')
  }
}