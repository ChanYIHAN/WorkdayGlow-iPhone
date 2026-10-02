import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { vocabularySeed } from '../model/VocabularySeed';
import { Want } from '@kit.AbilityKit';

export default class WidgetFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    const word = vocabularySeed[Math.floor(Date.now() / 86400000) % vocabularySeed.length];
    return formBindingData.createFormBindingData({
      word: word.word, meaning: word.meaning, example: word.example,
      title: '今日活力',
      steps: '6,842',
      distance: '4.8 km',
      energy: '386 千卡',
      progress: 72
    });
  }

  onUpdateForm(formId: string): void {
    const word = vocabularySeed[Math.floor(Date.now() / 86400000) % vocabularySeed.length];
    const data = formBindingData.createFormBindingData({ updatedAt: Date.now(), word: word.word, meaning: word.meaning, example: word.example });
    formProvider.updateForm(formId, data).catch(() => { });
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
