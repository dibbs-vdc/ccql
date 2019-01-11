export class RequiredProject {
  // Monitors the form and runs the callback if any of the required fields change
  constructor(form, callback, validateCallback) {
    this.form = form
    this.callback = callback
    this.validateCallback = validateCallback
    this.reload()
  }

  get areComplete() {
    return this.form.find('#project-body tr:not(.hidden)').length > 0
  }

  // Reassign requiredFields because fields may have been added or removed.
  reload() {
    // ":input" matches all input, select or textarea fields.
    this.requiredCollection = this.form.find('[data-behavior="collection-relationships"]')
    this.collectionTable = this.form.find('[data-behavior="collection-relationships"] tbody')
    this.collectionTable.change(this.callback)

    // Watches for changes to the projects table 
    this.observer = new MutationObserver(mutations => {
      this.validateCallback()
    })
    this.observer.observe(document.getElementById('project-table'), { childList: true, subtree: true, attributes: true, attributeFilter: ['class'] })
  }
}
