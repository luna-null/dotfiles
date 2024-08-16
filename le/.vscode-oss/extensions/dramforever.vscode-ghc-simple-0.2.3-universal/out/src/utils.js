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
exports.getStackIdeTargets = exports.getIdentifierDocs = exports.reportError = exports.getFeatures = exports.strToLocation = exports.documentIsHaskell = exports.haskellSelector = exports.stackCommand = exports.haskellReplLine = exports.haskellSymbolRegex = void 0;
const path = require("path");
const vscode = require("vscode");
const child_process = require("child_process");
exports.haskellSymbolRegex = /([A-Z][A-Za-z0-9_']*\.)*([!#$%&*+./<=>?@\^|\-~:]+|[A-Za-z_][A-Za-z0-9_']*)/;
exports.haskellReplLine = /^(\s*-{2,}\s+)?>>>(.*)$/;
exports.stackCommand = 'stack --no-terminal --color never';
exports.haskellSelector = [
    { language: 'haskell', scheme: 'file' },
    { language: 'literate haskell', scheme: 'file' }
];
function documentIsHaskell(doc) {
    return doc.uri.scheme === 'file' && (['haskell', 'literate haskell'].indexOf(doc.languageId) !== -1
        || ['.hs', '.lhs'].some(suf => doc.uri.fsPath.endsWith(suf)));
}
exports.documentIsHaskell = documentIsHaskell;
function strToLocation(s, workspaceRoot) {
    const locR = /^(.+):\((\d+),(\d+)\)-\((\d+),(\d+)\)$/;
    const ma = s.match(locR);
    if (ma) {
        const [_all, file, startLine, startCol, endLine, endCol] = ma;
        return new vscode.Location(vscode.Uri.file(path.resolve(workspaceRoot, file)), new vscode.Range(new vscode.Position(+startLine - 1, +startCol - 1), new vscode.Position(+endLine - 1, +endCol - 1)));
    }
    else {
        return null;
    }
}
exports.strToLocation = strToLocation;
function getFeatures(resource) {
    return vscode.workspace.getConfiguration('ghcSimple', resource).feature;
}
exports.getFeatures = getFeatures;
function reportError(ext, msg) {
    return (err) => {
        console.error(`${msg}: ${err}`);
        ext.outputChannel.appendLine(`${msg}: ${err}`);
    };
}
exports.reportError = reportError;
function getIdentifierDocs(session, docUri, ident, token) {
    return __awaiter(this, void 0, void 0, function* () {
        const filterInfo = vscode.workspace.getConfiguration('ghcSimple', docUri).filterInfo;
        // Failsafe: ident should be something reasonable
        if (ident.indexOf('\n') !== -1)
            return null;
        const segments = [];
        const info = yield session.ghci.sendCommand(`:info ${ident}`, { token });
        // Heuristic: If there's an error, then GHCi will output
        // a blank line before the error message
        if (info[0].trim() != '') {
            const lines = [];
            lines.push('```haskell');
            if (filterInfo) {
                for (let i = 0; i < info.length;) {
                    if (info[i].startsWith('instance ')) {
                        do {
                            i++;
                        } while (i < info.length && info[i].match(/^\s/));
                    }
                    else {
                        lines.push(info[i]);
                        i++;
                    }
                }
            }
            else {
                lines.push(...info);
            }
            lines.push('```');
            segments.push(lines.map(x => x + '\n').join(''));
        }
        yield session.loadInterpreted(docUri);
        const docsLines = (yield session.ghci.sendCommand(`:doc ${ident}`, { token }))
            .filter(x => x != '<has no documentation>');
        while (docsLines.length && docsLines[0].match(/^\s*$/)) {
            docsLines.shift();
        }
        if (docsLines.length
            && !docsLines[0].startsWith('ghc: Can\'t find any documentation for')
            && !/^<interactive>[\d\s:-]+error/.test(docsLines[0])) {
            const docs = docsLines.join('\n');
            // Convert Haddock markup into Markdown so it can be displayed properly in hover
            const markdown = docs
                .replace(/^ /gm, "")
                .replace(/^$/gm, "  ")
                // Non-code lines
                .replace(/^(?!\s*>)[^\n]*$/gm, (match) => match
                // Header: ===
                .replace(/^(=+)/gm, (_, $1) => $1.replace(/=/g, "#"))
                // Emphasis: /.../
                .replace(/(?<!\\)\/(.+?)(?<!\\)\//g, "_$1_")
                // Hyperlinked definition: 'T'
                .replace(/(?<!\\)'(\S+)'(?<!\\)/gm, "`$1`")
                // Module: "Prelude"
                .replace(/(?<!\\)"(\S+)"(?<!\\)/gm, "`$1`"))
                // Example:
                // >>> fib 10
                // 55
                .replace(/^>>> .+$\n^.+/gm, m => m.replace(/^.+$/gm, "> $&"))
                // Definition list:
                // [Element]
                //    Definition
                .replace(/^\s*\[(.+?)\]:?\s*([\s\S]+?)(?=\s*^\S)/gm, "$1  \n&nbsp;&nbsp;&nbsp;&nbsp;$2  ")
                // Inline code block: @...@
                .replace(/@(.+?)@/gm, (_, $1) => `\`${$1.replace(/`(.+?)`/gm, "$1")}\``)
                .replace(/^ *(?=`)/gm, m => m.replace(/ /g, "&nbsp;"))
                // Code block:
                // @
                // ...
                // @
                .replace(/^@\n([\s\S]+?)^@/gm, (_, $1) => `\`\`\`haskell\n${$1.replace(/`(.+?)`/gm, "$1")}\`\`\`\n`)
                // Code block:
                // >
                // >
                .replace(/(?:^>(?!>).*\n?)+/gm, m => `\`\`\`haskell\n${m.replace(/^> ?(.*\n?)/gm, "$1")}\`\`\`\n`);
            segments.push(markdown);
        }
        return segments.length ? segments.join('\n---\n') : null;
    });
}
exports.getIdentifierDocs = getIdentifierDocs;
function getStackIdeTargets(workspaceUri) {
    return __awaiter(this, void 0, void 0, function* () {
        const result = yield new Promise((resolve, reject) => {
            child_process.exec(`${exports.stackCommand} ide targets`, { cwd: workspaceUri.fsPath }, (err, stdout, stderr) => {
                if (err)
                    reject('Command stack ide targets failed:\n' + stderr);
                else
                    resolve(stderr.toString());
            });
        });
        return result.match(/^[^\s]+:[^\s]+$/gm);
    });
}
exports.getStackIdeTargets = getStackIdeTargets;
//# sourceMappingURL=utils.js.map