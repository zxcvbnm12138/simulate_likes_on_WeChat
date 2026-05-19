import auth from '@hw-agconnect/auth';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { cloudStorage } from '@kit.CloudFoundationKit';
import { cloudCommon } from '@kit.CloudFoundationKit';
import { request } from '@kit.BasicServicesKit';
import { GlobalContext } from '../common/GlobalContext';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { cloudDatabase } from '@kit.CloudFoundationKit';
import { comment_obj, pyq_data, personal_detail_data } from '../utils/data';
let storageBucket: cloudStorage.StorageBucket = cloudStorage.bucket(); // 将启动异步任务查询云侧默认实例


let databaseZone = cloudDatabase.zone('WX');
let cobj = new cloudDatabase.DatabaseQuery(comment_obj);
let pda = new cloudDatabase.DatabaseQuery(pyq_data);
let pdd = new cloudDatabase.DatabaseQuery(personal_detail_data);
let provider = auth.getAuthProvider();

@Entry
@Component
struct Test2 {
  @State message: string = 'Hello World';
  getList() {
    // 获取云存储默认实例中根路径下的文件列表
    storageBucket.list('').then((result: cloudStorage.ListResults) => {
      hilog.info(0x0000, 'test2', `Succeeded in listing files, result: ${JSON.stringify(result)}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'test2', `Failed to list files, code: ${err.code}, message: ${err.message}`);
    })
  }
  // 上传指定文件至云侧
  upload() {
    this.selectPhoto().then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      let fileUri = photoSelectResult.photoUris[0];
      hilog.info(0x0000, 'test2', `pick file ${fileUri}`);
      let fileName = fileUri.split('/').pop() as string;
      hilog.info(0x0000, 'test2', `file name ${fileName}`);
      let cacheFile = GlobalContext.getContext().cacheDir + '/' + fileName;
      hilog.info(0x0000, 'test2', `cacheFile ${cacheFile}`);
      // 将选中文件copy至cache目录下
      this.copyFile(fileUri, cacheFile);
      // 上传至云存储默认实例
      this.uploadFile(cacheFile, `screenshot/${fileName}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'test2', `Failed to upload file, code: ${err.code}, message: ${err.message}`);
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
      hilog.error(0x0000, 'test2', `copy file failed ${e.message}`);
      return;
    }
  }

  uploadFile(localPath: string, cloudPath: string) {
    storageBucket.uploadFile(GlobalContext.getContext(), {
      localPath: localPath, // 本地文件路径（context.cacheDir目录下的文件路径）
      cloudPath: cloudPath   // 云侧路径，支持传入“文件目录/文件名”（如“screenshot/demo.jpg”），或仅传入文件名。
    }).then((task: request.agent.Task) => {
      task.on('progress', (progress) => {
        hilog.info(0x0000, 'test2', `on progress ${JSON.stringify(progress)}`);
      });
      task.on('completed', (progress) => {
        hilog.info(0x0000, 'test2', `on completed ${JSON.stringify(progress)}`);
        // 删除cache目录临时文件
        fs.unlink(localPath).catch((err: BusinessError) => {
          hilog.error(0x0000, 'test2', `Failed to unlink, code: ${err.code}, message: ${err.message}.`);
        });
      });
      task.on('failed', (progress) => {
        hilog.info(0x0000, 'test2', `on failed ${JSON.stringify(progress)}`);
        // 删除cache目录临时文件
        fs.unlink(localPath).catch((err: BusinessError) => {
          hilog.error(0x0000, 'test2', `Failed to unlink, code: ${err.code}, message: ${err.message}.`);
        });
      });
      task.on('response', (response) => {
        hilog.info(0x0000, 'test2', `on response ${JSON.stringify(response)}`);
      });

      // start task
      task.start((err: BusinessError) => {
        if (err) {
          hilog.error(0x0000, 'test2',
            `Failed to start a file upload task, code: ${err.code}, message: ${err.message}`);
        } else {
          hilog.info(0x0000, 'test2', `Succeeded in starting a file upload task.`);
        }
      });
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'test2', `Failed to upload file, code: ${err.code}, message: ${err.message}`);
    })
  }

  getUrl(pic_name:string) {
    // 获取云存储默认实例中screenshot/screenshot_20250115_155321.jpg文件的下载地址
    storageBucket.getDownloadURL(pic_name).then((downloadURL: string) => {
      hilog.info(0x0000, 'test2', `Succeeded in getting download URL: ${downloadURL}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'test2', `Failed to get download URL, code: ${err.code}, message: ${err.message}`);
    })
  }

  async comment_obj_queryAll() {
    try {
      let resultArray = await databaseZone.query(cobj);
      hilog.info(0x0000, 'test2', `Succeeded in querying data, result: ${JSON.stringify(resultArray)}`);
    } catch (err) {
      hilog.error(0x0000, 'test2', `Failed to query data, code: ${err.code}, message: ${err.message}`);
    }
  }
  async pyq_data_queryAll() {
    try {
      let resultArray = await databaseZone.query(pda);
      hilog.info(0x0000, 'test2', `Succeeded in querying data, result: ${JSON.stringify(resultArray)}`);
    } catch (err) {
      hilog.error(0x0000, 'test2', `Failed to query data, code: ${err.code}, message: ${err.message}`);
    }
  }
  async personal_detail_data_queryAll() {
    try {
      let resultArray = await databaseZone.query(pdd);
      hilog.info(0x0000, 'test2', `Succeeded in querying data, result: ${JSON.stringify(resultArray)}`);
    } catch (err) {
      hilog.error(0x0000, 'test2', `Failed to query data, code: ${err.code}, message: ${err.message}`);
    }
  }
  async upsert() {
    try {
      let cobj_data = new comment_obj();
      cobj_data.comment_avatar = ' https://agc-storage-drcn.platform.dbankcloud.cn/v0/test-fphft/test_avater.jpg?token=c272849a-9ab2-46f5-b12a-25ac232cf4c2'
      cobj_data.comment_nickname = '菠萝赛西'
      cobj_data.comment_content ='测试数据'
      cobj_data.comment_time = new Date().getTime().toString()
      cobj_data.wx_number = '15212341234'
      cobj_data.pyq_id = '15212341234_2026_01_08_162031'
      let record = await databaseZone.upsert(cobj_data);
      hilog.info(0x0000, 'test2', `Succeeded in upserting a book, result: ${JSON.stringify(record)}`);
    } catch (err) {
      hilog.error(0x0000, 'test2', `Failed to upsert a book, code: ${err.code}, message: ${err.message}`);
    }
  }


  build() {
    Column({ space: 20 }) {
      Button('邮箱登录')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {
          auth.signIn({
            autoCreateUser: true,
            credentialInfo: {
              kind: 'email',
              password: 'zgq123456',
              email: '1172057677@qq.com'
            }
          }).then(user => {
            // 登录成功
            cloudCommon.init({
              region: cloudCommon.CloudRegion.CHINA,
              authProvider: provider,
              storageOptions: { mode: request.agent.Mode.BACKGROUND, network: request.agent.Network.ANY },
            })
            hilog.info(0x0000, 'test2', '登录成功:' + JSON.stringify(user));
          }).catch((error: BusinessError) => {
            // 登录失败
            hilog.info(0x0000, 'test2', '登录失败:' + JSON.stringify(error));
          });
        })

      Button('登出')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {
          auth.signOut().then(() => {
            // 登出成功
            hilog.fatal(0x0000, 'test2', '登出成功')
          }).catch((error: BusinessError) => {
            // 登出失败
            hilog.fatal(0x0000, 'test2', '登出失败' + error)
          });
        })


      Button('查看当前登录用户')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {
          auth.getCurrentUser().then(user => {
            if (user) {
              // 业务逻辑
              hilog.info(0x0000, 'test2', '登录成功:' + JSON.stringify(user));
            } else {
              // 业务逻辑
              hilog.info(0x0000, 'test2', '未登录');
            }
          })
        })

      Button('获取云存储文件列表')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {

          this.getList();

        })

      Button('上传文件')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {
          this.upload()
        })

      Button('获取图片下载链接')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {
          this.getUrl('test_avater.jpg')
        })
      Button('查询所有comment_obj')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {
          this.comment_obj_queryAll()
        })
      Button('查询所有pyq_data')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {
          this.pyq_data_queryAll()
        })
      Button('查询所有personal_detail_data')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {
          this.personal_detail_data_queryAll()
        })

      Button('上传comment_obj数据')
        .width(240)
        .height(60)
        .fontSize(18)
        .backgroundColor('#409EFF')
        .onClick(() => {
          this.upsert()
        })





    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}