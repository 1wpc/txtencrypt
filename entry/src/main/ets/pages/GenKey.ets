import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util, buffer } from '@kit.ArkTS';

@Entry
@Component
struct GenKey {
  @State result1: string = '';
  @State result2: string = '';

  build() {
    Column({ space: 20 }){
      Text('密钥生成')
        .fontSize(20)
        .fontWeight(FontWeight.Bold);
      Row(){
        Button('生成RSA密钥')
          .height(40)
          .onClick(() => {
            let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
            let keyPair = rsaGenerator.generateKeyPairSync();
            console.info('generateKeyPairSync success');
            this.result1 = keyPair.pubKey.getEncodedPem('PKCS1')
            this.result2 = keyPair.priKey.getEncodedPem('PKCS1');
          })
          .margin({ right: 5 })

        Button('生成AES密钥')
          .height(40)
          .onClick(() => {
            let symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
            let key = symKeyGenerator.generateSymKeySync();
            let encodedKey = key.getEncoded();
            console.info('key hex:' + encodedKey.data);
            let base64 = new util.Base64Helper();
            this.result1 = base64.encodeToStringSync(encodedKey.data);
          })
          .margin({ left: 5 })
      }
      Text(this.result1)
        .copyOption(CopyOptions.LocalDevice)
      Text(this.result2)
        .copyOption(CopyOptions.LocalDevice)
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f0f0f0');
  }
}