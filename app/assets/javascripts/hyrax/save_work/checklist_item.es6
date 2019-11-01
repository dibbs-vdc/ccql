export class ChecklistItem {
  constructor(element, requiredFields) {
    this.element = element
    this.requiredFields = requiredFields
  }

  check() {
    this.element.removeClass('incomplete')
    this.element.addClass('complete')
  }

  uncheck() {
    this.element.removeClass('complete')
    this.element.addClass('incomplete')
    this.element.append(this.requiredFields)
  }
}
