/**
 * Created by tiziano on 23/06/15.
 *
 * type
 * timestamp
 * sessionId
 * userName
 * value1
 * value2
 *
 * type: player
 * value1 (value2): play, pause, speed (on|off), jumpfrom (sec), jumpstartdrag (sec), jumpdrop (sec)
 *
 * type: slides
 * value1 (value2): prev, current, next, select
 *
 * type: screen
 * value1 (value2): navigator (on|off), layout (ps|p|s), fullscreen (on|off)
 *
 */

var sessionId = sessionIdMaker();
var userName = null;

function trackEvent(type, value1, value2){
    var href = window.location.href;
    var arr = href.split("/");
    var url = arr[0] + "//" + arr[2] + "/trackevent";
    var socket = io(url);
    socket.emit('log', {
        type: type,
        sessionId: sessionId,
        userName: userName,
        value1: value1,
        value2: value2,
        timestamp: new Date()
    });
}

function sessionIdMaker() {
    var randomPool = new Uint8Array(32);
    crypto.getRandomValues(randomPool);
    var hex = '';
    for (var i = 0; i < randomPool.length; ++i) {
        hex += randomPool[i].toString(16);
    }
    return hex;
}