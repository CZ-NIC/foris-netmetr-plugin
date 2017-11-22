# Foris netmetr plugin
# Copyright (C) 2017 CZ.NIC, z. s. p. o. <https://www.nic.cz>
#
# Foris is distributed under the terms of GNU General Public License v3.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

import bottle
import os

from datetime import datetime

from foris import fapi
from foris.config import ConfigPageMixin, add_config_page
from foris.config_handlers import BaseConfigHandler
from foris.form import Checkbox
from foris.plugins import ForisPlugin
from foris.state import current_state
from foris.utils import messages, reverse
from foris.utils.translators import gettext_dummy as gettext, ugettext as _


class NetmetrPluginConfigHandler(BaseConfigHandler):
    userfriendly_title = gettext("netmetr")

    def get_form(self):
        data = current_state.backend.perform("netmetr", "get_settings", {})
        # init hours
        for i in range(24):
            data["hour_to_run_%d" % i] = False
        # update the enabled
        for e in data["hours_to_run"]:
            data["hour_to_run_%d" % e] = True

        if self.data:
            # Update from post
            data.update(self.data)

        form = fapi.ForisForm("netmetr", data)
        main = form.add_section(name="set_netmetr", title=_(self.userfriendly_title))
        autostart_section = main.add_section(name="autostart", title=_("Autostart"))
        autostart_section.add_field(
            Checkbox, name="autostart_enabled", label=_("Autostart enabled"),
            preproc=lambda val: bool(int(val)), hint=_("TBD")
        )
        hours = main.add_section(name="hours", title=_("Autostart times"))
        for i in range(24):
            hours.add_field(
                Checkbox, name="hour_to_run_%d" % i, label="%02d:00" % i,
                preproc=lambda val: bool(int(val)),
            ).requires("autostart_enabled", True)

        def form_cb(data):
            msg = {"autostart_enabled": data["autostart_enabled"]}
            if data["autostart_enabled"]:
                msg["hours_to_run"] = []
                for i in range(24):
                    name = "hour_to_run_%d" % i
                    if name in data and data[name]:
                        msg["hours_to_run"].append(i)
            current_state.backend.perform("netmetr", "update_settings", msg)
            messages.success(_("Netmeter settings were updated."))
            return "none", None

        form.add_callback(form_cb)

        return form


class NetmetrPluginPage(ConfigPageMixin, NetmetrPluginConfigHandler):
    menu_order = 80
    template = "netmetr/netmetr_plugin.tpl"
    userfriendly_title = gettext("Netmetr")

    def save(self, *args, **kwargs):
        kwargs['no_messages'] = True  # disable default messages
        return super(NetmetrPluginPage, self).save(*args, **kwargs)

    def _prepare_results(self, results):
        results.sort(key=lambda x: x["time"], reverse=True)
        for record in results:
            record["time"] = datetime.fromtimestamp(record["time"]).strftime("%Y-%m-%d %H:%M:%S")
        return results

    def _prepare_render_args(self, args):
        args['PLUGIN_NAME'] = NetmetrPlugin.PLUGIN_NAME
        args['PLUGIN_STYLES'] = NetmetrPlugin.PLUGIN_STYLES
        args['PLUGIN_STATIC_SCRIPTS'] = NetmetrPlugin.PLUGIN_STATIC_SCRIPTS
        args['PLUGIN_DYNAMIC_SCRIPTS'] = NetmetrPlugin.PLUGIN_DYNAMIC_SCRIPTS
        obtained = current_state.backend.perform("netmetr", "get_data")
        args["status"] = obtained["status"]
        args["results"] = self._prepare_results(obtained["performed_tests"])

    def render(self, **kwargs):
        self._prepare_render_args(kwargs)
        return super(NetmetrPluginPage, self).render(**kwargs)

    def call_ajax_action(self, action):
        if action == "redownload":
            bottle.response.set_header("Content-Type", "application/json")
            return current_state.backend.perform("netmetr", "download_data", {})
        elif action == "start":
            bottle.response.set_header("Content-Type", "application/json")
            return current_state.backend.perform("netmetr", "measure_and_download_data", {})
        elif action == "get_data":
            bottle.response.set_header("Content-Type", "text/html")
            data = current_state.backend.perform("netmetr", "get_data", {})
            sync_code = current_state.backend.perform("netmetr", "get_settings", {})["sync_code"]
            return bottle.template(
                "netmetr/_results",
                results=self._prepare_results(data["performed_tests"]),
                sync_code=sync_code,
            )

        raise ValueError("Unknown AJAX action.")

    def _action_download_data(self):
        current_state.backend.perform("netmetr", "download_data", {})
        bottle.redirect(reverse("config_page", page_name="netmetr_plugin"))

    def _action_measure_and_download_data(self):
        current_state.backend.perform("netmetr", "measure_and_download_data", {})
        bottle.redirect(reverse("config_page", page_name="netmetr_plugin"))

    def call_action(self, action):
        if bottle.request.method != 'POST':
            messages.error("Wrong HTTP method.")
            bottle.redirect(reverse("config_page", page_name="netmetr_plugin"))

        if action == "redownload":
            self._action_download_data()
        elif action == "start":
            self._action_measure_and_download_data()

        raise bottle.HTTPError(404, "Unknown action.")


class NetmetrPlugin(ForisPlugin):
    PLUGIN_NAME = "netmetr"
    DIRNAME = os.path.dirname(os.path.abspath(__file__))

    PLUGIN_STYLES = [
        "css/netmetr_plugin.css"
    ]
    PLUGIN_STATIC_SCRIPTS = [
    ]
    PLUGIN_DYNAMIC_SCRIPTS = [
        "netmetr_plugin.js"
    ]

    def __init__(self, app):
        super(NetmetrPlugin, self).__init__(app)
        add_config_page("netmetr_plugin", NetmetrPluginPage, top_level=True)
