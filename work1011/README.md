# 学生信息管理系统

## 项目简介
使用鸿蒙ArkUI开发的学生信息管理系统，实现了学生列表展示和编辑功能。采用响应式状态管理，支持实时数据更新。

## 功能特性

### 1. 学生信息列表页面 (Index.ets)
- 展示学生列表，每个学生显示头像、姓名、年龄、性别
- 使用 `@State` + `@Observed` + `@ObjectLink` 响应式状态管理
- 使用 `List` + `StudentItem` 组件化展示列表
- 点击编辑按钮跳转到编辑页面

### 2. 编辑学生信息页面 (EditStudent.ets)
- 显示学生头像、姓名、年龄、性别的编辑表单
- 使用 `Select` 组件选择性别，提升用户体验
- 支持修改姓名、年龄、性别
- 点击保存按钮返回列表页面并自动更新数据
- 点击取消按钮返回列表页面不保存

### 3. 数据模型 (Student.ets)
- 使用 `@Observed` 装饰器的 Student 类
- 支持响应式数据更新
- 包含 id、姓名、年龄、性别、头像等属性

## 技术实现

### 响应式状态管理
- **@Observed 装饰器**：让 Student 类成为可观察对象
- **@State 装饰器**：管理学生列表数据状态
- **@ObjectLink 装饰器**：建立父子组件间的响应式数据绑定
- **自动UI更新**：修改 @Observed 对象属性自动触发界面更新

### 组件化设计
- **StudentItem 组件**：独立的学生列表项组件，使用 @ObjectLink 实现数据绑定
- **模块化结构**：清晰的组件职责分离，便于维护和扩展

### 页面路由 (@kit.ArkUI)
- 使用 `Router.pushUrl()` 从列表页跳转到编辑页
- 使用 `Router.back()` 从编辑页返回列表页
- 使用 `Router.getParams()` 获取页面传递的参数
- 使用 `onPageShow()` 生命周期监听页面显示，接收返回数据

### 用户界面组件
- **Select 组件**：性别选择使用下拉选择器，符合用户习惯
- **TextInput 组件**：支持文本和数字输入
- **List + ForEach**：高效的列表渲染

### 数据传递机制
- 跳转到编辑页时通过 `params` 传递学生对象
- 从编辑页返回时通过 `params` 传递更新后的学生对象
- 主页面直接修改 @Observed 对象属性，自动更新UI

## 项目结构
```
work1011/
├── src/main/ets/
│   ├── common/
│   │   └── DataManager.ets      # 数据管理工具（可选）
│   ├── model/
│   │   └── Student.ets          # 学生数据模型 (@Observed)
│   ├── pages/
│   │   ├── Index.ets            # 学生列表页面 (主页)
│   │   └── EditStudent.ets      # 编辑学生信息页面
│   └── example/
│       └── example3.ets         # 路由示例参考
├── resources/base/media/
│   ├── app_icon.png             # 默认头像
│   ├── edit.png                 # 编辑按钮图标
│   ├── back.png                 # 返回按钮图标
│   └── arrow_down.png           # 下拉箭头图标
├── module.json5                 # 模块配置文件
└── README.md                    # 项目说明文档
```

## 核心代码结构

### Student.ets (数据模型)
```arkts
@Observed
export class Student {
  public id: number
  public name: string
  public age: number
  public gender: string
  public avatar: Resource
}
```

### Index.ets (主页面)
```arkts
@Component
struct StudentItem {
  @ObjectLink student: Student  // 响应式数据绑定
}

@Entry
@Component
struct Index {
  @State students: Student[] = [...]  // 状态管理
}
```

### EditStudent.ets (编辑页面)
```arkts
Select([
  { value: '男' },
  { value: '女' }
]).onSelect((index: number, value?: string) => {
  this.gender = value
})
```

## 注意事项

1. **资源文件准备**
   - 需要在 `src/main/resources/base/media/` 目录下准备以下图片资源：
     - `app_icon.png` - 默认头像（已有）
     - `edit.png` - 编辑按钮图标
     - `back.png` - 返回按钮图标（可选）
     - `arrow_down.png` - 下拉箭头图标（可选，Select组件自带）

2. **路由配置**
   - 确保在 `module.json5` 中配置了编辑页面的路由
   - 使用 `@kit.ArkUI` 中的 Router 进行页面导航

3. **状态管理最佳实践**
   - 数据模型类使用 `@Observed` 装饰器
   - 父组件使用 `@State` 管理数据集合
   - 子组件使用 `@ObjectLink` 建立数据绑定
   - 直接修改对象属性即可触发UI更新，无需手动刷新

## 技术亮点

✅ **响应式数据绑定** - 使用官方推荐的 @Observed + @ObjectLink 模式  
✅ **组件化架构** - StudentItem 独立组件，便于维护  
✅ **现代UI组件** - Select 下拉选择器提升用户体验  
✅ **自动UI更新** - 数据变更自动反映到界面  
✅ **清晰的代码结构** - 职责分离，易于扩展  

## 开发规范

- **命名规范**：使用驼峰命名法，组件名首字母大写
- **文件组织**：按功能模块组织文件结构
- **状态管理**：遵循单向数据流原则
- **组件设计**：保持组件职责单一，提高复用性

## 使用说明

1. 启动应用后显示学生信息列表
2. 点击任意学生卡片右侧的编辑图标进入编辑页面
3. 在编辑页面修改学生信息：
   - 姓名：文本输入框
   - 年龄：数字输入框
   - 性别：下拉选择器 (男/女)
4. 点击"保存"按钮保存修改并返回列表（数据自动更新）
5. 点击"取消"按钮放弃修改并返回列表

## 学习价值

本项目展示了鸿蒙ArkUI开发的核心概念：
- **响应式状态管理**：@Observed + @ObjectLink 数据绑定
- **组件化开发**：可复用的 StudentItem 组件
- **页面路由导航**：@kit.ArkUI Router 使用
- **现代UI组件**：Select、TextInput、List 等
- **数据传递机制**：页面间参数传递和状态同步

适合作为鸿蒙开发学习的入门项目。

## 开发环境
- **IDE**: DevEco Studio 4.1+
- **SDK**: HarmonyOS SDK 4.1+
- **语言**: ArkTS (TypeScript 扩展)
- **框架**: ArkUI 声明式UI框架
