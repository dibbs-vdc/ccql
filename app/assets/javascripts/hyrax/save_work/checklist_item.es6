export class ChecklistItem {
  constructor(element) {
    this.element = element
  }

  check() {
    this.element.removeClass('incomplete')
    this.element.addClass('complete')
  }

  uncheck(emptyRequiredFields) {
    this.element.removeClass('complete')
    this.element.addClass('incomplete')
    // this.element.append(emptyRequiredFields)
    //$(this.element.append(emptyRequiredFields));
    // emptyRequiredFields.forEach(function(elem) {
    //   //(this.element.append(elem).after("<br/>"))
   // call actual ID's from the li's in form_progress
    // })
    // loop emptyRequiredFields
  }
}
