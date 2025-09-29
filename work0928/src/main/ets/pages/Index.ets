@Entry
@Component
struct Index {
  @State result: string = '0' // 显示的计算结果
  @State expression: string = '' // 计算表达式
  @State isNewInput: boolean = true // 是否是新输入，用于判断是否清除显示结果
  @State currentOperator: string = '' // 当前运算符
  @State previousValue: number = 0 // 上一个数值

  // 自定义计算函数，避免使用eval
  calculateExpression(expression: string): number {
    // 将表达式拆分为操作数和运算符
    const tokens: string[] = []
    let currentNumber = ''

    // 遍历表达式，提取数字和运算符
    for (let i = 0; i < expression.length; i++) {
      const char = expression[i]
      if (char === '+' || char === '-' || char === '/' || char === '*') {
        if (currentNumber !== '') {
          tokens.push(currentNumber)
          currentNumber = ''
        }
        tokens.push(char)
      } else {
        currentNumber += char
      }
    }

    // 添加最后一个数字
    if (currentNumber !== '') {
      tokens.push(currentNumber)
    }

    // 如果没有足够的操作数和运算符，返回最后一个数字或0
    if (tokens.length < 3) {
      return tokens.length > 0 ? parseFloat(tokens[0]) : 0
    }

    // 先计算乘除，再计算加减
    let result = parseFloat(tokens[0])
    let i = 1

    // 第一次遍历：处理乘法和除法
    while (i < tokens.length) {
      const operator = tokens[i]
      const nextNumber = parseFloat(tokens[i + 1])

      if (operator === '*') {
        result *= nextNumber
        i += 2
      } else if (operator === '/') {
        if (nextNumber === 0) {
          throw new Error('除以零错误')
        }
        result /= nextNumber
        i += 2
      } else {
        // 跳过加减操作，留到第二次遍历
        i += 2
      }
    }

    // 第二次遍历：处理加法和减法
    i = 1
    while (i < tokens.length) {
      const operator = tokens[i]
      const nextNumber = parseFloat(tokens[i + 1])

      if (operator === '+') {
        result += nextNumber
        i += 2
      } else if (operator === '-') {
        result -= nextNumber
        i += 2
      } else {
        // 跳过乘除操作，已经在第一次遍历中处理过
        i += 2
      }
    }

    return result
  }

  // 处理按钮点击事件
  handleButtonClick(value: string) {
    switch (value) {
      case 'CE': // 清除当前输入
        this.result = '0'
        this.isNewInput = true
        break
      case 'C': // 清除所有
        this.result = '0'
        this.expression = ''
        this.isNewInput = true
        break
      case '=': // 计算结果
        try {
          if (this.expression === '') {
            return // 如果表达式为空，不执行计算
          }

          // 替换乘法符号
          let finalExpression = this.expression + this.result
          finalExpression = finalExpression.replace(/X/g, '*')

          // 使用自定义计算函数计算表达式结果
          const calcResult: number = this.calculateExpression(finalExpression)

          // 处理结果，如果是整数就不显示小数点后面的零
          if (Number.isInteger(calcResult)) {
            this.result = String(calcResult)
          } else {
            // 限制小数位数，避免过长
            this.result = String(parseFloat(calcResult.toFixed(8)))
          }

          this.expression = ''
          this.isNewInput = true
        } catch (error) {
          this.result = '错误'
          this.expression = ''
          this.isNewInput = true
        }
        break
      case '+':
      case '-':
      case '/':
      case 'X':
        // 处理运算符
        if (this.expression.endsWith('+') || this.expression.endsWith('-') ||
            this.expression.endsWith('/') || this.expression.endsWith('X')) {
          // 如果表达式已经以运算符结束，则替换最后一个运算符
          this.expression = this.expression.slice(0, -1) + value
        } else {
          this.expression = this.expression + this.result + value
        }
        this.isNewInput = true
        break
      case '.':
        // 处理小数点
        if (!this.result.includes('.')) {
          if (this.isNewInput) {
            this.result = '0.'
            this.isNewInput = false
          } else {
            this.result += '.'
          }
        }
        break
      default:
        // 处理数字输入
        if (this.isNewInput) {
          this.result = value
          this.isNewInput = false
        } else {
          // 避免数字过长
          if (this.result.length < 12) {
            this.result = this.result === '0' ? value : this.result + value
          }
        }
        break
    }
  }

  // 创建按钮的Builder函数
  @Builder
  CalcButton(text: string) {
    Button({ type: ButtonType.Normal }) {
      Text(text)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#c6c6c6')
    .borderRadius(5)
    .onClick(() => this.handleButtonClick(text))
    .stateEffect(true) // 添加点击效果
    .shadow({ radius: 5, color: 'rgba(0, 0, 0, 0.1)', offsetX: 2, offsetY: 2 }) // 添加阴影效果
  }

  build() {
    Column() {
      // 显示结果区域
      Column() {
        // 显示表达式
        Text(this.expression)
          .width('100%')
          .fontSize(20)
          .fontColor('#666666')
          .textAlign(TextAlign.End)
          .padding(2)

        // 显示当前结果
        Text(this.result)
          .width('100%')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.End)
          .padding({ right: 16, bottom: 8 })
      }
      .width('100%')
      .height('15%')
      .backgroundColor('#bcbcbc')
      .borderRadius(5)
      .margin({ top: 20, bottom: 20 })
      .justifyContent(FlexAlign.SpaceBetween)

      // 使用Grid网格布局创建计算器按钮
      Grid() {
        // 第一行按钮：CE、C、/、X
        GridItem() {
          this.CalcButton('CE')
        }.columnStart(0).columnEnd(0)

        GridItem() {
          this.CalcButton('C')
        }.columnStart(1).columnEnd(1)

        GridItem() {
          this.CalcButton('/')
        }.columnStart(2).columnEnd(2)

        GridItem() {
          this.CalcButton('X')
        }.columnStart(3).columnEnd(3)

        // 第二行按钮：7、8、9、-
        GridItem() {
          this.CalcButton('7')
        }.columnStart(0).columnEnd(0)

        GridItem() {
          this.CalcButton('8')
        }.columnStart(1).columnEnd(1)

        GridItem() {
          this.CalcButton('9')
        }.columnStart(2).columnEnd(2)

        GridItem() {
          this.CalcButton('-')
        }.columnStart(3).columnEnd(3)

        // 第三行按钮：4、5、6、+
        GridItem() {
          this.CalcButton('4')
        }.columnStart(0).columnEnd(0)

        GridItem() {
          this.CalcButton('5')
        }.columnStart(1).columnEnd(1)

        GridItem() {
          this.CalcButton('6')
        }.columnStart(2).columnEnd(2)

        GridItem() {
          this.CalcButton('+')
        }.columnStart(3).columnEnd(3)

        // 第四行按钮：1、2、3、=
        GridItem() {
          this.CalcButton('1')
        }.columnStart(0).columnEnd(0)

        GridItem() {
          this.CalcButton('2')
        }.columnStart(1).columnEnd(1)

        GridItem() {
          this.CalcButton('3')
        }.columnStart(2).columnEnd(2)

        GridItem() {
          this.CalcButton('=')
        }.columnStart(3).columnEnd(3).rowStart(3).rowEnd(4)

        // 第五行按钮：0、.
        GridItem() {
          this.CalcButton('0')
        }.columnStart(0).columnEnd(1)

        GridItem() {
          this.CalcButton('.')
        }.columnStart(2).columnEnd(2)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
      .columnsGap(12)
      .rowsGap(12)
      .width('100%')
      .height('75%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f0f0f0')
    .padding(10)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
