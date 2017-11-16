<div id="netmetr-results">
%if results:
<table id="netmetr-results-table">
    <thead>
        <tr><th>{{ trans("time") }}</th><th>{{ trans("download") }}</th><th>{{ trans("upload") }}</th><th>{{ trans("ping") }}</th><th>{{ trans("link") }}</th></tr>
    </thead>
    <tbody>
%for record in results:
        <tr><td>{{ record["time"] }}</td><td>{{ record["speed_download"] }}</td><td>{{ record["speed_upload"] }}</td><td>{{ record["ping"] }}</td><td><a href="https://example.com/?sync_code={{ sync_code }}&test_uuid={{ record["test_uuid"]}}">{{ trans("Complete results") }}</a></td></tr>
%end
    </tbody>
</table>
%else:
<p>{{ trans("No results found.") }}</p>
%end
</div>
