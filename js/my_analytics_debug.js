/*
 * Variable Declarations
 */
// References to the debug <td/> els.
var tdVals = {}; // DEBUG

var debugCallbacks = {
    "scrollPercent": function(ms, perc) {
       debugUpdateStr("valScrollDown", perc + "%");
    },
    "read": function(ms, ct, timeToReach) {
        debugUpdateStr("valReadCount", ct);
        debugUpdateSeconds("valTimeToReachBottom", timeToReach);
    },
    "initialIdle": function(ms) {
        debugUpdateSeconds("valInitialIdleTime", ms);
    },
    // timeSpent(ms, activeTime, currentIdleTime, initIdle, longestIdle),
    "timeSpent": function(total, active, curIdle, initIdle, longestIdle) {
        debugUpdateSeconds("valTimeSpent", total);
        debugUpdateSeconds("valActiveTimeSpent", active);
    },
    "idle": function(ms) {
        debugUpdateSeconds("valCurrentIdleTime", ms);
    },
    "longestIdle": function(ms) {
        debugUpdateSeconds("valLongestIdleTime", ms);
    }
}



// DEBUG STUFF
function debugUpdateStr(id, s) {
    var td = tdVals[id];

    if (td != null) {
        td.innerHTML = s;
    }
}

function debugUpdateSeconds(id, ms) {
    debugUpdateStr(id, (ms / 1000) + "s");
}



function constructDebugDiv() {
    var div = document.createElement("div");

    div.id = "diagDiv";
    div.innerHTML = "DIAGNOSTICS<br/>\n";

    var tbl = document.createElement("table");

    function makeRow(id, name, init) {
        var tr = document.createElement("tr");

        var tdk = document.createElement("td");
        tdk.innerHTML = name;

        var tdv = document.createElement("td");
        tdv.id = id
        tdv.innerHTML = init;

        tr.appendChild(tdk);
        tr.appendChild(tdv);

        tbl.appendChild(tr);

        return tr;
    }

    makeRow("valScrollDown", "Scrolled Down:", "0");
    makeRow("valTimeSpent", "Time spent:", "0");
    makeRow("valActiveTimeSpent", "Time spent (active):", "0");
    makeRow("valTimeToReachBottom", "Time spent to reach bottom:", "0");
    makeRow("valReadCount", "Read post count:", "0");
    makeRow("valCurrentIdleTime", "Current Idle Time:", "0");
    makeRow("valLongestIdleTime", "Longest Idle Time:", "0");
    makeRow("valInitialIdleTime", "Initial Idle Time:", "0");

    div.appendChild(tbl);

    document.body.appendChild(div);

    div.style.backgroundColor = "#33aa55";
    div.style.position = "fixed";
    div.style.top = "0px";
    div.style.right = "0px";
    div.style.width = "20%";
    div.style.zIndex = "100";

    return div; // use appendChild on body, or so.
}



function myAnalyticsDebugInit() {
    constructDebugDiv();

    var debugIDs = ["valScrollDown", "valTimeSpent", "valActiveTimeSpent", "valTimeToReachBottom", "valReadCount", "valCurrentIdleTime", "valLongestIdleTime", "valInitialIdleTime"];

    for (var idx in debugIDs) {
        var id = debugIDs[idx];
        tdVals[id] = document.getElementById(id);
    }
}
