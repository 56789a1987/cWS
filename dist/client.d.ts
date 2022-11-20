/// <reference types="node" />
import { WebSocketServer } from './server';
import type { SocketAddress, ServerConfigs, SocketClientEvents } from './index';
export declare const enum WebSocketState {
    OPEN = 1,
    CLOSED = 3
}
export declare class WebSocket {
    url: string;
    private options;
    static readonly OPEN: number;
    static readonly CLOSED: number;
    static Server: new (options: ServerConfigs, cb?: () => void) => WebSocketServer;
    readonly OPEN: number;
    readonly CLOSED: number;
    registeredEvents: SocketClientEvents;
    private external;
    private socket;
    constructor(url: string, options?: any);
    get _socket(): SocketAddress;
    get readyState(): number;
    set onopen(listener: () => void);
    set onclose(listener: (code?: number, reason?: string) => void);
    set onerror(listener: (err: Error) => void);
    set onmessage(listener: (message: string | any) => void);
    on<K extends keyof SocketClientEvents>(event: K, listener: SocketClientEvents[K]): void;
    send(message: string | Buffer, options?: {
        binary?: boolean;
        compress?: boolean;
    }, cb?: (err?: Error) => void): void;
    ping(message?: string | Buffer): void;
    close(code?: number, reason?: string): void;
    terminate(): void;
}
