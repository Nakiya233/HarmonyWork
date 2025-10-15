import axios, { AxiosError, AxiosResponse } from '@ohos/axios';

interface  Phone{
  number :string
  type: string
  color: string
  price: string

}


function postData(){

  let apiUrl:string = 'http://127.0.0.1:8080/addPhone';
  axios.post<string,AxiosResponse,Phone>(apiUrl,{
    number:'1',
    type:'HUAWEI',
    color:'White',
    price:'9999.99'
  }).then((response:AxiosResponse)=>{
    console.log("request result: "+JSON.stringify(response))
  }).catch((error:AxiosError)=>{
    console.log("request error: "+JSON.stringify(error))
  })

}


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
        })

      Button('发送请求')
        .onClick(()=>postData())
    }
    .height('100%')
    .width('100%')
  }
}