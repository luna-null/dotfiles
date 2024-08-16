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
exports.registerHover = void 0;
const vscode = require("vscode");
const extension_state_1 = require("../bios/extension-state");
const utils_1 = require("../utils");
const vscode_1 = require("vscode");
function registerHover(ext) {
    function provideHover(document, position, token) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!utils_1.getFeatures(document.uri).hover)
                // Hover disabled by user
                return null;
            const range = document.getWordRangeAtPosition(position, utils_1.haskellSymbolRegex);
            if (!range)
                return null;
            const session = yield extension_state_1.startSession(ext, document);
            if (session === null)
                return null;
            yield session.loading;
            const documentation = yield utils_1.getIdentifierDocs(session, document.uri, document.getText(range));
            return new vscode_1.Hover(new vscode_1.MarkdownString(documentation), range);
        });
    }
    ext.context.subscriptions.push(vscode.languages.registerHoverProvider(utils_1.haskellSelector, { provideHover }));
}
exports.registerHover = registerHover;
//# sourceMappingURL=hover.js.map