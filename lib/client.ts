/* tslint:disable */
import { EventEmitter } from './emitter';

const native: any = require(`./uws_${process.platform}_${process.versions.modules}`);

const OPCODE_TEXT: number = 1;
const OPCODE_PING: number = 9;
const OPCODE_BINARY: number = 2;
// const APP_PONG_CODE: number = 65;
// const APP_PING_CODE: any = Buffer.from('9');
// const PERMESSAGE_DEFLATE: number = 1;
const DEFAULT_PAYLOAD_LIMIT: number = 16777216;

const noop: any = (): void => { };

native.setNoop(noop);

const clientGroup: any = native.client.group.create(0, DEFAULT_PAYLOAD_LIMIT);

native.client.group.onConnection(clientGroup, (newExternal: any): void => {
    const webSocket: any = native.getUserData(newExternal);
    webSocket.external = newExternal;
    webSocket.emit('open');
});

native.client.group.onMessage(clientGroup, (message: any, webSocket: WebSocket): void => {
    webSocket.emit('message', message);
});

native.client.group.onPing(clientGroup, (message: any, webSocket: WebSocket): void => {
    webSocket.emit('ping', message)
});

native.client.group.onPong(clientGroup, (message: any, webSocket: WebSocket): void => {
    webSocket.emit('pong', message)
});

native.client.group.onError(clientGroup, (webSocket: WebSocket): void => {
    process.nextTick((): void => {
        webSocket.emit('error', {
            message: 'uWs client connection error',
            stack: 'uWs client connection error'
        });
    });
});

native.client.group.onDisconnection(clientGroup, (newExternal: any, code: number, message: any, webSocket: WebSocket): void => {
    webSocket.external = null;
    process.nextTick((): void => {
        webSocket.emit('close', code, message);
        webSocket = null;
    });
    native.clearUserData(newExternal);
});

export class WebSocket extends EventEmitter {
    public OPEN: number = 1;
    public CLOSED: number = 0;

    public isAlive: boolean = true;
    public external: any = noop;
    public executeOn: string;

    constructor(url: string, external: any, isServer?: boolean) {
        super();
        this.on('pong', (): boolean => this.isAlive = true);
        this.external = external;
        this.executeOn = isServer ? 'server' : 'client';

        if (!isServer) {
            native.connect(clientGroup, url, this);
        }
    }

    public get _socket() {
        const address = this.external ? native.getAddress(this.external) : new Array(3);
        return {
            remotePort: address[0],
            remoteAddress: address[1],
            remoteFamily: address[2]
        }
    }

    public get readyState(): number {
        return this.external ? this.OPEN : this.CLOSED;
    }

    public ping(message?: any): void {
        if (!this.external) return;
        native[this.executeOn].send(this.external, message, OPCODE_PING);
    }

    public send(message: any, options?: any, cb?: any, compress?: any): void {
        if (!this.external) return cb && cb(new Error('Not opened'));
        const binary: boolean = (options && options.binary) || typeof message !== 'string';
        native[this.executeOn].send(this.external, message, binary ? OPCODE_BINARY : OPCODE_TEXT, cb ? () => process.nextTick(cb) : null, compress);
    }

    public terminate(): void {
        if (!this.external) return;
        native[this.executeOn].terminate(this.external);
        this.external = null;
    }

    public close(code: number, reason: string): void {
        if (!this.external) return;
        native[this.executeOn].close(this.external, code, reason);
        this.external = null;
    }
}