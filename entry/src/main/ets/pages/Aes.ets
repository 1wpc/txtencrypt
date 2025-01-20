import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer, util } from '@kit.ArkTS';

function generateRandom(len: number) {
  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(len);
  return generateRandSync;
}

function genGcmParamsSpec() {
  let ivBlob = generateRandom(12);
  let arr = [1, 2, 3, 4, 5, 6, 7, 8]; // 8 bytes
  let dataAad = new Uint8Array(arr);
  let aadBlob: cryptoFramework.DataBlob = { data: dataAad };
  arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
  let dataTag = new Uint8Array(arr);
  let tagBlob: cryptoFramework.DataBlob = {
    data: dataTag
  };
  // GCM的authTag在加密时从doFinal结果中获取，在解密时填入init函数的params参数中
  let gcmParamsSpec: cryptoFramework.GcmParamsSpec = {
    iv: ivBlob,
    aad: aadBlob,
    authTag: tagBlob,
    algName: "GcmParamsSpec"
  };
  return gcmParamsSpec;
}
let gcmParams = genGcmParamsSpec();

function encryptMessage(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('AES128|GCM|PKCS7');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams);
  let encryptUpdate = cipher.updateSync(plainText);
  // gcm模式加密doFinal时传入空，获得tag数据，并更新至gcmParams对象中。
  gcmParams.authTag = cipher.doFinalSync(null);
  return encryptUpdate;
}
// 解密消息
function decryptMessage(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('AES128|GCM|PKCS7');
  decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, gcmParams);
  let decryptUpdate = decoder.updateSync(cipherText);
  // gcm模式解密doFinal时传入空，验证init时传入的tag数据，如果验证失败会抛出异常。
  let decryptData = decoder.doFinalSync(null);
  if (decryptData == null) {
    console.info('GCM decrypt success, decryptData is null');
  }
  return decryptUpdate;
}

function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
  let symKey = aesGenerator.convertKeySync(symKeyBlob);
  console.info('convertKeySync success');
  return symKey;
}

@Entry
@Component
struct Aes {
  @State private isEncrypt: boolean = true;
  @State private results: string = '';
  private Key: string = '';
  private cipherText: string = '';

  build() {
    Column({ space: 20 }) {
      Row({ space: 10 }) {
        Text(this.isEncrypt ? 'AES加密' : 'AES解密')
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

      TextArea({
        placeholder: 'Key'
      })
        .onChange((value: string) => {
          this.Key = value;
        })
        .width('100%')
        .height(100)
        .border({ width: 1, color: '#ccc' })
        .padding(10);

      TextArea({
        placeholder: this.isEncrypt ? '明文' : '密文'
      })
        .onChange((value: string) => {
          this.cipherText = value;
        })
        .width('100%')
        .height(200)
        .border({ width: 1, color: '#ccc' })
        .padding(10);

      Button("执行")
        .width(100)
        .height(40)
        .onClick(async () => {
          if (this.isEncrypt) {
            if (this.Key.length > 0 && this.cipherText.length > 0) {
              try {
                let base64 = new util.Base64Helper()
                let smyKey = genSymKeyByData(base64.decodeSync(this.Key));
                let arr = encryptMessage(smyKey, { data: new Uint8Array(buffer.from(this.cipherText).buffer)}).data
                this.results = base64.encodeToStringSync(arr)
              } catch (e) {
                console.error(e)
              }
            }
          }else if (this.Key.length > 0 && this.cipherText.length > 0) {
            try {
              let base64 = new util.Base64Helper()
              let smyKey = genSymKeyByData(base64.decodeSync(this.Key));
              let arr =decryptMessage(smyKey, { data: base64.decodeSync(this.cipherText)}).data
              this.results = buffer.from(arr).toString()
            } catch (e) {
              console.error(e)
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