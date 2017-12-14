<%
  if lang() == "cs":
    my_url = "https://www.netmetr.cz/cs/moje.html"
    detail_url = "https://www.netmetr.cz/cs/detail.html"
  else:
    my_url = "https://www.netmetr.cz/en/my.html"
    detail_url = "https://www.netmetr.cz/en/detail.html"
  end
%>

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
                    <a href="{{ "%s?%s" % (detail_url, record["test_uuid"]) }}">{{ trans("Details") }}</a>
                    &nbsp;
                    <a href="{{ "%s?%s" % (detail_url, record["test_uuid"]) }}" title="{{ trans("Details in new window") }}" onclick="return !window.open(this.href)">&#x29c9;</a>
                </td>
            </tr>
    %end
        </tbody>
    </table>

    <br>
    <p>{{! trans("For more information you need to enter your syncode <strong>%(sync_code)s</strong> <a href='%(url)s'>here</a>.") % dict(sync_code=sync_code, url=my_url) }}</p>
    %else:
    <p>{{ trans("No results found.") }}</p>
    %end
</div>
