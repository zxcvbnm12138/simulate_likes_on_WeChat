import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import auth from '@hw-agconnect/auth';
import buffer from '@ohos.buffer';
import {GlobalContext} from '../common/GlobalContext'


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    let file = this.context.resourceManager.getRawFileContentSync('agconnect-services.json');
    let json: string = buffer.from(file.buffer).toString();
    auth.init(this.context, json);
    GlobalContext.initContext(this.context)
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 在这里修改 当前模块 下的 UIAbility 下的启动页
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      // let windowClass: window.Window | undefined = undefined;
      let windowClass: window.Window = windowStage.getMainWindowSync(); // 获取应用主窗口

      // 1. 设置窗口全屏
      let isLayoutFullScreen = true;
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen).then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
      });
      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR; // 以导航条避让为例
      let avoidArea = windowClass.getWindowAvoidArea(type);
      let bottomRectHeight = avoidArea.bottomRect.height; // 获取到导航条区域的高度
      AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight);

      type = window.AvoidAreaType.TYPE_SYSTEM; // 以状态栏避让为例
      avoidArea = windowClass.getWindowAvoidArea(type);
      let topRectHeight = avoidArea.topRect.height; // 获取状态栏区域高度
      AppStorage.setOrCreate('topRectHeight', topRectHeight);

      windowClass.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          let topRectHeight = data.area.topRect.height;
          AppStorage.setOrCreate('topRectHeight', topRectHeight);
        } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          let bottomRectHeight = data.area.bottomRect.height;
          AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight);
        }
      });
      windowClass.setSpecificSystemBarEnabled('navigationIndicator', false).then(() => {
        console.info('Succeeded in setting the navigation indicator to be invisible.');
      }).catch((err: BusinessError) => {
        console.error(`Failed to set the navigation indicator to be invisible. Code is ${err.code}, message is ${err.message}`);
      });


      // 设置虚拟键盘抬起时压缩页面大小为减去键盘的高度
      windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}