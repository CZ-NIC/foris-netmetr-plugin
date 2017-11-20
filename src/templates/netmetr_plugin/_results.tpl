<div id="netmetr-results">
%if results:
<table id="netmetr-results-table">
    <thead>
        <tr><th>{{ trans("time") }}</th><th>{{ trans("download") }}</th><th>{{ trans("upload") }}</th><th>{{ trans("ping") }}</th><th>{{ trans("link") }}</th></tr>
    </thead>
    <tbody>
%for record in results:
        <tr><td>{{ record["time"] }}</td><td>{{ record["speed_download"] }}</td><td>{{ record["speed_upload"] }}</td><td>{{ record["ping"] }}</td><td><a href="https://www.netmetr.cz/cs/detail.html?{{ record["test_uuid"]}}">{{ trans("Details") }}</a></td></tr>
%end
    </tbody>
</table>
<br />
<p>{{! trans("For more information you need to enter your syncode <strong>%(sync_code)s</strong> <a href='https://www.netmetr.cz/cs/moje.html'>here</a>.") % dict(sync_code=sync_code) }}</p>
%else:
<p>{{ trans("No results found.") }}</p>
%end
</div>
