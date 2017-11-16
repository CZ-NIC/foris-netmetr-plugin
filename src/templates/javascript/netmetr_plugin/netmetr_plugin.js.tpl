Foris.watched_process = null;
Foris.update_data = function() {
  $.get('{{ url("config_ajax", page_name="netmetr_plugin") }}', {action: "get_data"})
    .done(function(response, status, xhr) {
      if (xhr.status == 200) {
        $("#netmetr-results").replaceWith(response);  // replace the table
        $("#start-trigger").show()
        $("#redownload-trigger").show()
      }
    })
    .fail(function(xhr) {
      if (xhr.responseJSON && xhr.responseJSON.loggedOut && xhr.responseJSON.loginUrl) {
        window.location.replace(xhr.responseJSON.loginUrl);
        return;
      }
    });
};
Foris.WS["netmetr"] = function(msg) {
    if (msg.data.async_id != Foris.watched_process) {
        return;
    }
    switch(msg["action"]) {
      case "download_data_finished":
        if (msg.data.passed) {
            $("#netmetr-control-status").text('{{ trans("Downloading...OK")}}');
            Foris.update_data();
        } else {
            $("#netmetr-control-status").text('{{ trans("Downloading...FAILED")}}');
        }
        break;
      case "measure_and_download_data_finished":
        if (msg.data.passed) {
            $("#netmetr-control-status").text('{{ trans("Testing...OK")}}');
            $("#netmetr-control-progress").text('');
            Foris.update_data();
        } else {
            $("#netmetr-control-status").text('{{ trans("Testing...FAILED")}}');
        }
        break;
      case "measure_and_download_data_notification":
        $("#netmetr-control-progress").text(msg.data.percent.toString() + "% " + msg.data.msg);
        break;
    }
};

$(document).ready(function() {
  $("#redownload-trigger").click(function(e) {
    e.preventDefault();
    $.get('{{ url("config_ajax", page_name="netmetr_plugin") }}', {action: "redownload"})
      .done(function(response) {
        Foris.watched_process = response["async_id"];
        $("#start-trigger").hide()
        $("#redownload-trigger").hide()
        $("#netmetr-control-status").text('{{ trans("Downloading...")}}');
      });
  });
  $("#start-trigger").click(function(e) {
    e.preventDefault();
    $.get('{{ url("config_ajax", page_name="netmetr_plugin") }}', {action: "start"})
      .done(function(response) {
        Foris.watched_process = response["async_id"];
        $("#start-trigger").hide()
        $("#redownload-trigger").hide()
        $("#netmetr-control-status").text('{{ trans("Testing...")}}');
        $("#netmetr-control-progress").text("0%");
      });
  });
});

