import auth, { Auth, Region} from '@hw-agconnect/auth';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { cloudCommon } from '@kit.CloudFoundationKit';
import { request } from '@kit.BasicServicesKit';
import { cloudStorage } from '@kit.CloudFoundationKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { GlobalContext } from '../common/GlobalContext';
import { fileIo as fs } from '@kit.CoreFileKit';
import { cloudFunction } from '@kit.CloudFoundationKit';
import { VerifyCodeAction } from '@hw-agconnect/auth';

let storageBucket: cloudStorage.StorageBucket = cloudStorage.bucket('test-fphft'); // 将启动异步任务查询云侧默认实例
function callFunction() {
  cloudFunction.call({
    name: 'wx', // functionName需替换为实际的函数名
    version: '$latest',   // 如果不传入版本号，默认为“$latest”。
    timeout: 10 * 1000,   // 单位为毫秒，默认为70*1000毫秒。
    data: {               // data为函数请求体
      param1: 'val1',
      param2: 'val2'
    }
  }).then((value: cloudFunction.FunctionResult) => {
    hilog.info(0x0000, 'demo', `Succeeded in calling the function, result: ${JSON.stringify(value.result)}`);
  }).catch((err: BusinessError) => {
    hilog.error(0x0000, 'demo', `Failed to call the function, code: ${err.code}, message: ${err.message}`);
  })
}

@Entry
@Component
struct Dianzan_Page {
  // 上传指定文件至云侧
  upload() {
    this.selectPhoto().then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      let fileUri = photoSelectResult.photoUris[0];
      hilog.info(0x0000, 'demo', `pick file ${fileUri}`);
      let fileName = fileUri.split('/').pop() as string;
      hilog.info(0x0000, 'demo', `file name ${fileName}`);
      let cacheFile = GlobalContext.getContext().cacheDir + '/' + fileName;
      hilog.info(0x0000, 'demo', `cacheFile ${cacheFile}`);
      // 将选中文件copy至cache目录下
      this.copyFile(fileUri, cacheFile);
      // 上传至云存储默认实例
      this.uploadFile(cacheFile, `screenshot/${fileName}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'demo', `Failed to upload file, code: ${err.code}, message: ${err.message}`);
    })
  }

  /**
   * @throws photoViewPicker select throws
   */
  selectPhoto(): Promise<photoAccessHelper.PhotoSelectResult> {
    // 使用photoAccessHelper选择指定的文件
    let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 过滤选择媒体文件类型为IMAGE
    photoSelectOptions.maxSelectNumber = 1; // 选择媒体文件的最大数目
    let photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    return photoViewPicker.select(photoSelectOptions);
  }

  copyFile(srcPath: string, dstPath: string) {
    try {
      let srcFile = fs.openSync(srcPath);
      let dstFile = fs.openSync(dstPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.copyFileSync(srcFile.fd, dstFile.fd);
      fs.closeSync(srcFile);
      fs.closeSync(dstFile);
    } catch (e) {
      hilog.error(0x0000, 'demo', `copy file failed ${e.message}`);
      return;
    }
  }

  uploadFile(localPath: string, cloudPath: string) {
    storageBucket.uploadFile(GlobalContext.getContext(), {
      localPath: localPath, // 本地文件路径（context.cacheDir目录下的文件路径）
      cloudPath: cloudPath   // 云侧路径，支持传入“文件目录/文件名”（如“screenshot/demo.jpg”），或仅传入文件名。
    }).then((task: request.agent.Task) => {
      task.on('progress', (progress) => {
        hilog.info(0x0000, 'demo', `on progress ${JSON.stringify(progress)}`);
      });
      task.on('completed', (progress) => {
        hilog.info(0x0000, 'demo', `on completed ${JSON.stringify(progress)}`);
        // 删除cache目录临时文件
        fs.unlink(localPath).catch((err: BusinessError) => {
          hilog.error(0x0000, 'demo', `Failed to unlink, code: ${err.code}, message: ${err.message}.`);
        });
      });
      task.on('failed', (progress) => {
        hilog.info(0x0000, 'demo', `on failed ${JSON.stringify(progress)}`);
        // 删除cache目录临时文件
        fs.unlink(localPath).catch((err: BusinessError) => {
          hilog.error(0x0000, 'demo', `Failed to unlink, code: ${err.code}, message: ${err.message}.`);
        });
      });
      task.on('response', (response) => {
        hilog.info(0x0000, 'demo', `on response ${JSON.stringify(response)}`);
      });

      // start task
      task.start((err: BusinessError) => {
        if (err) {
          hilog.error(0x0000, 'demo',
            `Failed to start a file upload task, code: ${err.code}, message: ${err.message}`);
        } else {
          hilog.info(0x0000, 'demo', `Succeeded in starting a file upload task.`);
        }
      });
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'demo', `Failed to upload file, code: ${err.code}, message: ${err.message}`);
    })
  }


  build() {
    Column() {
      Button('登录')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(()=>{
          auth.getCurrentUser().then(user=>{
            if(user){
              hilog.fatal(0x0000, 'demo', '已有用户:' + JSON.stringify(user))
            }else {
              auth.signIn({
                autoCreateUser: true,
                "credentialInfo": {
                  "kind": 'hwid'
                }
              }).then(signInResult => {
                hilog.info(0x0000, 'demo', '%{public}s',  `signInHwid success. result: ${signInResult.getUser().getUid()}`);
              })
                .catch((error: BusinessError) => {
                  hilog.error(0x0000, 'demo', '%{public}s', `signInHwid error, Code: ${error.code}, message: ${error.message}`);
                })
            }
          });
          })
      Button('登出')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(()=>{
          auth.signOut().then(() => {
            // 登出成功
            hilog.fatal(0x0000, 'demo', '登出成功')
          }).catch((error: BusinessError) => {
            // 登出失败
            hilog.fatal(0x0000, 'demo', '登出失败' + error)
          });
        })
      Button('获取用户凭据')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(async ()=> {
          let token = await auth.getToken(false, Region.CN);
          let tokenString = token.tokenString;
          let expiration = token.expiration;
          hilog.fatal(0x0000, 'demo', '提取的AccessToken:' + token+'\n'+tokenString + expiration );

          let authProvider = auth.getAuthProvider();
          hilog.fatal(0x0000, 'demo', '提取的authProvider:' + JSON.stringify(authProvider) );
          cloudCommon.init({
            region: cloudCommon.CloudRegion.CHINA,
            authProvider: authProvider,
            functionOptions: { timeout: 10 * 1000 },
            storageOptions: { mode: request.agent.Mode.BACKGROUND, network: request.agent.Network.ANY },
            databaseOptions: { schema: "schema.json", traceId: "traceId" }
          })
          this.upload()
        })
      Button('测试云函数')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(()=>{
          callFunction()
        })
      Button('邮箱登录')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(()=>{
          auth.requestVerifyCode({
            action: VerifyCodeAction.REGISTER_LOGIN,
            lang: 'zh_CN',
            sendInterval: 60,
            verifyCodeType: {
              email: '1172057677@qq.com',
              kind: 'email'
            }
          }).then(verifyCodeResult => {
            hilog.info(0x0000, 'demo', '验证码:' + JSON.stringify(verifyCodeResult));
          }).catch((error: BusinessError) => {
            // 验证码申请失败
            hilog.error(0x0000, 'demo', '验证码申请失败:' + error);
          })
          let res = auth.getCurrentUser();
          hilog.info(0x0000, 'demo', '当前用户:' + JSON.stringify(res));
        })
      Button('注册邮箱用户')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(()=>{
          auth.createUser({
            "kind": 'email',
            "email": '1172057677@qq.com',
            "password": 'zgq123456',
            "verifyCode": '614367'
          }).then(result => {
            // 创建账号成功后，默认已登录
            hilog.info(0x0000, 'demo', '创建账号成功:' + JSON.stringify(result));
          }).catch((error: BusinessError) => {
            // 创建用户失败
            hilog.error(0x0000, 'demo', '创建账号失败:' + error);
          })
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}