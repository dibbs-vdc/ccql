export class RequiredFields {
  // Monitors the form and runs the callback if any of the required fields change
  constructor(form, callback) {
    this.form = form
    this.callback = callback
    this.reload()
  }

  get areComplete() {
    return this.requiredFields.filter((n, elem) => { return this.isValuePresent(elem) } ).length === 0
  }

  // @todo - this is returning all of the required fields
  //   it should return only those that are empty
  getEmptyRequiredFields() { // get the actual empty fields, not just required fields. 
    var arrayOfFields = [];
    $("*.required").filter(":input").each(function(index){
      var label = $(this).siblings().filter("label").text()
      label = label.split(' ').slice(0,-1).join(' ')
      arrayOfFields.push(label)
    })
    return arrayOfFields;
  }

  isValuePresent(elem) {
    return ($(elem).val() === null) || ($(elem).val().length < 1)
  }


  reload() {
    this.requiredFields = this.form.find(':input[required]')
    this.requiredFields.change(this.callback)
  }
}
