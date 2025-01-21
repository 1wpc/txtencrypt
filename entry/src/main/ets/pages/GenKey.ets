import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util, buffer } from '@kit.ArkTS';
import { copyText } from './tools/util';
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { BasicDataSource } from './tools/BasicDataSource';
import { JSON } from '@kit.ArkTS';
import { router } from '@kit.ArkUI';

let dataPreferences: preferences.Preferences | null = null;

function  Map2Rec(map:Map<string, ESObject>):Record<string,ESObject>{
  let Rec:Record<string,ESObject> = {};
  map.forEach((value:ESObject, key:string) => {
    if(value instanceof Map){
      let vRec:Record<string,ESObject> = Map2Rec(value);
      value = vRec
    }
    Rec[key] = value
  })
  return Rec
}

class Data extends BasicDataSource{
  public items: Array<Map<string, string>> = [];

  public totalCount(): number {
    return this.items.length;
  }

  public getData(index: number): Map<string, string> {
    return this.items[index];
  }
}

@Entry
@Component
struct GenKey {
  private context = getContext(this) as common.UIAbilityContext;
  @State result1: string = '';
  @State result2: string = '';
  private data: Data = new Data();

  save(){
    let data: string[] = []
    for(let i = 0; i < this.data.items.length; i++){
      let rec: Record<string, ESObject> = Map2Rec(this.data.items[i])
      data.push(JSON.stringify(rec))
    }
    dataPreferences?.putSync('keys', data)
    dataPreferences?.flush()
  }

  aboutToAppear(): void {
    let options: preferences.Options = { name: 'info' };
    dataPreferences = preferences.getPreferencesSync(this.context, options);
    let data: string[] = dataPreferences?.getSync('keys', []) as string[];
    for(let i = 0; i < data.length; i++){
      this.data.items.push(JSON.parse(data[i]) as Map<string, string>)
    }
  }

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
            this.result2 = keyPair.priKey.getEncodedPem('PKCS1')
            this.data.items.push(new Map([
              ['type', 'RSA'],
              ['time', new Date().toLocaleString()],
              ['pubKey', this.result1],
              ['priKey', this.result2]
            ]))
            this.save()
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
            this.data.items.push(new Map([
              ['type', 'AES'],
              ['time', new Date().toLocaleString()],
              ['key', this.result1]
            ]))
            this.save()
            copyText(this.result1)
          })
          .margin({ left: 5 })
      }
      List({space: 10}){
        LazyForEach(this.data, (item: Map<string, string>)=>{
          ListItem(){
            Row(){
              Text(item['type'])
                .fontSize(15)
              Text(item['time'])
                .fontSize(10)
                .margin({left:20})
            }
          }
          .onClick(() => {
            router.pushUrl({ url: '/pages/KeyData', params:item})
          })
        })
      }
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f0f0f0');
  }
}