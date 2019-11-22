import SaveWorkControl from 'hyrax/save_work/save_work_control'

export default class VdcSaveWorkControl extends SaveWorkControl {
  activate() {
    super.activate();
    this.watchForFormChanged();
  }

  // If someone changes the visibility, updated required fields and fire a formChanged event.
  watchForFormChanged() {
    $( document ).on('formChanged', () => this.formChanged())
  }
}
