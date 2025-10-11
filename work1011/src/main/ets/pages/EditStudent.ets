import { Router } from '@kit.ArkUI'
import { Student } from '../model/Student'

@Entry
@Component
struct EditStudent {
  router: Router = this.getUIContext().getRouter()
  
  @State student: Student = new Student(0, '', 0, '男', $r('app.media.app_icon'))
  @State name: string = ''
  @State age: string = ''
  @State gender: string = '男'

  aboutToAppear() {
    // 获取传递过来的学生数据
    const params = this.router.getParams() as Record<string, Object>
    if (params && params['student']) {
      this.student = params['student'] as Student
      this.name = this.student.name
      this.age = this.student.age.toString()
      this.gender = this.student.gender
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.back'))
          .width(24)
          .height(24)
          .margin({ left: 15 })
          .onClick(() => {
            this.router.back()
          })

        Text('编辑学生信息')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 39 }) // 平衡左侧图标
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)

      Column() {
        // 头像
        Image(this.student.avatar)
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ top: 30, bottom: 30 })

        // 姓名
        Column({ space: 8 }) {
          Text('姓名')
            .fontSize(16)
            .fontColor('#666666')
            .alignSelf(ItemAlign.Start)

          TextInput({ text: this.name })
            .fontSize(16)
            .height(50)
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .onChange((value: string) => {
              this.name = value
            })
        }
        .width('100%')
        .margin({ bottom: 20 })

        // 年龄
        Column({ space: 8 }) {
          Text('年龄')
            .fontSize(16)
            .fontColor('#666666')
            .alignSelf(ItemAlign.Start)

          TextInput({ text: this.age })
            .fontSize(16)
            .height(50)
            .type(InputType.Number)
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .onChange((value: string) => {
              this.age = value
            })
        }
        .width('100%')
        .margin({ bottom: 20 })        // 性别
        Column({ space: 8 }) {
          Text('性别')
            .fontSize(16)
            .fontColor('#666666')
            .alignSelf(ItemAlign.Start)

          Select([
            { value: '男' },
            { value: '女' }
          ])
            .selected(this.gender === '男' ? 0 : 1)
            .value(this.gender)
            .font({ size: 16 })
            .fontColor('#333333')
            .selectedOptionFont({ size: 16 })
            .optionFont({ size: 16 })
            .width('100%')
            .height(50)
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .onSelect((index: number, value?: string) => {
              if (value) {
                this.gender = value
              }
            })
        }
        .width('100%')
        .margin({ bottom: 40 })

        // 按钮组
        Row({ space: 15 }) {
          Button('取消')
            .fontSize(16)
            .fontColor('#333333')
            .backgroundColor(Color.White)
            .border({ width: 1, color: '#DDDDDD' })
            .borderRadius(25)
            .width(150)
            .height(50)
            .onClick(() => {
              this.router.back()
            })          
            Button('保存')
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor('#007DFF')
            .borderRadius(25)
            .width(150)
            .height(50)
            .onClick(() => {
              // 更新学生信息
              const updatedStudent = new Student(
                this.student.id,
                this.name,
                parseInt(this.age),
                this.gender,
                this.student.avatar
              )

              console.log('保存学生信息:', JSON.stringify(updatedStudent))
              
              // 返回到列表页面并传递更新后的数据
              this.router.back({
                url: 'pages/Index',
                params: {
                  updatedStudent: updatedStudent
                }
              })
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      .padding({ left: 20, right: 20 })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
