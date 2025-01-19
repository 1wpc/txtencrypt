import { cryptoFramework } from '@kit.CryptoArchitectureKit';

@Entry
@Component
struct GenKey {

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
            console.info('public key: ' + keyPair.pubKey.toString());
            console.info('private key: ' + keyPair.priKey.toString());
          });

        Button('生成AES密钥')
          .height(40)
          .onClick(() => {
            let symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
            // 使用密钥生成器随机生成对称密钥
            let key = symKeyGenerator.generateSymKeySync();
            let encodedKey = key.getEncoded();
            console.info('key hex:' + encodedKey.data);
          });
      }
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f0f0f0');
  }
}