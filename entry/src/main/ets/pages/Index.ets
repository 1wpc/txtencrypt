import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      List({ space: 20 }) {
        ListItem() {
          Column() {
            Text("RSA加解密")
              .margin({top:20})
              .fontSize(40)
          }
          .width('100%')
          .height(100)
          .backgroundColor('#f0f0f0')
          .borderRadius(10)
        }
        .margin({ left:10, right:10 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Rsa' })
        })

        ListItem() {
          Column() {
            Text("AES加解密")
              .margin({top:20})
              .fontSize(40)
          }
          .width('100%')
          .height(100)
          .backgroundColor('#f0f0f0')
          .borderRadius(10)
          .padding(10)
        }
        .margin({ left:10, right:10 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Aes' })
        })

        ListItem() {
          Column() {
            Text("密钥生成")
              .margin({top:20})
              .fontSize(40)
          }
          .width('100%')
          .height(100)
          .backgroundColor('#f0f0f0')
          .borderRadius(10)
          .padding(10)
        }
        .margin({ left:10, right:10 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/GenKey' })
        })

        ListItem() {
          Column() {
            Text("base64编解码")
              .margin({top:20})
              .fontSize(40)
          }
          .width('100%')
          .height(100)
          .backgroundColor('#f0f0f0')
          .borderRadius(10)
          .padding(10)
        }
        .margin({ left:10, right:10 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Base64' })
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}