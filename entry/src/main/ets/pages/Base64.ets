import { util, buffer } from '@kit.ArkTS';
import { promptAction } from '@kit.ArkUI';
import { copyText } from './tools/util';

@Entry
@Component
struct Base64 {
  @State isEncode: boolean = true
  @State content: string = ''
  @State result: string = ''

  build() {
    Column({ space: 20 }) {
      Row({ space: 10 }){
        Text( this.isEncode ? 'Base64编码' : 'Base64解码' )
          .fontSize(20)
          .fontWeight(FontWeight.Bold);
        Toggle({
          type: ToggleType.Switch,
          isOn: this.isEncode
        })
        .onChange((isOn: boolean) => {this.isEncode = isOn})
        .width(100)
        .height(40);
      }
      TextArea({
        placeholder: this.isEncode ? '文本' : 'base64编码'
      })
      .onChange((value: string) => {
        this.content = value;
      })
      .width('100%')
      .height(200)
      .border({ width: 1, color: '#ccc' })
      .padding(10)
      Button("执行")
        .width(100)
        .height(40)
        .onClick(async () => {
          if (this.isEncode) {
            if (this.content.length > 0) {
              try {
                let base64 = new util.Base64Helper()
                this.result = base64.encodeToStringSync(new Uint8Array(buffer.from(this.content).buffer))
              } catch (e) {
                console.error(e)
              }
            }
          } else {
            if (this.content.length > 0) {
              try {
                let base64 = new util.Base64Helper()
                this.result = buffer.from(base64.decodeSync(this.content)).toString()
              } catch (e) {
                console.error(e)
              }
            }
          }
          promptAction.showToast({message: '点击文本复制'})
        });
      Text(this.result)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .copyOption(CopyOptions.LocalDevice)
        .onClick(() => {
          copyText(this.result)
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f0f0f0');
  }
}