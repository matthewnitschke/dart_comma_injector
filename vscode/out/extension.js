"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
const vscode = require("vscode");
const path_1 = require("path");
const node_child_process_1 = require("node:child_process");
function activate(context) {
    let configuredExecutable = vscode.workspace.getConfiguration('dartCommaInjector')
        .get('executable');
    let postRunExecutable = vscode.workspace.getConfiguration('dartCommaInjector')
        .get('postRunExecutable');
    let disposable = vscode.commands.registerCommand('dart-comma-injector.inject', () => {
        const editor = vscode.window.activeTextEditor;
        if (editor == null)
            return;
        const cursorOffset = editor.document.offsetAt(editor.selection.active);
        let params = [editor.document.uri.fsPath, '--offset', cursorOffset];
        let command;
        if (configuredExecutable != null) {
            command = [configuredExecutable, ...params].join(' ');
        }
        else {
            command = ['dart', (0, path_1.join)(__dirname, '../../', 'cli/bin/main.dart'), ...params].join(' ');
        }
        let afterRunCommand = '';
        const workspaceRootPath = vscode.workspace.workspaceFolders?.[0].uri.fsPath;
        if (postRunExecutable && workspaceRootPath) {
            afterRunCommand = ` && ${postRunExecutable.replace('<filepath>', editor.document.uri.fsPath)}`;
        }
        (0, node_child_process_1.exec)(command + afterRunCommand, { cwd: workspaceRootPath });
    });
    context.subscriptions.push(disposable);
}
exports.activate = activate;
// This method is called when your extension is deactivated
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map