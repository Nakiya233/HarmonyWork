import { Student } from '../model/Student'
import { Router } from '@kit.ArkUI';

// 学生列表项组件
@Component
struct StudentItem {
  @ObjectLink student: Student
  router: Router = this.getUIContext().getRouter()

  build() {
    ListItem() {
      Row() {
        // 头像
        Image(this.student.avatar)
          .width(60)
          .height(60)
          .borderRadius(30)
          .margin({ left: 15, right: 15 })

        // 学生信息
        Column({ space: 5 }) {
          Text(this.student.name)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
          Text(this.student.age + '岁')
            .fontSize(14)
            .fontColor('#999999')
          Text(this.student.gender)
            .fontSize(14)
            .fontColor('#999999')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 编辑按钮
        Image($r('app.media.edit'))
          .width(24)
          .height(24)
          .margin({ right: 15 })
          .fillColor('#4789F6')
          .onClick(() => {
            // 跳转到编辑页面
            this.router.pushUrl({
              url: 'pages/EditStudent',
              params: {
                student: this.student
              }
            })
          })
      }
      .width('100%')
      .height(90)
      .backgroundColor(Color.White)
      .borderRadius(10)
    }
  }
}

@Entry
@Component
struct Index {
  router: Router = this.getUIContext().getRouter()
  @State refreshFlag: number = 0 // 添加刷新标志

  @State students: Student[] = [
    new Student(1, '孙祥峰', 21, '男', $r('app.media.app_icon')),
    new Student(2, '孙佳浩', 21, '男', $r('app.media.app_icon')),
    new Student(3, '赵宇航', 21, '男', $r('app.media.app_icon')),
    new Student(4, '裴紫文', 21, '男', $r('app.media.app_icon'))
  ]

  aboutToAppear() {
    // 监听从编辑页面返回的数据
    this.router.getParams()
  }

  onPageShow() {
    // 页面显示时，检查是否有返回的数据
    const params = this.router.getParams() as Record<string, Object>
    console.log('接收到的参数:', JSON.stringify(params))
    if (params && params['updatedStudent']) {
      const updated = params['updatedStudent'] as Student
      console.log('更新的学生信息:', JSON.stringify(updated))
      const index = this.students.findIndex(s => s.id === updated.id)
      if (index !== -1) {
        // 直接修改对象属性，@Observed会自动触发UI更新
        this.students[index].name = updated.name
        this.students[index].age = updated.age
        this.students[index].gender = updated.gender
        console.log('数据更新成功，索引:', index)
      }
    }
    
    // 清除参数，避免重复处理
    this.router.clear()
  }

  build() {
    Column() {
      // 标题
      Text('学生信息列表')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .padding(20)
        .width('100%')
        .textAlign(TextAlign.Center)

      // 学生列表
      List({ space: 10 }) {
        ForEach(this.students, (student: Student) => {
          StudentItem({ student: student })
        }, (student: Student) => student.id.toString())
      }
      .padding({ left: 10, right: 10 })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}