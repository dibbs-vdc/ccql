// Added SaveCollectionControl and new SaveCollectionControl($("#form-progress"))
import ThumbnailSelect from 'hyrax/thumbnail_select'
import Participants from 'hyrax/admin/admin_set/participants'
import tabifyForm from 'hyrax/tabbed_form'
import Autocomplete from 'hyrax/autocomplete'
import SaveCollectionControl from 'vdc/save_collection/save_collection_control'

// Controls the behavior of the Collections edit form
// Add search for thumbnail to the edit descriptions
export default class {
  constructor(elem) {
    if($("form[data-behavior='collection-form']").length > 0) {
     let url =  window.location.pathname.replace('edit', 'files')
     let field = elem.find('#collection_thumbnail_id')
     this.thumbnailSelect = new ThumbnailSelect(url, field)
     tabifyForm(elem.find('form.editor'))

      let participants = new Participants(elem.find('#participants'))
      participants.setup()
      this.autocomplete()
      new SaveCollectionControl($("#form-progress"))
    }
  }

  autocomplete() {
    var autocomplete = new Autocomplete()

    $('[data-autocomplete]').each((function() {
      var elem = $(this)
      autocomplete.setup(elem, elem.data('autocomplete'), elem.data('autocompleteUrl'))
    }))

    $('.multi_value.form-group').manage_fields({
      add: function(e, element) {
        var elem = $(element)
        // Don't mark an added element as readonly even if previous element was
        // Enable before initializing, as otherwise LinkedData fields remain disabled
        elem.attr('readonly', false)
        autocomplete.setup(elem, elem.data('autocomplete'), elem.data('autocompleteUrl'))
      }
    })
  }
}
