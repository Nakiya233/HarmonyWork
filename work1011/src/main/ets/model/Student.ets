// 学生数据类
@Observed
export class Student {
  id: number
  name: string
  age: number
  gender: string
  avatar: Resource

  constructor(id: number, name: string, age: number, gender: string, avatar: Resource) {
    this.id = id
    this.name = name
    this.age = age
    this.gender = gender
    this.avatar = avatar
  }
}
