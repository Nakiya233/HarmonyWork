# 鸿蒙系统中的状态变量装饰器

鸿蒙系统（HarmonyOS/OpenHarmony）应用开发中，提供了多种状态变量装饰器来管理组件的状态和UI更新。以下是常用的状态变量装饰器及其详细说明：

## 1. @State

**作用**：用于组件内部状态管理，当装饰的变量值变化时，会自动触发组件的build方法重新渲染UI。

**使用范围**：仅在当前组件内生效，其子组件不能直接访问。

**可装饰的数据类型**：
- 基本数据类型：string、number、boolean
- 类对象
- 数组
- 对象 

**示例**：
```ts
@Component
struct Counter {
  @State count: number = 0;
  
  build() {
    Column() {
      Text(`计数: ${this.count}`)
      Button('增加').onClick(() => {
        this.count++;
      })
    }
  }
}
```

## 2. @Prop

**作用**：用于从父组件接收数据，建立父子组件之间的单向数据同步。父组件中对应状态变量更新，会同步更新到子组件，但子组件对@Prop变量的修改不会影响父组件。

**使用范围**：用于父组件向子组件传递数据，实现单向数据流。

**可装饰的数据类型**：
- 基本数据类型：string、number、boolean
- 不支持复杂对象类型

**示例**：
```ts
@Component
struct Parent {
  @State message: string = 'Hello';
  
  build() {
    Column() {
      Child({ msg: this.message })
      Button('更改').onClick(() => {
        this.message = 'Hello World';
      })
    }
  }
}

@Component
struct Child {
  @Prop msg: string;
  
  build() {
    Text(this.msg)
  }
}
```

## 3. @Link

**作用**：实现父子组件之间的双向数据同步。子组件中对@Link变量的修改会同步回父组件，父组件中对应变量的修改也会同步到子组件。

**使用范围**：用于父子组件之间需要双向数据绑定的场景。

**可装饰的数据类型**：
- 基本数据类型：string、number、boolean
- 类对象
- 数组
- 对象

**示例**：
```ts
@Component
struct Parent {
  @State count: number = 0;
  
  build() {
    Column() {
      Text(`父组件计数: ${this.count}`)
      Child({ counter: $count })
    }
  }
}

@Component
struct Child {
  @Link counter: number;
  
  build() {
    Column() {
      Text(`子组件计数: ${this.counter}`)
      Button('增加').onClick(() => {
        this.counter++;  // 修改会同步到父组件
      })
    }
  }
}
```

## 4. @Provide 和 @Consume

**作用**：提供从祖先组件到后代组件的数据同步机制，而不需要通过中间组件传递。

**使用范围**：
- @Provide：在祖先组件中声明，提供数据
- @Consume：在后代组件中声明，消费数据

**可装饰的数据类型**：
- 基本数据类型：string、number、boolean
- 类对象
- 数组
- 对象

**示例**：
```ts
@Component
struct Ancestor {
  @Provide('theme') theme: string = 'light';
  
  build() {
    Column() {
      Text(`当前主题: ${this.theme}`)
      Button('切换主题').onClick(() => {
        this.theme = this.theme === 'light' ? 'dark' : 'light';
      })
      
      // 中间组件不需要传递theme属性
      MiddleComponent()
    }
  }
}

@Component
struct MiddleComponent {
  build() {
    Column() {
      Text('中间组件')
      DescendantComponent()
    }
  }
}

@Component
struct DescendantComponent {
  @Consume('theme') theme: string;
  
  build() {
    Text(`后代组件获取的主题: ${this.theme}`)
      .backgroundColor(this.theme === 'light' ? '#FFFFFF' : '#000000')
      .fontColor(this.theme === 'light' ? '#000000' : '#FFFFFF')
  }
}
```

## 5. @ObjectLink

**作用**：用于对象类型的双向绑定，使子组件可以修改父组件传递的对象内部属性。

**使用范围**：当需要在子组件中修改父组件中对象的属性时使用。

**可装饰的数据类型**：
- 类对象
- 对象（包含属性的普通对象）

**示例**：
```ts
class Person {
  name: string;
  age: number;
  
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

@Component
struct Parent {
  @State person: Person = new Person('张三', 25);
  
  build() {
    Column() {
      Text(`姓名: ${this.person.name}, 年龄: ${this.person.age}`)
      Child({ personData: this.person })
    }
  }
}

@Component
struct Child {
  @ObjectLink personData: Person;
  
  build() {
    Column() {
      Button('修改年龄').onClick(() => {
        this.personData.age++;  // 直接修改对象属性，会反映到父组件
      })
    }
  }
}
```

## 6. @Observed 和 @ObjectLink

**作用**：@Observed装饰类，使类的实例成为可观察对象，配合@ObjectLink使用可以实现对象属性的观察和双向同步。

**使用范围**：当需要观察对象的属性变化时使用。

**可装饰的数据类型**：
- @Observed：装饰类
- @ObjectLink：装饰对象实例

**示例**：
```ts
@Observed
class Student {
  name: string;
  score: number;
  
  constructor(name: string, score: number) {
    this.name = name;
    this.score = score;
  }
}

@Component
struct ScorePanel {
  @State student: Student = new Student('李四', 85);
  
  build() {
    Column() {
      Text(`学生: ${this.student.name}, 分数: ${this.student.score}`)
      ScoreEditor({ studentData: this.student })
    }
  }
}

@Component
struct ScoreEditor {
  @ObjectLink studentData: Student;
  
  build() {
    Column() {
      Button('加分').onClick(() => {
        this.studentData.score += 5;  // 修改会同步到父组件
      })
    }
  }
}
```

## 7. @Watch

**作用**：用于监听状态变量的变化，当变量值发生变化时触发回调函数。

**使用范围**：需要在变量变化时执行特定逻辑的场景。

**可装饰的数据类型**：可以监听任何类型的状态变量

**示例**：
```ts
@Component
struct WatchDemo {
  @State count: number = 0;
  
  @Watch('count')
  onCountChange(newValue: number, oldValue: number) {
    console.info(`计数从${oldValue}变为${newValue}`);
  }
  
  build() {
    Column() {
      Text(`当前计数: ${this.count}`)
      Button('增加').onClick(() => {
        this.count++;
      })
    }
  }
}
```

## 8. @StorageLink 和 @StorageProp

**作用**：用于组件与应用级别的数据存储（AppStorage）进行双向(@StorageLink)或单向(@StorageProp)数据同步。

**使用范围**：需要与应用全局状态管理进行交互的场景。

**可装饰的数据类型**：
- 基本数据类型
- 对象
- 数组

**示例**：
```ts
// 预先在AppStorage中设置数据
AppStorage.SetOrCreate('username', '王五');

@Component
struct StorageDemo {
  @StorageLink('username') username: string = '';
  @StorageProp('isLogin') isLogin: boolean = false;
  
  build() {
    Column() {
      Text(`当前用户: ${this.username}`)
      Button('修改用户名').onClick(() => {
        this.username = '李六';  // 会同步到AppStorage
      })
      
      Text(`登录状态: ${this.isLogin ? '已登录' : '未登录'}`)
      // StorageProp是单向的，不能直接修改
    }
  }
}
```

## 9. @LocalStorageLink 和 @LocalStorageProp

**作用**：类似于@StorageLink和@StorageProp，但作用域限定在当前页面组件及其子组件范围内。

**使用范围**：页面级别的状态管理。

**可装饰的数据类型**：
- 基本数据类型
- 对象
- 数组

**示例**：
```ts
@Entry
@Component
struct LocalStorageDemo {
  // 创建LocalStorage实例
  private storage = new LocalStorage({ 'pageTitle': '我的页面' });
  
  build() {
    Column() {
      // 通过storage将LocalStorage传递给子组件
      LocalStorageChild({ storage: this.storage })
    }
  }
}

@Component
struct LocalStorageChild {
  // 接收LocalStorage实例
  private storage: LocalStorage;
  
  // 使用LocalStorageLink进行双向绑定
  @LocalStorageLink('pageTitle') title: string = '';
  
  build() {
    Column() {
      Text(`页面标题: ${this.title}`)
      Button('修改标题').onClick(() => {
        this.title = '新标题';  // 会同步到LocalStorage
      })
    }
  }
}
```

## 总结

状态变量装饰器是鸿蒙应用开发中非常重要的特性，它们帮助开发者管理组件状态、实现组件通信，以及处理UI的自动更新。合理选择和使用这些装饰器可以简化状态管理，提高开发效率。

- **组件内状态**: @State
- **父子组件通信**: @Prop(单向), @Link(双向), @ObjectLink(对象属性双向)
- **跨层级通信**: @Provide/@Consume
- **对象观察**: @Observed 配合 @ObjectLink
- **状态监听**: @Watch
- **应用级状态**: @StorageLink, @StorageProp
- **页面级状态**: @LocalStorageLink, @LocalStorageProp
