"use strict";
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
exports.Session = void 0;
const fs = require("fs");
const vscode = require("vscode");
const ghci_1 = require("./ghci");
const utils_1 = require("../utils");
class Session {
    constructor(ext, cmd, cwd, resource) {
        this.ext = ext;
        this.cmd = cmd;
        this.cwd = cwd;
        this.resource = resource;
        this.ghci = null;
        this.starting = null;
        this.loading = null;
        this.files = new Set();
        this.onWillReloadEmitter = new vscode.EventEmitter();
        this.onWillReload = this.onWillReloadEmitter.event;
        this.moduleMap = new Map();
        this.cwdOption = cwd ? { cwd } : {};
        this.wasDisposed = false;
        this.lastReload = null;
    }
    checkDisposed() {
        if (this.wasDisposed)
            throw 'session already disposed';
    }
    start() {
        if (this.starting === null) {
            this.starting = this.startP();
            this.starting.catch(err => {
                if (this.wasDisposed) {
                    // We are disposed so do not report error
                    return;
                }
                utils_1.reportError(this.ext, err.toString());
                vscode.window.showWarningMessage('Error while starting GHCi.', 'Open log').then((item) => {
                    if (item === 'Open log') {
                        this.ext.outputChannel.show();
                    }
                }, (err) => console.error(err));
            });
        }
        return this.starting;
    }
    startP() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.ghci === null) {
                this.checkDisposed();
                this.ext.outputChannel.appendLine(`Starting GHCi with: ${JSON.stringify(this.cmd)}`);
                this.ext.outputChannel.appendLine(`(Under ${this.cwdOption.cwd === undefined
                    ? 'default cwd'
                    : `cwd ${this.cwdOption.cwd}`})`);
                this.checkDisposed();
                this.ghci = new ghci_1.GhciManager(this.cmd, this.cwdOption, this.ext);
                const cmds = vscode.workspace.getConfiguration('ghcSimple.startupCommands', this.resource);
                const configureCommands = [].concat(cmds.all, this.cwd ? [] : cmds.bare, cmds.custom);
                yield this.ghci.sendCommand(configureCommands);
                this.basePath = yield this.generateBasePath();
            }
        });
    }
    generateBasePath() {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const res = yield this.ghci.sendCommand(':show paths');
                if (res.length < 1) {
                    throw new Error('":show paths" has too few lines');
                }
                // expect second line of the output to be current ghci path
                const basePath = res[1].trim();
                if (basePath.length <= 0 || basePath[0] != '/') {
                    throw new Error(`Invalid path value: ${basePath}`);
                }
                const doesExist = yield new Promise(resolve => fs.exists(basePath, resolve));
                if (!doesExist) {
                    throw new Error(`Detected path doesn\'t exist: ${basePath}`);
                }
                this.ext.outputChannel.appendLine(`Detected base path: ${basePath}`);
                return basePath;
            }
            catch (e) {
                this.ext.outputChannel.appendLine(`Error detecting base path: ${e}`);
                this.ext.outputChannel.appendLine('Will fallback to document\'s workspace folder');
                return undefined;
            }
        });
    }
    addFile(s) {
        this.files.add(s);
    }
    removeFile(s) {
        this.files.delete(s);
    }
    reload() {
        return __awaiter(this, void 0, void 0, function* () {
            this.onWillReloadEmitter.fire();
            const pr = this.reloadP();
            this.loading = pr.then(() => undefined);
            return pr;
        });
    }
    reloadP() {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.start();
            const mods = [...this.files.values()];
            mods.sort();
            const sameModules = (this.lastReload
                && this.lastReload.length == mods.length
                && this.lastReload.every((val, i) => val === mods[i]));
            this.lastReload = mods;
            const res = yield this.ghci.sendCommand([
                ':set +c',
                sameModules
                    ? ':reload'
                    : `:load ${mods.map(x => JSON.stringify(`*${x}`)).join(' ')}`
            ], { info: 'Loading' });
            const modules = yield this.ghci.sendCommand(':show modules');
            this.moduleMap.clear();
            for (const line of modules) {
                const res = /^([^ ]+)\s+\( (.+), .+ \)$/.exec(line);
                if (res) {
                    this.moduleMap.set(vscode.Uri.file(res[2]).fsPath, res[1]);
                }
            }
            yield this.ghci.sendCommand(':module');
            return res;
        });
    }
    loadInterpreted(uri, token = null) {
        return __awaiter(this, void 0, void 0, function* () {
            const module = this.getModuleName(uri.fsPath);
            yield this.ghci.sendCommand([`:m *${module}`], { token });
        });
    }
    getModuleName(filename) {
        return this.moduleMap.get(filename);
    }
    dispose() {
        this.wasDisposed = true;
        if (this.ghci !== null)
            this.ghci.dispose();
        this.onWillReloadEmitter.dispose();
    }
}
exports.Session = Session;
//# sourceMappingURL=session.js.map