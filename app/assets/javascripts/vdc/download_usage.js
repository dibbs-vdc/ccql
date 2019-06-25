Blacklight.onLoad(function() {
  $('body').on('click', '.file_download_usage', function(e){
    e.preventDefault()
    var workId = $(this).data('workId')
    var userId = $(this).data('userId')
    var href = this.href
    
    $('#downloadUsageModal #vdc_usage_user_id').val(userId);
    $('#downloadUsageModal #vdc_usage_work_id').val(workId);
    $('#downloadUsageModal #vdc_usage_href').val(href);
    $('#downloadUsageModal').modal('show'); 
  })
})