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
exports.registerInlineRepl = void 0;
const vscode = require("vscode");
const extension_state_1 = require("../bios/extension-state");
const utils_1 = require("../utils");
function generateReplacement(response, outputRange, prefix) {
    response = response.slice();
    if (response[0] == '')
        response.shift();
    if (response[response.length - 1] == '')
        response.pop();
    const filtRsponse = response.map(s => prefix + (s == '' ? '<BLANKLINE>' : s));
    const end = outputRange.isEmpty ? '\n' : '';
    return filtRsponse.map(s => s + '\n').join('') + prefix.replace(/\s+$/, '') + end;
}
function registerInlineRepl(ext) {
    const availableRepl = new WeakMap();
    function parseReplBlockAt(document, lineNum) {
        const { lineCount } = document;
        const headerLine = document.lineAt(lineNum);
        const header = headerLine.text.replace(/\s+$/, '');
        const headerRes = utils_1.haskellReplLine.exec(header);
        if (headerRes !== null) {
            const headerLineNum = lineNum;
            const prefix = headerRes[1] || '';
            const commands = [];
            for (; lineNum < lineCount; lineNum++) {
                const line = document.lineAt(lineNum).text.replace(/\s+$/, '');
                const lineRes = utils_1.haskellReplLine.exec(line);
                if (line.startsWith(prefix) && lineRes !== null) {
                    commands.push(lineRes[2]);
                }
                else {
                    break;
                }
            }
            const outputLineNum = lineNum;
            for (; lineNum < lineCount; lineNum++) {
                const line = document.lineAt(lineNum).text.replace(/\s+$/, '');
                if (line == prefix.replace(/\s+$/, '')) {
                    lineNum++;
                    break;
                }
                if (utils_1.haskellReplLine.test(line) || !line.startsWith(prefix))
                    break;
            }
            const endLineNum = lineNum;
            const headerRange = new vscode.Range(document.lineAt(headerLineNum).range.start, document.lineAt(outputLineNum - 1).range.end);
            const outputRange = new vscode.Range(document.lineAt(outputLineNum).range.start, outputLineNum == endLineNum
                ? document.lineAt(outputLineNum).range.start
                : document.lineAt(endLineNum - 1).range.end);
            return [lineNum, { headerRange, outputRange, commands, prefix }];
        }
        else {
            return [lineNum + 1, null];
        }
    }
    function inlineReplRun(textEditor, edit, arg) {
        return __awaiter(this, void 0, void 0, function* () {
            if (typeof arg === 'undefined') {
                if (!availableRepl.has(textEditor.document))
                    return;
                for (const [hr, cmd] of availableRepl.get(textEditor.document))
                    if (hr.contains(textEditor.selection) && cmd.arguments[0]) {
                        yield inlineReplRun(textEditor, edit, cmd.arguments[0]);
                        break;
                    }
            }
            else {
                const { headerLineNum, isRunning } = arg;
                if (isRunning.flag)
                    return;
                isRunning.flag = true;
                try {
                    const [, res] = parseReplBlockAt(textEditor.document, headerLineNum);
                    if (res === null)
                        return;
                    const { outputRange, commands, prefix } = res;
                    const session = yield extension_state_1.startSession(ext, textEditor.document);
                    if (session === null)
                        return;
                    yield session.loading;
                    yield session.loadInterpreted(textEditor.document.uri);
                    let loadType = vscode.workspace.getConfiguration('ghcSimple.inlineRepl', textEditor.document.uri).loadType;
                    const extraLoadCommands = [];
                    if (commands[0].match(/^\s*:set/)) {
                        extraLoadCommands.push(commands.shift());
                    }
                    const messages = yield session.ghci.sendCommand([
                        `:set -f${loadType}`,
                        ...extraLoadCommands,
                        ':reload'
                    ], { info: 'Reloading' });
                    if (messages.some(x => x.startsWith('Failed'))) {
                        const msgs = [
                            '(Error while loading modules for evaluation)',
                            ...messages
                        ];
                        const replacement = generateReplacement(msgs, outputRange, prefix);
                        yield textEditor.edit(e => e.replace(outputRange, replacement), { undoStopBefore: !arg.batch, undoStopAfter: !arg.batch });
                        return;
                    }
                    const response = yield session.ghci.sendCommand(commands, { info: 'Running in REPL' });
                    const replacement = generateReplacement(response, outputRange, prefix);
                    yield textEditor.edit(e => e.replace(outputRange, replacement), { undoStopBefore: !arg.batch, undoStopAfter: !arg.batch });
                }
                finally {
                    isRunning.flag = false;
                }
            }
        });
    }
    function inlineReplRunAll(textEditor, edit) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!availableRepl.has(textEditor.document))
                return;
            textEditor.edit(() => { }, { undoStopBefore: true, undoStopAfter: false });
            for (const [, cmd] of availableRepl.get(textEditor.document))
                yield inlineReplRun(textEditor, edit, Object.assign({}, cmd.arguments[0], { batch: true }));
            textEditor.edit(() => { }, { undoStopBefore: false, undoStopAfter: true });
        });
    }
    ext.context.subscriptions.push(vscode.commands.registerTextEditorCommand('vscode-ghc-simple.inline-repl-run', (textEditor, edit, arg) => {
        inlineReplRun(textEditor, edit, arg)
            .catch(utils_1.reportError(ext, 'Error running inline repl'));
    }), vscode.commands.registerTextEditorCommand('vscode-ghc-simple.inline-repl-run-all', (textEditor, edit) => {
        inlineReplRunAll(textEditor, edit)
            .catch(utils_1.reportError(ext, 'Error running inline repl'));
    }));
    function provideCodeLenses(document) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!utils_1.getFeatures(document.uri).inlineRepl) {
                // Inline REPL disabled by user
                availableRepl.delete(document);
                return;
            }
            const codeLensEnabled = vscode.workspace.getConfiguration('ghcSimple.inlineRepl', document.uri).codeLens;
            const codeLenses = [];
            const available = [];
            const lineCount = document.lineCount;
            for (let lineNum = 0; lineNum < lineCount;) {
                const [lineNum1, res] = parseReplBlockAt(document, lineNum);
                lineNum = lineNum1;
                if (res !== null) {
                    const { headerRange } = res;
                    const command = {
                        title: 'Run in GHCi',
                        command: 'vscode-ghc-simple.inline-repl-run',
                        arguments: [
                            {
                                headerLineNum: headerRange.start.line,
                                isRunning: { flag: false }
                            }
                        ]
                    };
                    available.push([headerRange, command]);
                    if (codeLensEnabled)
                        codeLenses.push(new vscode.CodeLens(document.lineAt(headerRange.start.line).range, command));
                }
            }
            availableRepl.set(document, available);
            return codeLenses;
        });
    }
    ext.context.subscriptions.push(vscode.languages.registerCodeLensProvider(utils_1.haskellSelector, { provideCodeLenses }));
}
exports.registerInlineRepl = registerInlineRepl;
//# sourceMappingURL=inline-repl.js.map