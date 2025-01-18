import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util, buffer } from '@kit.ArkTS';

function encryptMessage(publicKey: cryptoFramework.PubKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('RSA1024|PKCS1');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, publicKey, null);
  let encryptData = cipher.doFinalSync(plainText);
  return encryptData;
}

function decryptMessage(privateKey: cryptoFramework.PriKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('RSA1024|PKCS1');
  decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, privateKey, null);
  let decryptData = decoder.doFinalSync(cipherText);
  return decryptData;
}

function genKeyPairByData(pubKeyData: Uint8Array, priKeyData: Uint8Array) {
  let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKeyData };
  let priKeyBlob: cryptoFramework.DataBlob = { data: priKeyData };
  let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
  let keyPair = rsaGenerator.convertKeySync(pubKeyBlob, priKeyBlob);
  console.info('convertKeySync success');
  return keyPair;
}

@Entry
@Component
struct Rsa {
  @State private isEncrypt: boolean = true;
  @State private results: string = '';
  private Key: string = '';
  private cipherText: string = '';

  build() {
    Column({ space: 20 }) {
      Row({ space: 10 }) {
        Text(this.isEncrypt ? 'RSA加密' : 'RSA解密')
          .fontSize(20)
          .fontWeight(FontWeight.Bold);

        Toggle({
          type: ToggleType.Switch,
          isOn: this.isEncrypt
        })
          .onChange((isOn: boolean) => {this.isEncrypt = isOn})
          .width(100)
          .height(40);
      }

      TextInput({
        placeholder: this.isEncrypt ? 'public key' : 'private key'
      })
        .onChange((value: string) => {
          this.Key = value;
        })
        .width('100%')
        .height(200)
        .border({ width: 1, color: '#ccc' })
        .padding(10);

      TextInput({
        placeholder: this.isEncrypt ? '明文' : '密文'
      })
        .onChange((value: string) => {
          this.cipherText = value;
        })
        .width('100%')
        .height(200)
        .border({ width: 1, color: '#ccc' })
        .padding(10);

      Button("⇄")
        .width(100)
        .height(40)
        .onClick(async () => {
          if (this.isEncrypt) {
            if (this.Key.length > 0 && this.cipherText.length > 0) {
              try {
                let base64 = new util.Base64Helper()
                let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
                let keyPair = rsaGenerator.convertPemKeySync(this.Key, null);
                let pubKey = keyPair.pubKey;
                let arr = encryptMessage(pubKey, { data: new Uint8Array(buffer.from(this.cipherText).buffer)}).data
                this.results = base64.encodeToStringSync(arr)
                console.log(this.results)
              } catch (e) {
                console.error(e)
              }
            }
          }else{
            if (this.Key.length > 0 && this.cipherText.length > 0) {
              try {
                let base64 = new util.Base64Helper()
                let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
                let keyPair = rsaGenerator.convertPemKeySync(null, this.Key);
                let priKey = keyPair.priKey;
                let arr =decryptMessage(priKey, { data: base64.decodeSync(this.cipherText)}).data
                this.results = buffer.from(arr).toString()
              } catch (e) {
                console.error(e)
              }
            }
          }
        });

      Text(this.results)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .copyOption(CopyOptions.LocalDevice)
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f0f0f0');
  }
}