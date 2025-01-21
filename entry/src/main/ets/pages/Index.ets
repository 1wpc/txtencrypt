import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI'
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

let dataPreferences: preferences.Preferences | null = null;

@Entry
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    let options: preferences.Options = { name: 'info' };
    dataPreferences = preferences.getPreferencesSync(this.context, options);
    let isFirst: boolean = dataPreferences.hasSync('First');
    if(!isFirst){
      promptAction.showDialog({
        title: '隐私声明',
        message: $r('app.string.policy'),
        buttons: [
          {
            text: '不同意',
            color: '#ffe92828'
          },
          {
            text: '同意',
            color: '#ff379cea'
          }
        ]
      });
      dataPreferences.putSync('First', false);
      dataPreferences.flush()
    }
  }

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