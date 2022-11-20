/// <reference types="node" />
import * as HTTP from 'http';
import * as HTTPS from 'https';
import type { WebSocket } from './client';
export declare type VerifyClientNext = (verified: boolean, code?: number, message?: string) => void;
export interface SocketAddress {
    remotePort?: number;
    remoteAddress?: string;
    remoteFamily?: string;
}
export interface ConnectionInfo {
    req: HTTP.IncomingMessage;
    secure: boolean;
    origin?: string;
}
export interface ServerConfigs {
    path?: string;
    port?: number;
    host?: string;
    server?: HTTP.Server | HTTPS.Server;
    noDelay?: boolean;
    noServer?: boolean;
    maxPayload?: number;
    perMessageDeflate?: boolean | {
        serverNoContextTakeover: boolean;
    };
    verifyClient?: (info: ConnectionInfo, next: VerifyClientNext) => void;
}
export interface SocketClientEvents {
    open: () => void;
    ping: (message: string | any) => void;
    pong: (message: string | any) => void;
    error: (err: Error) => void;
    close: (code?: number, reason?: string) => void;
    message: (message: string | any) => void;
}
export interface SocketServerEvents {
    close: () => void;
    error: (err: Error) => void;
    connection: (socket: WebSocket, req?: HTTP.IncomingMessage) => void;
}
export { WebSocket } from './client';
export { WebSocketServer } from './server';
export declare const secureProtocol: string;
