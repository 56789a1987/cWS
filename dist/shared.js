"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.setupNative = exports.native = exports.DEFAULT_PAYLOAD_LIMIT = exports.SLIDING_DEFLATE_WINDOW = exports.PERMESSAGE_DEFLATE = exports.APP_PING_CODE = exports.OPCODE_BINARY = exports.OPCODE_PING = exports.OPCODE_TEXT = exports.noop = void 0;
const client_1 = require("./client");
const noop = () => { };
exports.noop = noop;
exports.OPCODE_TEXT = 1;
exports.OPCODE_PING = 9;
exports.OPCODE_BINARY = 2;
exports.APP_PING_CODE = Buffer.from('9');
exports.PERMESSAGE_DEFLATE = 1;
exports.SLIDING_DEFLATE_WINDOW = 16;
exports.DEFAULT_PAYLOAD_LIMIT = 16777216;
exports.native = (() => {
    try {
        return require(`../dist/bindings/cws_${process.platform}_${process.versions.modules}`);
    }
    catch (err) {
        err.message = err.message + ` check './node_modules/@clusterws/cws/build_log.txt' for post install build logs`;
        throw err;
    }
})();
function setupNative(group, type, wsServer) {
    exports.native.setNoop(exports.noop);
    const nativeGroup = (type === 'server' ? exports.native.server : exports.native.client).group;
    nativeGroup.onConnection(group, (external) => {
        if (type === 'server' && wsServer) {
            const socket = new client_1.WebSocket(null, { external });
            exports.native.setUserData(external, socket);
            if (wsServer.upgradeCb) {
                wsServer.upgradeCb(socket);
            }
            else {
                wsServer.registeredEvents.connection(socket, wsServer.upgradeReq);
            }
            wsServer.upgradeCb = null;
            wsServer.upgradeReq = null;
            return;
        }
        const webSocket = exports.native.getUserData(external);
        webSocket.external = external;
        webSocket.registeredEvents.open();
    });
    nativeGroup.onPing(group, (message, webSocket) => {
        webSocket.registeredEvents.ping(message);
    });
    nativeGroup.onPong(group, (message, webSocket) => {
        webSocket.registeredEvents.pong(message);
    });
    nativeGroup.onMessage(group, (message, webSocket) => {
        webSocket.registeredEvents.message(message);
    });
    nativeGroup.onDisconnection(group, (newExternal, code, message, webSocket) => {
        webSocket.external = null;
        process.nextTick(() => {
            webSocket.registeredEvents.close(code || 1005, message || '');
        });
        exports.native.clearUserData(newExternal);
    });
    if (type === 'client') {
        nativeGroup.onError(group, (webSocket) => {
            process.nextTick(() => {
                webSocket.registeredEvents.error(new Error('cWs client connection error'));
            });
        });
    }
}
exports.setupNative = setupNative;
