'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GhciManager = void 0;
const child_process = require("child_process");
const readline = require("readline");
class GhciManager {
    constructor(command, options, ext) {
        this.currentCommand = null;
        this.pendingCommands = [];
        this.proc = null;
        this.command = command;
        this.options = options;
        this.ext = ext;
        this.wasDisposed = false;
    }
    makeReadline(stream) {
        const res = readline.createInterface({
            input: stream
        });
        res.on('line', this.handleLine.bind(this));
        return res;
    }
    checkDisposed() {
        if (this.wasDisposed)
            throw 'ghci already disposed';
    }
    outputLine(line) {
        this.ext.outputChannel.appendLine(line);
    }
    idle() {
        this.ext.statusBar.update(this, {
            status: 'idle'
        });
    }
    busy(info = null) {
        this.ext.statusBar.update(this, {
            status: 'busy',
            info
        });
    }
    start() {
        return __awaiter(this, void 0, void 0, function* () {
            this.checkDisposed();
            if (Array.isArray(this.command)) {
                this.proc = child_process.spawn(this.command[0], this.command.slice(1), Object.assign(Object.assign({}, this.options), { stdio: 'pipe', shell: false }));
            }
            else {
                this.proc = child_process.spawn(this.command, Object.assign(Object.assign({}, this.options), { stdio: 'pipe', shell: true }));
            }
            this.proc.on('exit', () => { this.proc = null; });
            this.proc.on('error', () => { this.proc = null; });
            this.stdout = this.makeReadline(this.proc.stdout);
            this.stderr = this.makeReadline(this.proc.stderr);
            this.proc.stdin.on('close', this.handleClose.bind(this));
            yield this.sendCommand([':set prompt ""', ':set prompt-cont ""'], {
                info: 'Starting'
            });
            return this.proc;
        });
    }
    stop() {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                yield this.sendCommand(':quit');
                throw 'Quitting ghci should not have succeeded';
            }
            catch (_reason) {
                return;
            }
        });
    }
    kill() {
        if (this.proc !== null) {
            this.proc.kill();
            this.proc = null;
        }
    }
    sendCommand(cmds, config = {}) {
        return __awaiter(this, void 0, void 0, function* () {
            if (config.token) {
                config.token.onCancellationRequested(this.handleCancellation.bind(this));
            }
            const commands = (typeof cmds === 'string') ? [cmds] : cmds;
            if (this.proc === null) {
                yield this.start();
            }
            return this._sendCommand(commands, config);
        });
    }
    _sendCommand(commands, config = {}) {
        return new Promise((resolve, reject) => {
            this.checkDisposed();
            const nullConfig = {
                token: null,
                info: null
            };
            const pending = Object.assign(Object.assign(Object.assign({}, nullConfig), config), { commands, resolve, reject });
            if (this.currentCommand === null) {
                this.launchCommand(pending);
            }
            else {
                this.pendingCommands.push(pending);
            }
        });
    }
    handleLine(line) {
        line = line.replace(/\ufffd/g, ''); // Workaround for invalid characters showing up in output
        this.outputLine(`ghci | ${line}`);
        if (this.currentCommand === null) {
            // Ignore stray line
        }
        else {
            if (this.currentCommand.barrier === line) {
                this.currentCommand.resolve(this.currentCommand.lines);
                this.currentCommand = null;
                this.handleCancellation();
                if (this.pendingCommands.length > 0) {
                    this.launchCommand(this.pendingCommands.shift());
                }
            }
            else {
                this.currentCommand.lines.push(line);
            }
            this.handleStatusUpdate(line);
        }
    }
    handleCancellation() {
        while (this.pendingCommands.length > 0
            && this.pendingCommands[0].token
            && this.pendingCommands[0].token.isCancellationRequested) {
            this.outputLine(`Cancel ${this.pendingCommands[0].commands}`);
            this.pendingCommands[0].reject('cancelled');
            this.pendingCommands.shift();
        }
        if (this.pendingCommands.length == 0)
            this.idle();
    }
    handleStatusUpdate(line) {
        {
            const compilingRegex = /^(\[\d+ +of +\d+\]) Compiling ([^ ]+)/;
            const match = line.match(compilingRegex);
            if (match) {
                this.busy(`${match[1]} ${match[2]}`);
            }
        }
        {
            if (line.startsWith('Collecting type info for')) {
                this.busy('Collecting type info');
            }
        }
    }
    launchCommand({ commands, info, resolve, reject }) {
        const barrier = '===ghci_barrier_' + Math.random().toString() + '===';
        this.currentCommand = { resolve, reject, barrier, lines: [] };
        this.busy(info);
        if (commands.length > 0) {
            this.outputLine(`    -> ${commands[0]}`);
            for (const c of commands.slice(1))
                this.outputLine(`    |> ${c}`);
        }
        for (const c of commands) {
            this.proc.stdin.write(c + '\n');
        }
        this.proc.stdin.write(`Prelude.putStrLn "\\n${barrier}"\n`);
    }
    handleClose() {
        if (this.currentCommand !== null) {
            this.currentCommand.reject('stream closed');
            this.currentCommand = null;
        }
        for (const cmd of this.pendingCommands) {
            cmd.reject('stream closed');
        }
        this.pendingCommands.length = 0; // Clear pendingCommands
        this.dispose();
    }
    dispose() {
        this.wasDisposed = true;
        this.ext.statusBar.remove(this);
        if (this.proc !== null) {
            this.proc.kill();
            this.proc = null;
        }
        this.stdout = null;
        this.stderr = null;
    }
}
exports.GhciManager = GhciManager;
//# sourceMappingURL=ghci.js.map