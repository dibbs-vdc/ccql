import { RequiredFields } from 'hyrax/save_work/required_fields'
import { ChecklistItem } from 'hyrax/save_work/checklist_item'

export default class SaveCollectionControl {

  constructor(element) {
    if (element.length < 1) {
      return
    }
    this.element = element
    console.log(element);
    this.form = element.closest('form')
    element.data('save_collection_control', this)
    this.activate();
  }

  /**
   * Keep the form from submitting (if the return key is pressed)
   * unless the form is valid.
   *
   * This seems to occur when focus is on one of the visibility buttons
   */
  preventSubmitUnlessValid() {
    this.form.on('submit', (evt) => {
      if (!this.isValid())
        evt.preventDefault();
    })
  }

  /**
   * Keep the form from being submitted many times.
   *
   */
  preventSubmitIfAlreadyInProgress() {
    this.form.on('submit', (evt) => {
      if (this.isValid())
        this.saveButton.prop("disabled", true);
    })
  }

  /**
   * Is the form for a new object (vs edit an existing object)
   */
  get isNew() {
    return this.form.attr('id').startsWith('new')
  }

  activate() {
    if (!this.form) {
      return
    }
    this.requiredFields = new RequiredFields(this.form, () => this.formStateChanged())
    this.saveButton = this.element.find(':submit')
    this.requiredTitle = new ChecklistItem(this.element.find('#collection_title'))
    this.requiredDepositor = new ChecklistItem(this.element.find('#collection_depositor'))
    this.requiredSize = new ChecklistItem(this.element.find('#collection_size'))
    this.preventSubmit()
    this.watchMultivaluedFields()
    this.formChanged()
    this.watchForFormChanged();
  }

  preventSubmit() {
    this.preventSubmitUnlessValid()
    this.preventSubmitIfAlreadyInProgress()
  }

  watchMultivaluedFields() {
    $('.multi_value.form-group', this.form).bind('managed_field:add', () => this.formChanged())
    $('.multi_value.form-group', this.form).bind('managed_field:remove', () => this.formChanged())
  }

  formChanged() {
    this.formStateChanged();
  }

  formStateChanged() {
    this.saveButton.prop("disabled", !this.isSaveButtonEnabled);
  }

  // Indicates whether the "Save" button should be enabled: a valid form and no uploads in progress
  get isSaveButtonEnabled() {
    return this.isValid()
  }

  isValid() {
    let requiredTitle = this.validateTitle()
    let requiredDepositor = this.validateDepositor()
    let requiredSize = this.validateSize()
    return requiredTitle && requiredDepositor && requiredSize
  }

  checkStatus(id) {
    let element = this.form.find(id)
    return ($(element).val() === null) || ($(element).val().length < 1)
  }

  validateTitle() {
    if (!this.checkStatus('#collection_title')) {
      this.requiredTitle.check()
      return true
    }
    this.requiredTitle.uncheck()
    return false
  }

  validateDepositor() {
    if (!this.checkStatus('#collection_vdc_creator')) {
      this.requiredDepositor.check()
      return true
    }
    this.requiredDepositor.uncheck()
    return false
  }

  validateSize() {
    if (!this.checkStatus('#collection_collection_size')) {
      this.requiredSize.check()
      return true
    }
    this.requiredSize.uncheck()
    return false
  }

  // If someone changes the visibility, updated required fields and fire a formChanged event.
  watchForFormChanged() {
    $( document ).on('formChanged', () => this.formChanged())
  }
}
