# 鸿蒙系统中自定义组件的创建与使用

在鸿蒙应用开发中，自定义组件是构建复杂UI界面的重要方式，它可以帮助开发者实现代码复用、提高开发效率，并使代码结构更加清晰。本文将详细介绍如何在鸿蒙系统中创建和使用自定义组件。

## 基本概念

在鸿蒙开发中，自定义组件是通过 `@Component` 装饰器和 `struct` 结构体来定义的。每个自定义组件必须实现 `build()` 方法，该方法定义了组件的UI结构。

## 一、创建基本自定义组件

### 1.1 基本组件结构

```ts
@Component
struct CustomButton {
  // 组件的属性
  private buttonText: string = '按钮';
  private buttonColor: Color = Color.Blue;
  
  // UI构建方法
  build() {
    Button(this.buttonText)
      .backgroundColor(this.buttonColor)
      .width('80%')
      .height(40)
      .borderRadius(8)
  }
}
```

### 1.2 在页面中使用自定义组件

```ts
@Entry
@Component
struct HomePage {
  build() {
    Column() {
      Text('自定义组件示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(20)
      
      // 使用自定义组件
      CustomButton()
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

## 二、带参数的自定义组件

### 2.1 定义带参数的组件

通过在自定义组件中定义属性，我们可以在使用组件时传递参数：

```ts
@Component
struct CustomButton {
  // 定义参数
  private buttonText: string;
  private buttonColor: Color;
  
  // 设置默认值
  aboutToAppear() {
    if (!this.buttonText) {
      this.buttonText = '默认按钮文本';
    }
    if (!this.buttonColor) {
      this.buttonColor = Color.Blue;
    }
  }
  
  build() {
    Button(this.buttonText)
      .backgroundColor(this.buttonColor)
      .width('80%')
      .height(40)
      .borderRadius(8)
  }
}
```

### 2.2 使用带参数的组件

```ts
@Entry
@Component
struct HomePage {
  build() {
    Column() {
      Text('自定义组件参数示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(20)
      
      // 使用自定义组件并传参
      CustomButton({ buttonText: '确定', buttonColor: Color.Green })
      
      CustomButton({ buttonText: '取消', buttonColor: Color.Gray })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

## 三、组件生命周期

自定义组件有几个重要的生命周期回调方法：

```ts
@Component
struct LifecycleComponent {
  @State counter: number = 0;
  
  // 组件即将出现时，类似于onInit
  aboutToAppear() {
    console.info('组件即将出现');
  }
  
  // 组件即将消失时
  aboutToDisappear() {
    console.info('组件即将消失');
  }
  
  // 当状态变量发生变化，且build()执行前调用
  onPageShow() {
    console.info('页面显示');
  }
  
  // 页面隐藏时调用
  onPageHide() {
    console.info('页面隐藏');
  }
  
  // 页面返回按钮回调
  onBackPress() {
    console.info('返回按钮被点击');
    return false; // 返回true表示消费事件，false表示继续向上传递
  }
  
  build() {
    Column() {
      Text(`当前计数: ${this.counter}`)
      
      Button('增加计数')
        .onClick(() => {
          this.counter++;
        })
    }
    .width('100%')
  }
}
```

## 四、创建可复用组件库

### 4.1 单独文件中定义组件

在实际开发中，通常我们会将自定义组件放在单独的文件中，方便复用。例如创建 `CustomComponents.ets` 文件：

```ts
// CustomComponents.ets

// 自定义按钮组件
@Component
export struct CustomButton {
  private buttonText: string = '按钮';
  private buttonColor: Color = Color.Blue;
  private onClick: () => void = () => {};
  
  build() {
    Button(this.buttonText)
      .backgroundColor(this.buttonColor)
      .width('80%')
      .height(40)
      .borderRadius(8)
      .onClick(() => {
        this.onClick();
      })
  }
}

// 自定义卡片组件
@Component
export struct CustomCard {
  private title: string = '';
  private content: string = '';
  
  build() {
    Column() {
      Text(this.title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 8 })
      
      Text(this.content)
        .fontSize(14)
    }
    .width('90%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .shadow({ radius: 4, color: '#1F000000', offsetX: 2, offsetY: 2 })
  }
}
```

### 4.2 导入并使用组件

```ts
// Index.ets
import { CustomButton, CustomCard } from './CustomComponents';

@Entry
@Component
struct IndexPage {
  build() {
    Column() {
      Text('组件库示例')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin(20)
      
      // 使用按钮组件
      CustomButton({ 
        buttonText: '登录', 
        buttonColor: Color.Blue,
        onClick: () => {
          console.info('登录按钮点击');
        }
      })
      .margin(10)
      
      // 使用卡片组件
      CustomCard({ 
        title: '重要通知', 
        content: '这是一个自定义卡片组件示例，展示了如何创建和使用可复用的UI组件。'
      })
      .margin(10)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Center)
  }
}
```

## 五、带状态的自定义组件

### 5.1 使用状态变量的自定义组件

```ts
@Component
export struct StatefulCounter {
  @State count: number = 0;
  private color: Color = Color.Blue;
  
  build() {
    Column() {
      Text(`计数: ${this.count}`)
        .fontSize(18)
        .fontColor(this.color)
      
      Row() {
        Button('-')
          .width(40)
          .height(40)
          .margin(5)
          .onClick(() => {
            this.count--;
          })
        
        Button('+')
          .width(40)
          .height(40)
          .margin(5)
          .onClick(() => {
            this.count++;
          })
      }
      .margin(10)
    }
    .padding(16)
    .borderRadius(8)
    .backgroundColor('#F0F0F0')
  }
}
```

### 5.2 使用状态变量组件

```ts
@Entry
@Component
struct StatefulPage {
  build() {
    Column() {
      Text('状态组件示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(20)
      
      // 多个实例，每个都有自己的状态
      StatefulCounter({ color: Color.Red })
        .margin(10)
      
      StatefulCounter({ color: Color.Green })
        .margin(10)
      
      StatefulCounter({ color: Color.Blue })
        .margin(10)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .justifyContent(FlexAlign.Center)
  }
}
```

## 六、父子组件通信

### 6.1 使用属性传递参数（父传子）

```ts
@Component
struct ChildComponent {
  // 接收父组件参数
  @Prop message: string;
  
  build() {
    Text(`接收到的消息: ${this.message}`)
      .fontSize(16)
      .padding(10)
      .backgroundColor('#F0F0F0')
      .borderRadius(8)
  }
}

@Entry
@Component
struct ParentComponent {
  @State parentMsg: string = 'Hello from parent';
  
  build() {
    Column() {
      Text('父子组件通信示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(20)
      
      // 传递参数给子组件
      ChildComponent({ message: this.parentMsg })
      
      Button('更改消息')
        .margin(20)
        .onClick(() => {
          this.parentMsg = 'Updated message: ' + new Date().toLocaleTimeString();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

### 6.2 使用事件回调（子传父）

```ts
@Component
struct ChildWithCallback {
  // 接收父组件传递的回调函数
  private onButtonClick: (data: string) => void = () => {};
  
  build() {
    Button('子组件按钮')
      .onClick(() => {
        // 调用父组件传递的回调函数，并传递数据
        this.onButtonClick('来自子组件的数据: ' + new Date().toLocaleTimeString());
      })
      .width(200)
      .height(40)
  }
}

@Entry
@Component
struct CallbackParent {
  @State receivedData: string = '等待子组件数据...';
  
  build() {
    Column() {
      Text('回调通信示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(20)
      
      // 显示从子组件接收的数据
      Text(this.receivedData)
        .fontSize(16)
        .margin(10)
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
      
      // 传递回调函数给子组件
      ChildWithCallback({
        onButtonClick: (data: string) => {
          this.receivedData = data;
        }
      })
      .margin(20)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

### 6.3 使用@Link实现双向绑定

```ts
@Component
struct LinkChild {
  // 使用@Link创建双向绑定
  @Link message: string;
  
  build() {
    Column() {
      Text(`当前消息: ${this.message}`)
        .fontSize(16)
        .margin(10)
      
      Button('在子组件中修改')
        .onClick(() => {
          // 修改会自动同步到父组件
          this.message = '子组件修改: ' + new Date().toLocaleTimeString();
        })
        .margin(10)
    }
    .padding(16)
    .backgroundColor('#F0F0F0')
    .borderRadius(8)
  }
}

@Entry
@Component
struct LinkParent {
  @State sharedMessage: string = '初始消息';
  
  build() {
    Column() {
      Text('双向绑定示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(20)
      
      Text(`父组件消息: ${this.sharedMessage}`)
        .fontSize(16)
        .margin(10)
      
      Button('在父组件中修改')
        .onClick(() => {
          this.sharedMessage = '父组件修改: ' + new Date().toLocaleTimeString();
        })
        .margin(10)
      
      // 使用$语法创建双向绑定
      LinkChild({ message: $sharedMessage })
        .margin(20)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
```

## 七、自定义组件复用与嵌套

### 7.1 组件嵌套

```ts
// 基础卡片组件
@Component
struct BaseCard {
  private title: string = '';
  // 使用slot定义内容插槽
  @BuilderParam content: () => void = () => {};
  
  build() {
    Column() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })
      
      // 渲染传入的内容
      this.content()
    }
    .width('90%')
    .padding(15)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .shadow({ radius: 4, color: '#1F000000', offsetX: 2, offsetY: 2 })
  }
}

// 嵌套使用基础卡片创建信息卡片
@Component
struct InfoCard {
  private name: string = '';
  private description: string = '';
  private imageUrl?: string;
  
  build() {
    BaseCard({
      title: this.name,
      // 使用@Builder定义内容
      content: () => {
        Column() {
          if (this.imageUrl) {
            Image(this.imageUrl)
              .width('100%')
              .height(160)
              .objectFit(ImageFit.Cover)
              .margin({ bottom: 10 })
              .borderRadius(8)
          }
          
          Text(this.description)
            .fontSize(14)
            .margin(5)
        }
      }
    })
  }
}

// 使用示例
@Entry
@Component
struct NestedComponentsDemo {
  build() {
    Column({ space: 20 }) {
      Text('组件嵌套示例')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin(20)
      
      // 使用第一个信息卡片
      InfoCard({
        name: '风景欣赏',
        description: '美丽的山川河流风景照片，展示大自然的壮丽景色。',
        imageUrl: '/resources/images/landscape.jpg'
      })
      
      // 使用第二个信息卡片
      InfoCard({
        name: '产品信息',
        description: '这是一款创新的产品，具有多种功能和特点...'
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .padding({ top: 10, bottom: 20 })
  }
}
```

## 八、使用@BuilderParam自定义内容

`@BuilderParam` 是一个非常有用的装饰器，它允许父组件向子组件传递自定义UI结构。

```ts
@Component
struct ContainerComponent {
  @State backgroundColor: Color = Color.White;
  // 使用@BuilderParam定义可自定义的内容区域
  @BuilderParam header: () => void = () => {};
  @BuilderParam content: () => void = () => {};
  @BuilderParam footer: () => void = () => {};
  
  build() {
    Column() {
      // 头部区域
      Column() {
        this.header()
      }
      .width('100%')
      .backgroundColor('#F0F0F0')
      
      // 内容区域
      Column() {
        this.content()
      }
      .width('100%')
      .backgroundColor(this.backgroundColor)
      .padding(15)
      .flex(1)
      
      // 底部区域
      Column() {
        this.footer()
      }
      .width('100%')
      .backgroundColor('#E0E0E0')
    }
    .width('100%')
    .height('100%')
  }
}

@Entry
@Component
struct BuilderParamDemo {
  @State count: number = 0;
  
  build() {
    // 使用ContainerComponent并自定义各个部分的内容
    ContainerComponent({
      backgroundColor: Color.White,
      
      // 自定义头部
      header: () => {
        Row() {
          Text('自定义头部')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height(60)
        .justifyContent(FlexAlign.Center)
      },
      
      // 自定义内容
      content: () => {
        Column({ space: 20 }) {
          Text(`当前计数: ${this.count}`)
            .fontSize(18)
          
          Button('增加计数')
            .onClick(() => {
              this.count++;
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      },
      
      // 自定义底部
      footer: () => {
        Row() {
          Text('© 2025 自定义组件示例')
            .fontSize(14)
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
      }
    })
  }
}
```

## 九、自定义组件性能优化

### 9.1 使用@Prop和@Link时的注意事项

- 当数据仅需单向传递时使用@Prop，可以避免不必要的双向绑定开销
- 需要双向同步时才使用@Link
- 对于对象类型，考虑使用@ObjectLink而非直接使用@Link

### 9.2 合理使用aboutToAppear和aboutToDisappear

在这些生命周期回调中进行资源的初始化和释放：

```ts
@Component
struct OptimizedComponent {
  private intervalId: number = -1;
  @State data: any[] = [];
  
  aboutToAppear() {
    // 初始化资源
    this.loadData();
    
    // 设置定时器
    this.intervalId = setInterval(() => {
      this.refreshData();
    }, 5000);
  }
  
  aboutToDisappear() {
    // 清理资源
    if (this.intervalId !== -1) {
      clearInterval(this.intervalId);
      this.intervalId = -1;
    }
    
    // 释放其他资源
    this.data = [];
  }
  
  private loadData() {
    // 加载初始数据
  }
  
  private refreshData() {
    // 刷新数据
  }
  
  build() {
    Column() {
      ForEach(this.data, (item) => {
        Text(item.toString())
          .margin(5)
      })
    }
  }
}
```

## 十、完整实例：可复用的表单组件

以下是一个实际的表单组件示例，展示了如何创建和使用复杂的自定义组件：

```ts
// FormComponents.ets

// 文本输入组件
@Component
export struct InputField {
  @Prop label: string = '';
  @Prop placeholder: string = '';
  @Link value: string;
  private inputType: InputType = InputType.Normal;
  private maxLength: number = 50;
  
  build() {
    Column() {
      Text(this.label)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 5 })
        .textAlign(TextAlign.Start)
      
      TextInput({ placeholder: this.placeholder, text: this.value })
        .type(this.inputType)
        .maxLength(this.maxLength)
        .width('100%')
        .height(40)
        .onChange((value: string) => {
          this.value = value;
        })
        .border({ width: 1, color: '#DDDDDD', radius: 4 })
        .padding(10)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ bottom: 15 })
  }
}

// 表单组件
@Component
export struct Form {
  @BuilderParam header: () => void = () => {};
  @BuilderParam footer: () => void = () => {};
  @BuilderParam content: () => void = () => {};
  private onSubmit: () => void = () => {};
  
  build() {
    Column() {
      // 表单头部
      this.header()
      
      // 表单内容
      Column() {
        this.content()
      }
      .width('100%')
      .padding(15)
      
      // 表单底部
      this.footer()
      
      Button('提交')
        .width('90%')
        .height(45)
        .margin({ top: 20, bottom: 20 })
        .backgroundColor('#007DFF')
        .onClick(() => {
          this.onSubmit();
        })
    }
    .width('100%')
    .padding(15)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .shadow({ radius: 4, color: '#1F000000', offsetX: 2, offsetY: 2 })
  }
}

// 使用表单组件创建登录表单
@Entry
@Component
struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  @State errorMessage: string = '';
  
  login() {
    if (!this.username || !this.password) {
      this.errorMessage = '用户名和密码不能为空';
      return;
    }
    
    // 模拟登录
    this.errorMessage = '';
    console.info(`尝试登录: 用户名=${this.username}, 密码=${this.password}`);
    // 实际应用中这里会调用登录API
  }
  
  build() {
    Column() {
      Form({
        header: () => {
          Text('用户登录')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 30 })
        },
        
        content: () => {
          Column() {
            if (this.errorMessage) {
              Text(this.errorMessage)
                .fontSize(14)
                .fontColor(Color.Red)
                .margin({ bottom: 15 })
            }
            
            InputField({
              label: '用户名',
              placeholder: '请输入用户名',
              value: $username
            })
            
            InputField({
              label: '密码',
              placeholder: '请输入密码',
              value: $password
            })
          }
        },
        
        footer: () => {
          Row() {
            Text('忘记密码?')
              .fontSize(14)
              .fontColor('#007DFF')
              .onClick(() => {
                console.info('忘记密码');
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .margin({ top: 10 })
        },
        
        onSubmit: () => {
          this.login();
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .padding(20)
    .justifyContent(FlexAlign.Center)
  }
}
```

## 总结

鸿蒙系统中的自定义组件是应用开发的重要组成部分，通过合理设计和使用自定义组件，可以提高代码的复用性、可维护性，并提升开发效率。开发者应根据实际需求，选择合适的组件通信方式和状态管理方式，构建灵活高效的应用界面。

关键点：

1. 使用@Component装饰器和struct定义自定义组件
2. 实现build()方法定义组件UI结构
3. 利用@State、@Prop、@Link等状态装饰器管理组件状态
4. 使用@BuilderParam实现内容自定义
5. 注意组件生命周期和性能优化
