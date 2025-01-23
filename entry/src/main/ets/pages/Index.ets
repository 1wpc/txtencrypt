import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI'
import { preferences } from '@kit.ArkData';
import { common, Want } from '@kit.AbilityKit';

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
    Tabs({barPosition: BarPosition.End}){
      TabContent(){
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
      .tabBar({icon:$r('app.media.main'),text:'首页'})

      TabContent(){
        RelativeContainer() {
          List({space: 20}){
            ListItem(){
              Row(){
                Image($r('app.media.policy'))
                  .width(50)
                  .height(50)
                  .margin({left:10})
                Text('隐私政策')
                  .fontSize(30)
                  .margin({left:10})
              }
            }
            .onClick(() => {
              promptAction.showDialog({
                title: '即将访问以下网址',
                message: 'https://1wpc.github.io/policy/',
                buttons: [
                  {
                    text: '取消',
                    color: '#ffe92828'
                  },
                  {
                    text: '确定',
                    color: '#ff379cea'
                  }
                ]
              }, (err, data)=>{
                if(data.index == 1){
                  let want: Want ={
                    action: 'ohos.want.action.viewData',
                    entities: ['entity.system.browsable'],
                    abilityName: 'MainAbility',
                    uri: 'https://1wpc.github.io/policy/',
                  }
                  this.context.startAbility(want)
                }
              })
            })
          }
        }
      }
      .tabBar({icon:$r('app.media.setting'),text:'设置'})
    }
  }
}