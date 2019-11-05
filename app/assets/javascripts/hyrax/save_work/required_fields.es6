export class RequiredFields {
  // Monitors the form and runs the callback if any of the required fields change
  constructor(form, callback) {
    this.form = form
    this.callback = callback
    this.reload()
  }

// what fields havent been filled in that are required. put in array and return back to save_work, and then pass that to the checklist
  get areComplete() {
      // console.log(Object.values(this.requiredFields)); vdc_resource[title]
    Object.values(this.requiredFields).forEach( ele => {
      // console.log(ele)
    })
    return this.requiredFields.filter((n, elem) => { return this.isValuePresent(elem) } ).length === 0
  }

  getEmptyRequiredFields() {
    // get the name and return names of the elem

    $("*.required").filter(":input").each(function(index){
      var arrayOfFields = []
      var label = $(this).siblings().filter("label").text()

      label = label.split(' ').slice(0,-1).join(' ')
      arrayOfFields.push(label)

      console.log(arrayOfFields);

      return arrayOfFields.first()
    // return arrayOfFields.flat()
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
