import editor from 'hyrax/editor'
import VdcSaveWorkControl from 'vdc/save_work/save_work_control'

export default class extends editor {
  saveWorkControl() {
      new VdcSaveWorkControl(this.element.find("#form-progress"), this.adminSetWidget)
  }
}
