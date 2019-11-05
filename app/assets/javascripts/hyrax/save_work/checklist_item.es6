export class ChecklistItem {
  constructor(element, emptyRequiredFields) {
    this.element = element
    this.emptyRequiredFields = emptyRequiredFields
  }

  check() {
    this.element.removeClass('incomplete')
    this.element.addClass('complete')
  }

  uncheck(emptyRequiredFields) {
    this.element.removeClass('complete')
    this.element.addClass('incomplete')
    this.element.append(this.emptyRequiredFields)
    // loop emptyRequiredFields
  }
}
