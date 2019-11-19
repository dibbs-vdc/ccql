// Hyrax 2.5 override to add front end validations for individual metadata fields. Added methods: getEmptyRequiredField, getEmptyRequiredFields
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

  getEmptyRequiredField() {
    var arrayOfFields = [];
    const that = this
    $("*.required").filter(":input").each(function(index){
      let value = $(this).val()
      console.log(that.isValuePresent(this));
      var label = $(this).siblings().filter("label").text()
      label = label.split(' ').slice(0,-1).join(' ')
      arrayOfFields.push([label, value])
    })
    return arrayOfFields;
  }

  getEmptyRequiredFields(fieldIDs) {
    var arrayOfFields = [];
    arrayOfFields.forEach(id => {
      let query = $(`#${id}`).filter(vdc_resource_)
    })
  }


  isValuePresent(elem) {
    return ($(elem).val() === null) || ($(elem).val().length < 1)
  }


  reload() {
    this.requiredFields = this.form.find(':input[required]')
    this.requiredFields.change(this.callback)
  }
}
