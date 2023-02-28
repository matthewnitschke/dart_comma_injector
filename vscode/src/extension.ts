import * as vscode from 'vscode';
import {join} from 'path';
import { exec } from 'node:child_process';

export function activate(context: vscode.ExtensionContext) {
	
	let configuredExecutable = vscode.workspace.getConfiguration('dartCommaInjector')
		.get('executable') as string;

	let postRunExecutable = vscode.workspace.getConfiguration('dartCommaInjector')
		.get('postRunExecutable') as string;
		
	let disposable = vscode.commands.registerCommand('dartCommaInjector.inject', () => {
		const editor = vscode.window.activeTextEditor;
		if (editor == null) return;

		const cursorOffset = editor.document.offsetAt(editor.selection.active);

		let params = [editor.document.uri.fsPath, '--offset', cursorOffset];
		
		let command;
		if (configuredExecutable != null) {
			command = [configuredExecutable, ...params].join(' ');
		} else {
			command = ['dart', join(__dirname, '../../', 'cli/bin/main.dart'), ...params].join(' ');
		}

		exec(
			command,
			() => {
				if (postRunExecutable != null) {
					exec(postRunExecutable.replace('<filepath>', editor.document.uri.fsPath));
				}
			}
		);
	});

	context.subscriptions.push(disposable);
}

// This method is called when your extension is deactivated
export function deactivate() {}
