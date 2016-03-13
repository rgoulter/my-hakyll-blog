// My analytics.
// May not the greatest JavaScript, but this isn't the greatest blog.
//
// Also doesn't support < IE9, oh well.

// XXX There're various off-by-1 bugs RE: active-time/idle-time. Oh well.

// Suggestion on how to avoid the smurfing here:
// https://addyosmani.com/blog/essential-js-namespacing/

/*
 * Variable Declarations
 */
// Main Content element, where the blogpost text is.
// In terms of "what they read", I care about this.
var postContentId = "content";
var myAnalyticsContentEl = null;


var myAnalyticsTimeSpent       = 0; // in milliseconds
var myAnalyticsActiveTimeSpent = 0; // in milliseconds


// for timing, just frequently tally some var every 15-30s.
var myAnalyticsTimingPrecision = 15 * 1000; // in milliseconds


// 'Stateful' vars

var prevWindowY = -1;   // for keeping track of 'idle', i.e. not scrolled.
var timeAtWindowY = 0;  // 0 => not idle
var longestIdleTime = 0;

var pageLoadTimestamp  = -1; // ms
var latestTimeAtTop    = -1; // ms
var latestTimeAtBottom = -1; // ms
var readCount = 0;

var contentScrolledPercentage = 0; // percentage
var latestScrollCall = 0; // so we don't invoke CB too often
var timeToReachBottom = -1;

var initialIdleTime = null;
var timeSpentToReachBottom = 0;

var myAnalyticsCallbacks = {};



function myAnalyticsInit(callbacks, timingPrecision) {
    myAnalyticsContentEl = document.getElementById(postContentId);

    pageLoadTimestamp = Date.now();

    // read(ct, timeToReach),
    // initialIdle(ms),
    // timeSpent(ms, activeTime, currentIdleTime, initIdle, longestIdle),
    // idle(ms),
    // longestIdle(ms)
    var callbackNames = ["scrollPercent", "read", "initialIdle", "timeSpent", "idle", "longestIdle"];
    for (var idx in callbackNames) {
        var cbName = callbackNames[idx];
        myAnalyticsCallbacks[cbName] = callbacks[cbName] || function() {};
    }

    // Set the time, if necessary
    if (timingPrecision !== null && timingPrecision !== undefined) {
        myAnalyticsTimingPrecision = timingPrecision;
    }


    /*
     * register events
     */
    document.addEventListener("scroll", myAnalyticsOnScroll);

    var myAnalyticsIntervalId = window.setInterval(myAnalyticsIntervalTick, myAnalyticsTimingPrecision);
}


function myAnalyticsAtTop() {
    if (latestTimeAtTop > latestTimeAtBottom) {
        // Not new.
        return;
    }

    latestTimeAtTop = Date.now();
}

function myAnalyticsAtBottom() {
    if (latestTimeAtBottom > latestTimeAtTop) {
        // Not new.
        return;
    }

    var prevTimeAtBottom = latestTimeAtBottom;

    if (latestTimeAtTop > prevTimeAtBottom) {
        // Counts as a "read",
        readCount += 1;

        latestTimeAtBottom = Date.now();

        timeToReachBottom = latestTimeAtBottom - latestTimeAtTop; // ms

        (myAnalyticsCallbacks["read"])(latestTimeAtBottom - pageLoadTimestamp,
                                       readCount,
                                       timeToReachBottom);
    }
}

function myAnalyticsOnScroll(el) {
    // can use window.scrollY,
    //         window.scrollMaxY
    // to compute an "overall" percentage.

    // http://stackoverflow.com/questions/442404/retrieve-the-position-x-y-of-an-html-element
    // use el.getBoundingClientRect() to get relative to window
    //   { top, bottom }

    // Window height is `window.innerHeight`
    // http://stackoverflow.com/questions/3012668/get-the-window-height
    // (IE8 and lower use something else)
    //
    if (myAnalyticsContentEl == null) {
        return false;
    }

    var postContentBounds = myAnalyticsContentEl.getBoundingClientRect();
    var postContentTop    = postContentBounds.top;
    var postContentBottom = postContentBounds.bottom;

    var postContentHeight = postContentBottom - postContentTop;

    var viewY      = window.scrollY;
    var viewHeight = window.innerHeight;

    // Compute the scrolled percentage
    var contentScrolledP = (-1 * postContentTop) / (postContentHeight - viewHeight);
    contentScrolledPercentage = Math.ceil(contentScrolledP * 100);

    // Issit worth CB for various percentages?
    // How likely that they read ~40%, but not the whole thing, right?

    // Wait at least 200ms (or so) between CBs.
    if (latestScrollCall < Date.now() - 200) {
        latestScrollCall = Date.now();
        (myAnalyticsCallbacks["scrollPercent"])(latestScrollCall - pageLoadTimestamp,
                                                contentScrolledPercentage);
    }

    // At top if < ~5%
    if (contentScrolledPercentage < 5) {
        myAnalyticsAtTop();
    }

    // At bottom if > ~85%
    // (since this includes the comments section)
    if (contentScrolledPercentage > 85) {
        myAnalyticsAtBottom();
    }

    // onScroll gets called once, even without change??
    if (initialIdleTime == null && prevWindowY != -1) {
        // started scrolling in < precision time.
        initialIdleTime = Date.now() - pageLoadTimestamp;

        (myAnalyticsCallbacks["initialIdle"])(initialIdleTime);
    } else if (initialIdleTime < 0) {
        initialIdleTime *= -1;

        (myAnalyticsCallbacks["initialIdle"])(initialIdleTime);
    }

    return false;
}

function myAnalyticsIntervalTick() {
    myAnalyticsTimeSpent += myAnalyticsTimingPrecision;

    var timeSpentSec = myAnalyticsTimeSpent / 1000;

    // timeSpent(ms, activeTime, currentIdleTime, initIdle, longestIdle),
    (myAnalyticsCallbacks["timeSpent"])(myAnalyticsTimeSpent,
                                        myAnalyticsActiveTimeSpent,
                                        timeAtWindowY,
                                        initialIdleTime, /* kludged */
                                        longestIdleTime);

    // Are we idle?
    if (prevWindowY == window.scrollY) {
        timeAtWindowY += myAnalyticsTimingPrecision;

        (myAnalyticsCallbacks["idle"])(timeAtWindowY);

        // initialIdleTime, kindof a kludge implementation:
        // null if not set.
        // -ve, if we're currently tracking.
        if (initialIdleTime == null) {
            initialIdleTime = -myAnalyticsTimingPrecision * 2;
        } else if (initialIdleTime < 0) {
            initialIdleTime += -myAnalyticsTimingPrecision;
        }

        // Longest Idle time. (Who cares?)
        // (If we were to invoke at the end of the longest,
        //  it wouldn't count the thing at the end.
        //  If analytics phones-home about time spent,
        //  then we want to know longest tail, too).
        if (longestIdleTime < timeAtWindowY) {
            longestIdleTime = timeAtWindowY;

            (myAnalyticsCallbacks["longestIdle"])(longestIdleTime);
        }
    } else {
        timeAtWindowY = 0;
        myAnalyticsActiveTimeSpent += myAnalyticsTimingPrecision;

        (myAnalyticsCallbacks["idle"])(timeAtWindowY);
    }

    prevWindowY = window.scrollY;
}
