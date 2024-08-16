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
exports.registerCompletion = void 0;
const vscode = require("vscode");
const extension_state_1 = require("../bios/extension-state");
const utils_1 = require("../utils");
function registerCompletion(ext) {
    const itemDocument = new Map();
    function provideCompletionItems(document, position, token) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!utils_1.getFeatures(document.uri).completion)
                // Completion disabled by user
                return null;
            const session = yield extension_state_1.startSession(ext, document);
            if (session === null)
                return null;
            const firstInLine = position.with({ character: 0 });
            let line = document.getText(new vscode.Range(firstInLine, position));
            if (line.trim() === '')
                return null;
            let delta = 0;
            if (line.trim().startsWith(':')) {
                line = 'x' + line;
                delta -= 1;
            }
            const replResult = utils_1.haskellReplLine.exec(line);
            if (replResult !== null) {
                line = line.slice(replResult[1].length + '>>>'.length);
                delta += replResult[1].length + '>>>'.length;
            }
            yield session.loading;
            yield session.loadInterpreted(document.uri, token);
            const { maxCompletions } = vscode.workspace.getConfiguration('ghcSimple', document.uri);
            const complStrs = yield session.ghci.sendCommand(`:complete repl ${maxCompletions} ${JSON.stringify(line)}`, { token });
            const firstLine = /^\d+ \d+ (".*")$/.exec(complStrs[0]);
            if (firstLine === null) {
                ext.outputChannel.appendLine('Bad completion response');
                return null;
            }
            complStrs.shift(); // Remove first info line
            complStrs.pop(); // Remove last empty line
            const result = firstLine[1];
            const prefix = JSON.parse(result);
            const replaceRange = new vscode.Range(position.with({ character: prefix.length + delta }), position);
            const items = [];
            for (const u of complStrs) {
                const st = JSON.parse(u);
                // Filter out 'it' and 'Ghci*.it' if not in '>>>' block
                if (replResult === null
                    && (st == "it" || /Ghci\d+\.it/.test(st)))
                    continue;
                const cp = new vscode.CompletionItem(st, vscode.CompletionItemKind.Variable);
                cp.range = replaceRange;
                itemDocument.set(cp, document);
                items.push(cp);
            }
            return new vscode.CompletionList(items, true);
        });
    }
    function resolveCompletionItem(item, token) {
        return __awaiter(this, void 0, void 0, function* () {
            if (itemDocument.has(item)) {
                const document = itemDocument.get(item);
                const session = yield extension_state_1.startSession(ext, document);
                if (session === null)
                    return item;
                yield session.loading;
                item.documentation = new vscode.MarkdownString(yield utils_1.getIdentifierDocs(session, document.uri, item.label, token));
            }
            return item;
        });
    }
    ext.context.subscriptions.push(vscode.languages.registerCompletionItemProvider(utils_1.haskellSelector, { provideCompletionItems, resolveCompletionItem }, ' ', ':'));
}
exports.registerCompletion = registerCompletion;
//# sourceMappingURL=completion.js.map