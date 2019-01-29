export default class Default {
  constructor(element, url) {
    this.url = url;
    if (this.url !== undefined)
      element.autocomplete(this.options(element))
  }

  options(element) {
    return {
      minLength: 0,

      source: (request, response) => {
        $.getJSON(this.url, {
          q: request.term
        }, response );
      },

      focus: function() {
        // prevent value inserted on focus
        return false;
      },

      complete: function(event) {
        $('.ui-autocomplete-loading').removeClass("ui-autocomplete-loading");
      },

      select: function() {
        if (element.data('autocomplete-read-only') === true) {
          element.attr('readonly', true);
        }
      }
    }
  }
}