<div id="netmetr-results">
    %if results:
    <table id="netmetr-results-table">
        <thead>
            <tr>
                <th>{{ trans("Date and Time") }}</th>
                <th>{{ trans("Download [Mb/s]") }}</th>
                <th>{{ trans("Upload [Mb/s]") }}</th>
                <th>{{ trans("Ping [ms]") }}</th>
                <th>{{ trans("Link") }}</th>
            </tr>
        </thead>
        <tbody>
    %for record in results:
            <tr>
                <td>{{ record["time"] }}</td>
                <td>{{ record["speed_download"] }}</td>
                <td>{{ record["speed_upload"] }}</td>
                <td>{{ record["ping"] }}</td>
                <td>
                    <a href="https://www.netmetr.cz/cs/detail.html?{{ record["test_uuid"]}}">{{ trans("Details") }}</a>
                    &nbsp;
                    <a href="https://www.netmetr.cz/cs/detail.html?{{ record["test_uuid"]}}" title="{{ trans("Details in new window") }}" onclick="return !window.open(this.href)">&#x29c9;</a>
                </td>
            </tr>
    %end
        </tbody>
    </table>

    <br>
    <p>{{! trans("For more information you need to enter your syncode <strong>%(sync_code)s</strong> <a href='https://www.netmetr.cz/cs/moje.html'>here</a>.") % dict(sync_code=sync_code) }}</p>
    %else:
    <p>{{ trans("No results found.") }}</p>
    %end
</div>
