
%rebase("config/base.tpl", **locals())

<div id="page-netmetr-plugin" class="config-page">
%include("_messages.tpl")

<form action="{{ request.fullpath }}" class="config-form" method="post" id="netmetr-main-form">
    <input type="hidden" name="csrf_token" value="{{ get_csrf_token() }}">
    <h3>{{ form.sections[0].sections[0].title }}</h3>
    %for field in form.sections[0].sections[0].active_fields:
        %include("_field.tpl", field=field)
    %end
    %if form.active_fields[0].field.get_value():
    <br />
    <h5>{{ form.sections[0].sections[1].title }}</h5>
    %end
    <div class="row">
    %for field in form.sections[0].sections[1].active_fields:
        <div class="netmetr-time-box">
        {{! field.label_tag }}
        <br />
        {{! field.render() }}
        </div>
    %end
    </div>
    <br />
    <div class="form-buttons">
    <button type="submit" name="send" class="button">{{ trans("Save") }}</button>
    </div>
</form>
<h3>{{ trans("Controls") }}</h3>
<p id="netmetr-control-status"></p>
<p id="netmetr-control-progress"></p>
<form action="{{ url("config_action", page_name="netmetr_plugin", action="perform") }}" class="config-form" id="netmetr-controls" method="post">
    <input type="hidden" name="csrf_token" value="{{ get_csrf_token() }}">
    <button type="submit" name="action" id="redownload-trigger" value="redownload" class="button">{{ trans("Redownload data") }}</button>
    <button type="submit" name="action" id="start-trigger" value="start" class="button">{{ trans("Start test") }}</button>
</form>
<h3>{{ trans("Results") }}</h3>
%include("netmetr_plugin/_results.tpl", results=results, sync_code=form._request_data["sync_code"])
</div>
