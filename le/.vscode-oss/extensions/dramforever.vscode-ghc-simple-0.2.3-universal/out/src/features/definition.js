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
exports.registerDefinition = void 0;
const vscode = require("vscode");
const extension_state_1 = require("../bios/extension-state");
const utils_1 = require("../utils");
function registerDefinition(ext) {
    function provideDefinition(document, position, token) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!utils_1.getFeatures(document.uri).definition)
                // Definition disabled by user
                return null;
            const session = yield extension_state_1.startSession(ext, document);
            if (session === null)
                return null;
            //             ------------------------ maybe qualified
            //                                      ------------------------ operator
            //                                                               ----------------------- name
            const range = document.getWordRangeAtPosition(position, utils_1.haskellSymbolRegex);
            yield session.loading;
            yield session.loadInterpreted(document.uri, token);
            const cmd = `:loc-at ${JSON.stringify(document.uri.fsPath)}`
                + ` ${1 + +range.start.line} ${1 + +range.start.character}`
                + ` ${1 + +range.end.line} ${1 + +range.end.character}`
                + ` ${document.getText(range)}`;
            const res = (yield session.ghci.sendCommand(cmd, { token })).filter(s => s.trim().length > 0);
            if (res.length == 1) {
                const loc = res[0];
                const basePath = session.basePath || vscode.workspace.getWorkspaceFolder(document.uri).uri.fsPath;
                return utils_1.strToLocation(loc, basePath);
            }
            else {
                return null;
            }
        });
    }
    ext.context.subscriptions.push(vscode.languages.registerDefinitionProvider(utils_1.haskellSelector, { provideDefinition }));
}
exports.registerDefinition = registerDefinition;
//# sourceMappingURL=definition.js.map