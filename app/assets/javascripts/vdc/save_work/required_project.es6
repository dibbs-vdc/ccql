export class RequiredProject {
  constructor(form, callback) {
    this.form = form
    this.callback = callback
    this.reload()
  }

  get areComplete() {
    return this.form.find('#project-body tr:not(.hidden)').length > 0
  }

  reload() {
    // ":input" matches all input, select or textarea fields.
    this.requiredCollection = this.form.find('[data-behavior="collection-relationships"]')
    this.collectionTable = this.form.find('[data-behavior="collection-relationships"] tbody')
    this.collectionTable.change(this.callback)

    // Watches for changes to the projects table
    this.observer = new MutationObserver(mutations => {
      this.callback()
    })
    this.observer.observe(document.getElementById('project-table'), { childList: true, subtree: true, attributes: true, attributeFilter: ['class'] })
  }
}
