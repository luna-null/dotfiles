'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
const vscode = require("vscode");
const range_type_1 = require("./features/range-type");
const completion_1 = require("./features/completion");
const diagnostics_1 = require("./features/diagnostics");
const definition_1 = require("./features/definition");
const reference_1 = require("./features/reference");
const inline_repl_1 = require("./features/inline-repl");
const status_bar_1 = require("./features/status-bar");
const hover_1 = require("./features/hover");
function activate(context) {
    const outputChannel = vscode.window.createOutputChannel('GHC');
    const documentSessions = new Map();
    const sharableSessions = new Map();
    const statusBar = new status_bar_1.StatusBar(documentSessions);
    const ext = {
        context,
        outputChannel,
        statusBar,
        documentSessions,
        sharableSessions
    };
    context.subscriptions.push(outputChannel, statusBar);
    range_type_1.registerRangeType(ext);
    completion_1.registerCompletion(ext);
    definition_1.registerDefinition(ext);
    reference_1.registerReference(ext);
    inline_repl_1.registerInlineRepl(ext);
    hover_1.registerHover(ext);
    const diagInit = diagnostics_1.registerDiagnostics(ext);
    function killEverything() {
        const disposed = new Set();
        for (const [_doc, state] of ext.documentSessions) {
            if (!disposed.has(state)) {
                state.session.dispose();
                disposed.add(state);
            }
        }
        for (const [_keyString, state] of ext.sharableSessions) {
            if (!disposed.has(state)) {
                state.session.dispose();
                disposed.add(state);
            }
        }
        ext.documentSessions.clear();
        ext.sharableSessions.clear();
    }
    function restart() {
        killEverything();
        diagInit();
    }
    function openOutput() {
        ext.outputChannel.show();
    }
    context.subscriptions.push(vscode.workspace.onDidChangeConfiguration((event) => {
        if (event.affectsConfiguration('ghcSimple'))
            restart();
    }), { dispose: killEverything }, vscode.commands.registerCommand('vscode-ghc-simple.restart', restart), vscode.commands.registerCommand('vscode-ghc-simple.openOutput', openOutput));
    vscode.workspace.onDidChangeWorkspaceFolders(() => {
        restart();
    });
}
exports.activate = activate;
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map