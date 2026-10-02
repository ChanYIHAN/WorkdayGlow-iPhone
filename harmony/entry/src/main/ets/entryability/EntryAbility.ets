import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AppStorage.setOrCreate('openLearning', want.parameters?.destination === 'learning');
    hilog.info(0x0000, 'WorkdayGlow', 'EntryAbility created');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AppStorage.setOrCreate('openLearning', want.parameters?.destination === 'learning');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (error) => {
      if (error.code) {
        hilog.error(0x0000, 'WorkdayGlow', 'Failed to load content: %{public}s', JSON.stringify(error));
      }
    });
  }
}
