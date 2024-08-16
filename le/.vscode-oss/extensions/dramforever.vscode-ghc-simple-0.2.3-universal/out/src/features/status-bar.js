"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.StatusBar = void 0;
const vscode = require("vscode");
class StatusBar {
    constructor(documentSessions) {
        this.documentSessions = documentSessions;
        this.map = new Map();
        this.disposedSet = new WeakSet();
        this.busyCount = 0;
        this.focusedGhci = null;
        this.bar = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left);
        this.bar.tooltip = 'GHC - Open Output';
        this.bar.command = "vscode-ghc-simple.openOutput";
        this.editorListener =
            vscode.window.onDidChangeActiveTextEditor(this.handleSwitchEditor.bind(this));
        this.configListener = vscode.workspace.onDidChangeConfiguration(this.updateDisplay.bind(this));
        this.updateDisplay();
    }
    updateDisplay() {
        const prefix = vscode.workspace.getConfiguration('ghcSimple.statusBar').get('prefix');
        const indicator = this.busyCount > 0 ? "$(sync~spin)"
            : this.map.size > 0 ? "$(primitive-square)"
                : null;
        const counter = this.map.size > 1 && `(${this.busyCount}/${this.map.size})`;
        const theGhci = this.focusedGhci
            || (this.map.size == 1 ? [...this.map.keys()][0] : null);
        const theStatus = theGhci && this.map.get(theGhci);
        const info = theStatus && theStatus.status == 'busy' && theStatus.info;
        this.bar.text = [prefix, counter, indicator, info]
            .filter(x => x).join(" ");
    }
    update(ghci, status) {
        // Failsafe: Ignore updates from defunct GhciManager
        if (this.disposedSet.has(ghci))
            return;
        const oldBusy = this.map.has(ghci)
            ? +(this.map.get(ghci).status == 'busy')
            : 0;
        const newBusy = +(status.status == 'busy');
        this.busyCount += newBusy - oldBusy;
        this.map.set(ghci, status);
        this.bar.show();
        this.updateDisplay();
    }
    handleSwitchEditor(editor) {
        if (this.documentSessions.has(editor.document)) {
            const session = this.documentSessions.get(editor.document);
            if (this.map.has(session.ghci))
                this.focusedGhci = session.ghci;
            else
                this.focusedGhci = null;
            this.updateDisplay();
        }
    }
    remove(ghci) {
        this.disposedSet.add(ghci);
        if (!this.map.has(ghci))
            return;
        this.busyCount -= +(this.map.get(ghci).status == 'busy');
        this.map.delete(ghci);
        if (this.focusedGhci == ghci)
            this.focusedGhci = null;
        this.updateDisplay();
    }
    dispose() {
        this.bar.dispose();
        this.editorListener.dispose();
        this.configListener.dispose();
    }
}
exports.StatusBar = StatusBar;
//# sourceMappingURL=status-bar.js.map