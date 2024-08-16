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
exports.fileConfig = exports.configKeyToString = void 0;
const child_process = require("child_process");
const vscode = require("vscode");
const utils_1 = require("../utils");
const hie = require("./hie-bios");
const path = require("path");
/**
 * Deterministically serialize a ConfigKey to a string, for use in equality
 * comparison and tables. The format is compatible with JSON.
 *
 * @param key Key object to serialize
 */
function configKeyToString(key) {
    const keys = Object.keys(key).sort();
    const fmt = JSON.stringify.bind(JSON);
    const gen = (k) => `${fmt(k)}:${fmt(key[k])}`;
    return '{' + keys.map(gen).join(',') + '}';
}
exports.configKeyToString = configKeyToString;
const stackOptions = ["--no-terminal", "--color", "never"];
/** Detect if stack is available */
function hasStack() {
    const opts = { timeout: 5000 };
    return new Promise((resolve, reject) => {
        child_process.exec('stack --help', opts, (err, stdout, stderr) => {
            if (err)
                resolve(false);
            else
                resolve(true);
        });
    });
}
/**
 * Configuration for a single file
 *
 * @param cwd The working directory associated with the file
 */
function singleConfig(cwd) {
    return __awaiter(this, void 0, void 0, function* () {
        if (yield hasStack()) {
            return {
                key: null,
                command: 'stack exec ghci',
                cwd,
                dependencies: []
            };
        }
        else {
            return {
                key: null,
                command: 'ghci',
                cwd,
                dependencies: []
            };
        }
    });
}
const alreadyShown = new Set();
function handleReplCommandTrust(workspaceUri, replCommand) {
    var _a;
    if (workspaceUri.scheme !== 'file')
        return false;
    const config = vscode.workspace.getConfiguration('ghcSimple', null);
    const insp = (_a = config.inspect('trustedReplCommandConfigs').globalValue) !== null && _a !== void 0 ? _a : {};
    if (insp[workspaceUri.fsPath] === replCommand) {
        return true;
    }
    else {
        if (!alreadyShown.has(workspaceUri.fsPath)) {
            alreadyShown.add(workspaceUri.fsPath);
            vscode.window.showWarningMessage(`This workspace ${workspaceUri.fsPath} wants to run "${replCommand}" to start GHCi.\n\nAllow if you understand this and trust it.`, 'Allow', 'Ignore').then((value) => {
                alreadyShown.delete(workspaceUri.fsPath);
                if (value == 'Allow') {
                    const trusted = config.get('trustedReplCommandConfigs');
                    trusted[workspaceUri.fsPath] = replCommand;
                    config.update('trustedReplCommandConfigs', trusted, vscode.ConfigurationTarget.Global);
                }
            });
        }
        return false;
    }
}
/** Configuration for a custom command */
function customConfig(replScope, replCommand, workspaceUri) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!handleReplCommandTrust(workspaceUri, replCommand))
            return null;
        if (replCommand.indexOf('$stack_ide_targets') !== -1) {
            const sit = yield utils_1.getStackIdeTargets(workspaceUri);
            replCommand.replace(/\$stack_ide_targets/g, sit.join(' '));
        }
        return {
            key: replScope === 'file'
                ? null
                : { type: 'custom-workspace', uri: workspaceUri.toString() },
            cwd: workspaceUri.fsPath,
            command: replCommand,
            dependencies: []
        };
    });
}
function pathIsPrefix(a, b) {
    const aLevels = a.split(path.sep);
    const bLevels = b.split(path.sep);
    if (aLevels.length > bLevels.length)
        return false;
    for (let i = 0; i < aLevels.length; i++) {
        if (aLevels[i] != bLevels[i])
            return false;
    }
    return true;
}
function hieBiosConfig(workspace, docUri) {
    return __awaiter(this, void 0, void 0, function* () {
        const hieConfig = yield hie.getCradleConfig(workspace.uri);
        const findMulti = (multi) => {
            let found = null;
            for (const cur of multi) {
                const pathUri = vscode.Uri.joinPath(workspace.uri, cur.path);
                if (!pathIsPrefix(pathUri.fsPath, docUri.fsPath)) {
                    continue;
                }
                if (found === null || pathIsPrefix(found.path, pathUri.fsPath)) {
                    found = cur;
                }
            }
            return found;
        };
        const worker = (config) => {
            const makeCabalConfig = (component) => ({
                key: {
                    type: 'hie-bios-cabal',
                    uri: workspace.uri.toString(),
                    component: component.component
                },
                cwd: workspace.uri.fsPath,
                command: ['cabal', 'repl', '--', component.component],
                dependencies: [
                    ...config.dependencies || [],
                    new vscode.RelativePattern(workspace, 'hie.yaml'),
                    new vscode.RelativePattern(workspace, '*.cabal')
                ]
            });
            const makeCabalNullConfig = () => ({
                key: {
                    type: 'hie-bios-cabal-null',
                    uri: workspace.uri.toString()
                },
                cwd: workspace.uri.fsPath,
                command: ['cabal', 'repl'],
                dependencies: [
                    ...config.dependencies || [],
                    new vscode.RelativePattern(workspace, 'stack.yaml'),
                    new vscode.RelativePattern(workspace, 'hie.yaml'),
                    new vscode.RelativePattern(workspace, '*.cabal')
                ]
            });
            const makeStackConfig = (component, defaultStackYaml) => {
                const stackYaml = component.stackYaml || defaultStackYaml;
                const stackYamlOpts = stackYaml ? ['--stack-yaml', stackYaml] : [];
                const componentOpts = component.component ? [component.component] : [];
                return {
                    key: {
                        type: 'hie-bios-stack',
                        uri: workspace.uri.toString(),
                        component: component.component
                    },
                    cwd: workspace.uri.fsPath,
                    command: ['stack', ...stackOptions, 'repl', '--no-load', ...stackYamlOpts, '--', ...componentOpts],
                    dependencies: [
                        ...config.dependencies || [],
                        stackYaml || new vscode.RelativePattern(workspace, 'stack.yaml'),
                        new vscode.RelativePattern(workspace, 'hie.yaml'),
                        new vscode.RelativePattern(workspace, '*.cabal'),
                        new vscode.RelativePattern(workspace, 'package.yaml')
                    ]
                };
            };
            const makeStackNullConfig = () => {
                return {
                    key: {
                        type: 'hie-bios-stack-null',
                        uri: workspace.uri.toString()
                    },
                    cwd: workspace.uri.fsPath,
                    command: ['stack', ...stackOptions, 'repl', '--no-load'],
                    dependencies: [
                        ...config.dependencies || [],
                        new vscode.RelativePattern(workspace, 'hie.yaml'),
                        new vscode.RelativePattern(workspace, '*.cabal'),
                        new vscode.RelativePattern(workspace, 'package.yaml')
                    ]
                };
            };
            const cradle = config.cradle;
            if ('cabal' in cradle) {
                const go = (components) => {
                    const res = findMulti(components);
                    if (res === null) {
                        return null;
                    }
                    else {
                        return makeCabalConfig(res);
                    }
                };
                if (cradle.cabal === null) {
                    return makeCabalNullConfig();
                }
                else if ('components' in cradle.cabal) {
                    return go(cradle.cabal.components);
                }
                else if (Array.isArray(cradle.cabal)) {
                    return go(cradle.cabal);
                }
                else {
                    return makeCabalConfig(cradle.cabal);
                }
            }
            else if ('stack' in cradle) {
                const defaultStackYaml = (cradle.stack && 'stackYaml' in cradle.stack) ? cradle.stack.stackYaml : null;
                const go = (components) => {
                    const res = findMulti(components);
                    if (res === null) {
                        return null;
                    }
                    else {
                        return makeStackConfig(res, defaultStackYaml);
                    }
                };
                if (cradle.stack === null) {
                    return makeStackNullConfig();
                }
                else if ('components' in cradle.stack) {
                    return go(cradle.stack.components);
                }
                else if (Array.isArray(cradle.stack)) {
                    return go(cradle.stack);
                }
                else {
                    return makeStackConfig(cradle.stack, defaultStackYaml);
                }
            }
            else if ('multi' in cradle) {
                const res = findMulti(cradle.multi);
                return worker(res.config);
            }
            else if ('none' in cradle) {
                return null;
            }
        };
        return worker(hieConfig);
    });
}
/** Detect the configuration of a `TextDocument` */
function fileConfig(docUri) {
    return __awaiter(this, void 0, void 0, function* () {
        const workspace = vscode.workspace.getWorkspaceFolder(docUri);
        if (!workspace)
            return singleConfig();
        const config = vscode.workspace.getConfiguration('ghcSimple', workspace.uri);
        const replCommand = config.replCommand;
        const replScope = config.replScope;
        if (replCommand !== '') {
            // Custom REPL command
            return customConfig(replScope, replCommand, workspace.uri);
        }
        const find = (pattern) => __awaiter(this, void 0, void 0, function* () {
            return yield vscode.workspace.findFiles(new vscode.RelativePattern(workspace, pattern));
        });
        if ((yield find('hie.yaml')).length > 0) {
            // hie-bios cradle
            return hieBiosConfig(workspace, docUri);
        }
        const makeCabalConfig = () => ({
            key: {
                type: 'detect-cabal',
                uri: workspace.uri.toString(),
            },
            cwd: workspace.uri.fsPath,
            command: ['cabal', 'v2-repl', 'all'],
            dependencies: [
                new vscode.RelativePattern(workspace, '*.cabal'),
                new vscode.RelativePattern(workspace, 'package.yaml'),
                new vscode.RelativePattern(workspace, 'cabal.project'),
                new vscode.RelativePattern(workspace, 'cabal.project.local')
            ]
        });
        const makeStackConfig = (targets) => ({
            key: {
                type: 'detect-stack',
                uri: workspace.uri.toString(),
            },
            cwd: workspace.uri.fsPath,
            command: ['stack', ...stackOptions, 'repl', '--no-load', ...targets],
            dependencies: [
                new vscode.RelativePattern(workspace, '*.cabal'),
                new vscode.RelativePattern(workspace, 'package.yaml'),
                new vscode.RelativePattern(workspace, 'stack.yaml')
            ]
        });
        if ((yield find('dist-newstyle')).length > 0) {
            return makeCabalConfig();
        }
        if ((yield find('.stack-work')).length > 0
            || (yield find('stack.yaml')).length > 0) {
            try {
                const targets = yield utils_1.getStackIdeTargets(workspace.uri);
                return makeStackConfig(targets);
            }
            catch (e) {
                console.error('Error detecting stack configuration:', e);
                console.log('Trying others...');
            }
        }
        if ((yield find('*.cabal')).length > 0
            || (yield find('cabal.project')).length > 0
            || (yield find('cabal.project.local')).length > 0) {
            return makeCabalConfig();
        }
        return singleConfig();
    });
}
exports.fileConfig = fileConfig;
//# sourceMappingURL=config.js.map