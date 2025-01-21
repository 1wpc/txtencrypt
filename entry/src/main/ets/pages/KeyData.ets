import { router } from '@kit.ArkUI'

@Entry
@Component
struct KeyData {
  private item: Map<string, string> = router.getParams() as Map<string, string>;

  build() {
    Column() {
      Text(this.item.get('type') as string)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
        .padding({ left: 10, right: 10 })
        .backgroundColor('#f0f0f0')
        .border({ width: 1, color: '#ccc' })
        .width('100%')
        .height(40)

      Text(this.item.get('time') as string)
       .fontSize(20)
      Text()
      Text()
    }
  }
}