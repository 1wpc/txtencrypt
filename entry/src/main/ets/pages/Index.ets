import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      List({space: 10}){
        ListItem(){
          Column(){
            Text("RSA")
              .fontSize(50)
              .onClick(()=>{
                router.pushUrl({ url: 'pages/Rsa' })
              })
            Divider()
              .strokeWidth(2)
          }
        }
        ListItem(){
          Column(){
            Text("AES")
              .fontSize(50)
              .onClick(()=>{
                router.pushUrl({ url: 'pages/Aes' })
              })
            Divider()
              .strokeWidth(2)
          }
        }
      }
    }
    .height('100%')
    .width('100%')
  }
}