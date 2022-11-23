import { WebSocketServer } from './server';
import type { SocketAddress, ServerConfigs, SocketClientEvents } from './index';
import { native, setupNative, noop, DEFAULT_PAYLOAD_LIMIT, OPCODE_PING, OPCODE_BINARY, OPCODE_TEXT } from './shared';

const clientGroup: any = native.client.group.create(0, DEFAULT_PAYLOAD_LIMIT);
setupNative(clientGroup, 'client');

export const enum WebSocketState {
  OPEN = 1,
  CLOSED = 3
}

export class WebSocket {
  public static readonly OPEN: number = WebSocketState.OPEN;
  public static readonly CLOSED: number = WebSocketState.CLOSED;
  public static Server: new (options: ServerConfigs, cb?: () => void) => WebSocketServer = WebSocketServer;

  public readonly OPEN: number = WebSocketState.OPEN;
  public readonly CLOSED: number = WebSocketState.CLOSED;
  public registeredEvents: SocketClientEvents = {
    open: noop,
    ping: noop,
    pong: noop,
    error: noop,
    close: noop,
    message: noop
  };

  private external: any;
  private socket: any;

  constructor(public url: string, private options: any = {}) {
    if (!this.url && this.options.external) {
      this.socket = native.server;
      this.external = this.options.external;
    } else {
      this.socket = native.client;
      native.connect(clientGroup, url, this);
    }
  }

  public get _socket(): SocketAddress {
    const address: any[] = this.external ? native.getAddress(this.external) : new Array(3);
    return {
      remotePort: address[0],
      remoteAddress: address[1],
      remoteFamily: address[2]
    };
  }

  public get readyState(): number {
    return this.external ? WebSocketState.OPEN : WebSocketState.CLOSED;
  }

  public set onopen(listener: () => void) {
    this.on('open', listener);
  }

  public set onclose(listener: (code?: number, reason?: string) => void) {
    this.on('close', listener);
  }

  public set onerror(listener: (err: Error) => void) {
    this.on('error', listener);
  }

  public set onmessage(listener: (message: string | any) => void) {
    this.on('message', listener);
  }

  public on<K extends keyof SocketClientEvents>(event: K, listener: SocketClientEvents[K]): void;
  public on(event: string, listener: (...args: any[]) => void): void {
    if (this.registeredEvents[event] === undefined) {
      console.warn(`cWS does not support '${event}' event`);
      return;
    }

    if (typeof listener !== 'function') {
      throw new Error(`Listener for '${event}' event must be a function`);
    }

    if (this.registeredEvents[event] !== noop) {
      console.warn(`cWS does not support multiple listeners for the same event. Old listener for '${event}' event will be overwritten`);
    }

    this.registeredEvents[event] = listener;
  }

  public send(message: string | Buffer, options?: { binary?: boolean, compress?: boolean }, cb?: (err?: Error) => void): void {
    if (this.external) {
      let opCode: number = typeof message === 'string' ? OPCODE_TEXT : OPCODE_BINARY;

      // provided options should always overwrite default
      if (options && options.binary === false) {
        opCode = OPCODE_TEXT;
      }

      if (options && options.binary === true) {
        opCode = OPCODE_BINARY;
      }

      this.socket.send(this.external, message, opCode, cb ? (): void => process.nextTick(cb) : null, options && options.compress);
    } else if (cb) {
      cb(new Error('Socket not connected'));
    }
  }

  public ping(message?: string | Buffer): void {
    if (this.external) {
      this.socket.send(this.external, message, OPCODE_PING);
    }
  }

  public close(code: number = 1000, reason?: string): void {
    if (this.external) {
      this.socket.close(this.external, code, reason);
      this.external = null;
    }
  }

  public terminate(): void {
    if (this.external) {
      this.socket.terminate(this.external);
      this.external = null;
    }
  }
}
