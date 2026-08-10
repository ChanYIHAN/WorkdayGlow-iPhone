import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';

export default class WidgetFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    return formBindingData.createFormBindingData({
      title: '今日活力',
      steps: '6,842',
      distance: '4.8 km',
      energy: '386 千卡',
      progress: 72
    });
  }

  onUpdateForm(formId: string): void {
    const data = formBindingData.createFormBindingData({ updatedAt: Date.now() });
    this.context.updateForm(formId, data);
  }

  onFormEvent(formId: string, message: string): void {
    if (message === 'refresh') {
      this.onUpdateForm(formId);
    }
  }

  onRemoveForm(formId: string): void {}
  onAcquireFormState(want: Want): formInfo.FormState {
    return formInfo.FormState.READY;
  }
}
