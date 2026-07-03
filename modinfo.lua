name = "Low Durability Alert"
description = "Alerts you when a tool or worn item has low durability"
author = "joshepen"
version = "1.0"
dst_compatible = true
api_version = 10
client_only_mod = true
all_clients_require_mod = false
local percent_options = {{
        description = "OFF",
        data = 0
    }, {
        description = "5%",
        data = 0.05
    }, {
        description = "10%",
        data = 0.1
    }, {
        description = "15%",
        data = 0.15
    }, {
        description = "20%",
        data = 0.2
    }, {
        description = "25%",
        data = 0.25
    }, {
        description = "30%",
        data = 0.3
    }, {
        description = "35%",
        data = 0.35
    }, {
        description = "40%",
        data = 0.4
    }, {
        description = "45%",
        data = 0.45
    }, {
        description = "50%",
        data = 0.5
    }, {
        description = "55%",
        data = 0.55
    }, {
        description = "60%",
        data = 0.6
    }, {
        description = "65%",
        data = 0.65
    }, {
        description = "70%",
        data = 0.7
    }, {
        description = "75%",
        data = 0.75
    }, {
        description = "80%",
        data = 0.8
    }, {
        description = "85%",
        data = 0.85
    }, {
        description = "90%",
        data = 0.9
    }, {
        description = "95%",
        data = 0.95
    }}
configuration_options = {{
    name = "Threshold",
    hover = "Percent at which to alert you of low durability",
    options = percent_options,
    default = 0.2
}}
