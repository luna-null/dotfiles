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
exports.registerDiagnostics = void 0;
const vscode = require("vscode");
const extension_state_1 = require("../bios/extension-state");
const utils_1 = require("../utils");
const regex = {
    // Groups: (Because there's no named group in JS Regex)
    // 1: file
    // 2-3: variant 1: line:col
    // 4-6: variant 2: line:col-col
    // 7-10: variant 3: (line, col)
    message_base: /^(.+):(?:(\d+):(\d+)|(\d+):(\d+)-(\d+)|\((\d+),(\d+)\)-\((\d+),(\d+)\)): (.+)$/,
    single_line_error: /^error: (?:\[.+\] )?([^\[].*)$/,
    single_line_warning: /^warning: \[(.+)\] (.+)$/,
    error: /^error:(?: \[.*\])?$/,
    warning: /^warning:(?: \[(.+)\])?$/
};
function parseMessages(messages) {
    const res = [];
    while (messages.length > 0) {
        const heading = messages.shift();
        if (/^(Ok|Failed),(.*) loaded.$/.test(heading))
            continue;
        // Avoid duplicated warnings
        // https://gitlab.haskell.org/ghc/ghc/issues/18068
        if (/Collecting type info for \d+ module\(s\) .../.test(heading))
            break;
        const res_heading = regex.message_base.exec(heading);
        if (res_heading !== null) {
            const range = (() => {
                // Column number can be 0, which when passed to VSCode becomes -1.
                // VSCode does not like this and errors out.
                //
                // https://github.com/dramforever/vscode-ghc-simple/issues/88
                const fixCol = (n) => (n <= 0) ? 1 : n;
                function num(n) { return parseInt(res_heading[n]); }
                if (res_heading[2]) {
                    // line:col
                    const line = num(2);
                    const col = num(3);
                    return new vscode.Range(line - 1, fixCol(col) - 1, line - 1, fixCol(col));
                }
                else if (res_heading[4]) {
                    // line:col-col
                    const line = num(4);
                    const col0 = num(5);
                    const col1 = num(6);
                    return new vscode.Range(line - 1, fixCol(col0) - 1, line - 1, fixCol(col1));
                }
                else if (res_heading[7]) {
                    // (line,col)-(line,col)
                    const line0 = num(7);
                    const col0 = num(8);
                    const line1 = num(9);
                    const col1 = num(10);
                    return new vscode.Range(line0 - 1, fixCol(col0) - 1, line1 - 1, fixCol(col1));
                }
                else {
                    // Shouldn't happen!
                    throw 'Strange heading in parseMessages';
                }
            })();
            const res_sl_error = regex.single_line_error.exec(res_heading[11]);
            const res_sl_warning = regex.single_line_warning.exec(res_heading[11]);
            const res_error = regex.error.exec(res_heading[11]);
            const res_warning = regex.warning.exec(res_heading[11]);
            const sev = vscode.DiagnosticSeverity;
            const error_warnings = [
                '-Wdeferred-type-errors',
                '-Wdeferred-out-of-scope-variables',
                '-Wtyped-holes'
            ];
            if (res_sl_error !== null) {
                res.push({
                    file: res_heading[1],
                    diagnostic: new vscode.Diagnostic(range, res_sl_error[1], sev.Error)
                });
            }
            else if (res_sl_warning !== null) {
                const severity = error_warnings.indexOf(res_sl_warning[1]) >= 0 ? sev.Error : sev.Warning;
                res.push({
                    file: res_heading[1],
                    diagnostic: new vscode.Diagnostic(range, res_sl_warning[2], severity)
                });
            }
            else {
                const msgs = [];
                while (messages.length > 0 && messages[0].startsWith('    ')) {
                    msgs.push(messages.shift().substr(4));
                }
                const msg = msgs.join('\n') + (msgs.length ? '\n' : '');
                const severity = (() => {
                    if (res_error !== null) {
                        return sev.Error;
                    }
                    else if (res_warning !== null
                        && res_warning[1]
                        && error_warnings.indexOf(res_warning[1]) >= 0) {
                        return sev.Error;
                    }
                    else if (res_warning !== null) {
                        return sev.Warning;
                    }
                    else {
                        throw 'Strange heading in parseMessages';
                    }
                })();
                res.push({
                    file: res_heading[1],
                    diagnostic: new vscode.Diagnostic(range, msg, severity)
                });
            }
        }
    }
    return res;
}
function stopHaskell(document, ext) {
    if (utils_1.documentIsHaskell(document)) {
        extension_state_1.stopSession(ext, document);
    }
}
function checkHaskell(diagnosticCollection, document, ext) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!utils_1.getFeatures(document.uri).diagnostics)
            // Diagnostics disabled by user
            return false;
        if (utils_1.documentIsHaskell(document)) {
            const session = yield extension_state_1.startSession(ext, document);
            if (session === null)
                return false;
            const result = yield session.reload();
            const parsed = parseMessages(result);
            const diagMap = new Map();
            for (const diag of parsed) {
                const path = vscode.Uri.file(diag.file).fsPath;
                if (!diagMap.has(path))
                    diagMap.set(path, []);
                diagMap.get(path).push(diag.diagnostic);
            }
            diagnosticCollection.clear();
            for (const [path, diags] of diagMap.entries()) {
                diagnosticCollection.set(vscode.Uri.file(path), diags);
            }
        }
    });
}
function registerDiagnostics(ext) {
    const diagnosticCollection = vscode.languages.createDiagnosticCollection('ghc-simple');
    const check = (d) => checkHaskell(diagnosticCollection, d, ext)
        .catch(utils_1.reportError(ext, `Error checking ${d.uri.fsPath}`));
    const stop = (d) => stopHaskell(d, ext);
    const vws = vscode.workspace;
    ext.context.subscriptions.push(diagnosticCollection, vws.onDidSaveTextDocument(check), vws.onDidOpenTextDocument(check), vws.onDidCloseTextDocument(stop));
    function initialize() {
        for (const doc of vscode.workspace.textDocuments) {
            check(doc);
        }
    }
    initialize();
    return initialize;
}
exports.registerDiagnostics = registerDiagnostics;
//# sourceMappingURL=diagnostics.js.map