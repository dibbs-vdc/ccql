// Hyrax 2.5 override to add front end validations for individual metadata fields. Added methods: getVDCFields, initializeVDCFields, validateVDCFields.
import { RequiredFields } from './required_fields'
import { RequiredProject } from 'vdc/save_work/required_project'
import { ChecklistItem } from './checklist_item'
import { UploadedFiles } from './uploaded_files'
import { DepositAgreement } from './deposit_agreement'
import VisibilityComponent from './visibility_component'

/**
 * Polyfill String.prototype.startsWith()
 */
if (!String.prototype.startsWith) {
    String.prototype.startsWith = function(searchString, position){
      position = position || 0;
      return this.substr(position, searchString.length) === searchString;
  };
}

export default class SaveWorkControl {
  /**
   * Initialize the save controls
   * @param {jQuery} element the jquery selector for the save panel
   * @param {AdminSetWidget} adminSetWidget the control for the adminSet dropdown
   */
  constructor(element, adminSetWidget) {
    if (element.length < 1) {
      return
    }
    this.element = element
    this.adminSetWidget = adminSetWidget
    this.form = element.closest('form')
    element.data('save_work_control', this)
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
   * Keep the form from being submitted while uploads are running
   *
   */
  preventSubmitIfUploading() {
    this.form.on('submit', (evt) => {
      if (this.uploads.inProgress) {
        evt.preventDefault()
      }
    })
  }

  /**
   * Is the form for a new object (vs edit an existing object)
   */
  get isNew() {
    return this.form.attr('id').startsWith('new')
  }

  /*
   * Call this when the form has been rendered
   */
  activate() {
    if (!this.form) {
      return
    }

    this.requiredFields = new RequiredFields(this.form, () => this.formStateChanged())
    this.requiredProject = new RequiredProject(this.form, () => this.formStateChanged())
    this.uploads = new UploadedFiles(this.form, () => this.formStateChanged())
    this.saveButton = this.element.find(':submit')
    this.depositAgreement = new DepositAgreement(this.form, () => this.formStateChanged())
    this.requiredMetadata = new ChecklistItem(this.element.find('#required-metadata'))
    this.requiredCollection = new ChecklistItem(this.element.find('#required-project'))
    this.requiredFiles = new ChecklistItem(this.element.find('#required-files'))
    this.requiredAgreement = new ChecklistItem(this.element.find('#required-agreement'))
    new VisibilityComponent(this.element.find('.visibility'), this.adminSetWidget)
    this.preventSubmit()
    this.watchMultivaluedFields()
    this.formChanged()
    this.addFileUploadEventListeners();
  }

  addFileUploadEventListeners() {
    let $uploadsEl = this.uploads.element;
    const $cancelBtn = this.uploads.form.find('#file-upload-cancel-btn');

    $uploadsEl.bind('fileuploadstart', () => {
      $cancelBtn.removeClass('hidden');
    });

    $uploadsEl.bind('fileuploadstop', () => {
      $cancelBtn.addClass('hidden');
    });
  }

  preventSubmit() {
    this.preventSubmitUnlessValid()
    this.preventSubmitIfAlreadyInProgress()
    this.preventSubmitIfUploading()
  }

  // If someone adds or removes a field on a multivalue input, fire a formChanged event.
  watchMultivaluedFields() {
      $('.multi_value.form-group', this.form).bind('managed_field:add', () => this.formChanged())
      $('.multi_value.form-group', this.form).bind('managed_field:remove', () => this.formChanged())
  }

  // Called when a file has been uploaded, the deposit agreement is clicked or a form field has had text entered.
  formStateChanged() {
    this.saveButton.prop("disabled", !this.isSaveButtonEnabled);
  }

  // called when a new field has been added to the form.
  formChanged() {
    this.requiredFields.reload();
    this.requiredProject.reload();
    this.formStateChanged();
  }

  // Indicates whether the "Save" button should be enabled: a valid form and no uploads in progress
  get isSaveButtonEnabled() {
    return this.isValid() && !this.uploads.inProgress;
  }

  isValid() {
    // avoid short circuit evaluation. The checkboxes should be independent.
    this.initializeVDCFields()
    let metadataValid = this.validateMetadata()
    let VDCFieldsValid = this.validateVDCFields()
    let collectionValid = this.validateCollection()
    let filesValid = this.validateFiles()
    let agreementValid = this.validateAgreement(filesValid)
    return metadataValid && VDCFieldsValid && filesValid && agreementValid && collectionValid
  }

  // sets the metadata indicator to complete/incomplete
  validateMetadata() {
    if (this.requiredFields.areComplete) {
      this.requiredMetadata.check()
      return true
    }
    this.requiredMetadata.uncheck()
    return false
  }

  getVDCFields() { // return fields as objects. returns unique ID's
    let arr = []
    let labels = []
    $("*.required").filter(":input").each(function(index) {
      let normalLabel = $(this).siblings().filter("label").text() //select the text from the label for this form element
      let depositorLabel = $(this).parent().parent().siblings().filter('label').text() // gets the label if it's a depositor
      let label = (normalLabel || depositorLabel).match(/.+(?=required)/)[0].trim() // strips out the 'required' and white space
      let value = $(this).val()
      let isValuePresent = ($(this).val() === null) || ($(this).val().length < 1)
      let id = $(this)[0].id.split('_').slice(1).join('_')
      if(!labels.includes(label)){
        labels.push(label)
        let formItem = {
          element: $(this),
          label: label,
          value: value,
          isValuePresent: isValuePresent,
          id: id
        }
        arr.push(formItem)
      }
    })
    return arr; // return array as objects
  }

  initializeVDCFields() { // creates the li's
    const that = this
    $('#metadata-data').html('') // clears previous items
    let fields = this.getVDCFields()
    fields.forEach(field => {
      $(`<li class='incomplete' style="list-style: none;" id=${field.id}>${field.label}</li>`).appendTo($('#metadata-data'))
      field.checklistItem = new ChecklistItem(that.element.find(`#${field.id}`))
    })
  }

  validateVDCFields() { // find the element and check/uncheck based on t/f
    let allFilled = true
    const fields = this.getVDCFields()
    fields.forEach(field => {
      let checklistItem = $(`#${field.id}`)
      if(field.isValuePresent) {
        checklistItem.removeClass('complete')
        checklistItem.addClass('incomplete')
        allFilled = false
      }
      else {
        checklistItem.removeClass('incomplete')
        checklistItem.addClass('complete')
      }
    })
    return allFilled
  }

  // sets the collection indicator to complete/incomplete
  validateCollection() {
    if (this.requiredProject.areComplete) {
      this.requiredCollection.check()
      return true
    }
    this.requiredCollection.uncheck()
    return false
  }

  // sets the files indicator to complete/incomplete
  validateFiles() {
    if (!this.uploads.hasFileRequirement) {
      return true
    }
    if (!this.isNew || this.uploads.hasFiles) {
      this.requiredFiles.check()
      return true
    }
    this.requiredFiles.uncheck()
    return false
  }

  validateAgreement(filesValid) {
    if (filesValid && this.uploads.hasNewFiles && this.depositAgreement.mustAgreeAgain) {
      // Force the user to agree again
      this.depositAgreement.setNotAccepted()
      this.requiredAgreement.uncheck()
      return false
    }
    if (!this.depositAgreement.isAccepted) {
      this.requiredAgreement.uncheck()
      return false
    }
    this.requiredAgreement.check()
    return true
  }
}
