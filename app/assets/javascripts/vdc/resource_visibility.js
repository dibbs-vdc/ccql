// TODO: This is really ugly and probably not the place to put this. Look into a
//       structure and place for this. Possibly extend hyrax's
//         app/assets/javascripts/hyrax/admin/admin_set/visibilty.es6
//
// The "formChanged" trigger is watched by the app/assets/javascripts/vdc/save_work_control,
// which is extended from Hyrax's. It might be worth looking into maybe modifying this to be
// es6 as well and making it better structured.
//
// Related: https://groups.google.com/forum/#!topic/samvera-tech/aPejbbxBkFc
// Also, this will need to be reworked and included in other future work types.
// These visibility listeners toggle required/optional fields in the resource form
// as the visibility changes.
function addVisibilityListeners() {
  $( 'body' ).on('click', '#vdc_resource_visibility_restricted', function() {
    usePrivateRequirements();
  });

  $( 'body' ).on('click', '#vdc_resource_visibility_open', function() {
    usePublicRequirements();
  });

  $( '#vdc_resource_visibility_authenticated' ).click( function() {
    usePublicRequirements();
  });

  // TODO: I'm assuming that any embargo ending with an open/public visibility
  //       will need to have all of the required fields for open.
  //       Make sure this is a correct assumption.
  $( '#vdc_resource_visibility_embargo' ).click( function() {
    if ( $( '#vdc_resource_visibility_after_embargo' ).val() === 'open' ) {
      usePublicRequirements();
    }
  });

  // TODO: I'm assuming that any embargo ending with an open/public visibility
  //       will need to have all of the required fields for open.
  //       Make sure this is a correct assumption.
  $( '#vdc_resource_visibility_after_embargo' ).change( function() {
    if ( $( '#vdc_resource_visibility_after_embargo' ).val() === 'restricted' ) {
      usePrivateRequirements();
    } else {
      usePublicRequirements();
    }
  });

  // TODO: I'm assuming that any lease starting with an open/public visibility
  //       will need to have all of the required fields for open.
  //       Make sure this is a correct assumption.
  $( '#vdc_resource_visibility_lease' ).click( function() {
    if ( $( '#vdc_resource_visibility_during_lease' ).val() === 'restricted' ) {
      usePrivateRequirements();
    } else {
      usePublicRequirements();
    }
  });

  // TODO: I'm assuming that any lease starting with an open/public visibility
  //       will need to have all of the required fields for open.
  //       Make sure this is a correct assumption.
  $( '#vdc_resource_visibility_during_lease' ).change( function() {
    if ( $( '#vdc_resource_visibility_during_lease' ).val() === 'restricted' ) {
      usePrivateRequirements();
    } else {
      usePublicRequirements();
    }
  });
}

function usePrivateRequirements() {
  makeResourceElementOptionalFromRequired('text', 'vdc_resource_abstract');
}

function usePublicRequirements() {
  makeResourceElementRequiredFromOptional('text', 'vdc_resource_abstract');
}

// Moves the form group associated with the type and id provided
// from the required base-terms section to the optional
// extended-terms section.
// If the type and id provided don't exist in a form group that
// is optional, then nothing happens.
function makeResourceElementOptionalFromRequired(type, id) {
  var classNameStr = '.form-group.'+type+'.required.'+id;
  if (($( '#extended-terms' ) != null) && ($( classNameStr ).length > 0)) {
    $( classNameStr ).each( function() {
      // TODO: Maybe a better way to do this is not prepend the whole thing, but to keep the
      //       outer form group in the base terms, create a new form group in the
      //       extended terms, and move the children back and forth. This way, it might
      //       preserve the ordering of the fields for consistency to the user?
      $( '#extended-terms' ).prepend( this );
      var label = $( "label[for='"+id+"']" );
      label.removeClass( 'required' ).addClass( 'optional' );
      label.find("span").remove(); //TODO: Is there a better way to remove the "required" span?
      $( this ).removeClass( 'required' ).addClass( 'optional' );
    });
    $( '#'+id ).removeClass( 'required' ).addClass( 'optional' );
    $( '#'+id ).removeAttr('required');
    $( '#'+id ).removeAttr('aria-required'); // TODO: What is Aria? Is there a better way to do this?
    $( document ).trigger('formChanged');
  }
}

// Moves the form group associated with the type and id provided
// from the extended-terms section to the base-terms section
// If the type and id provided don't exist in a form group that
// is optional, then nothing happens.
function makeResourceElementRequiredFromOptional(type, id) {
  var classNameStr = '.form-group.'+type+'.optional.'+id;
  if ( ( $( '.base-terms' ).length > 0 ) && ( $( classNameStr ).length > 0 ) ) {
    $( classNameStr ).each( function() {
      // NOTE: I shouldn't get more than one 'base-term' element.
      //       I hope this isn't a bad assumption.
      $( '.base-terms' ).first().append( this );
      var label = $( "label[for='"+id+"']" );
      label.removeClass( 'optional' ).addClass( 'required' );
      label.find("span").remove(); //TODO: Is there a better way to remove the "required" span?
      var spaceSpan = $( '<span />' ).html( '&nbsp;' );
      var requiredSpan = $( '<span />' ).addClass( 'label' ).addClass( 'label-info' ).addClass( 'required-tag' ).html( 'required' );
      label.append( spaceSpan ).append( requiredSpan );
      $( this ).removeClass( 'optional' ).addClass( 'required' );
    });
    $( '#'+id ).removeClass( 'optional' ).addClass( 'required' );
    $( '#'+id ).attr('required', 'required');
    $( '#'+id ).attr('aria-required', 'true');
    $( document ).trigger('formChanged');
  }
}
