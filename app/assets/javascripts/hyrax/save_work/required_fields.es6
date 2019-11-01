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

// if theres a value. try to return name
  isValuePresent(elem) {
    // get the name and return names of the elem

    $("*.required").filter(":input").each(function(index){
     let label = $(this).siblings().filter("label").text() //select the text from the label for this form element
     label = label.split(' ').slice(0,-1).join(' ')
     //console.log(label+": "+$(this).val())
     //console.log(label);
   })


    var fieldNames = elem.name
    // console.log(fieldNames) returns field labels ex vdc_resource_title;
    // create second method to get value present of field
    return ($(elem).val() === null) || ($(elem).val().length < 1) // add into array
  }

  // Reassign requiredFields because fields may have been added or removed.
  reload() {
    // ":input" matches all input, select or textarea fields.
    this.requiredFields = this.form.find(':input[required]')
    // get the element and extract the name vdc_resource['field']
    // TODO what is the find return
    this.requiredFields.change(this.callback)
  }
}
