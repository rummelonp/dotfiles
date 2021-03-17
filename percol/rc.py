import os, sys, subprocess
from percol.command import SelectorCommand
from percol.key import SPECIAL_KEYS
from percol.finder import FinderMultiQueryString, FinderMultiQueryRegex, FinderMultiQueryMigemo

## Prompt
percol.view.prompt_replacees["F"] = lambda self, **args: self.model.finder.get_name()

def dynamic_prompt():
    prompt = ''
    if percol.model.finder.__class__ == FinderMultiQueryMigemo:
        prompt += '[Migemo]'
    elif percol.model.finder.__class__ == FinderMultiQueryRegex:
        prompt += '[Regexp]'
    else:
        prompt += '[String]'
    if percol.model.finder.case_insensitive:
        prompt += '[a]'
    else:
        prompt += '[A]'
    prompt += '> %q'
    return prompt

percol.view.__class__.PROMPT = property(lambda self: dynamic_prompt())

## Kill
if sys.platform == 'darwin':
    def copy_end_of_line_as_kill(self):
        subprocess.getoutput('echo ' + self.model.query[self.model.caret:] + ' | pbcopy')
        self.model.query  = self.model.query[:self.model.caret]

    def paste_as_yank(self):
        self.model.insert_string(subprocess.getoutput('pbpaste'))

    SelectorCommand.kill_end_of_line = copy_end_of_line_as_kill
    SelectorCommand.yank = paste_as_yank

## Migemo dict path
FinderMultiQueryMigemo.dictionary_path = next(filter(lambda path: os.path.exists(path), [
    '/opt/homebrew/share/migemo/utf-8/migemo-dict',
    '/usr/local/share/migemo/utf-8/migemo-dict',
    '/usr/share/cmigemo/utf-8/migemo-dict'
]))

## Keymap
# Map backspace
SPECIAL_KEYS.update({
    127: '<backspace>'
})
percol.import_keymap({
    'C-h' : lambda percol: percol.command.delete_backward_char(),
    'C-d' : lambda percol: percol.command.delete_forward_char(),
    'C-k' : lambda percol: percol.command.kill_end_of_line(),
    'C-y' : lambda percol: percol.command.yank(),
    'C-a' : lambda percol: percol.command.beginning_of_line(),
    'C-e' : lambda percol: percol.command.end_of_line(),
    'C-b' : lambda percol: percol.command.backward_char(),
    'C-f' : lambda percol: percol.command.forward_char(),
    'M-f' : lambda percol: percol.command.forward_word(),
    'M-b' : lambda percol: percol.command.backward_word(),
    'M-d' : lambda percol: percol.command.delete_forward_word(),
    'M-h' : lambda percol: percol.command.delete_backward_word(),
    'C-n' : lambda percol: percol.command.select_next(),
    'C-p' : lambda percol: percol.command.select_previous(),
    'C-v' : lambda percol: percol.command.select_next_page(),
    'M-v' : lambda percol: percol.command.select_previous_page(),
    'M-<' : lambda percol: percol.command.select_top(),
    'M->' : lambda percol: percol.command.select_bottom(),
    'C-m' : lambda percol: percol.finish(),
    'C-j' : lambda percol: percol.finish(),
    'C-g' : lambda percol: percol.cancel(),
    'M-c' : lambda percol: percol.command.toggle_case_sensitive(),
    'M-s' : lambda percol: percol.command.toggle_finder(FinderMultiQueryString),
    'M-r' : lambda percol: percol.command.toggle_finder(FinderMultiQueryRegex),
    'M-m' : lambda percol: percol.command.toggle_finder(FinderMultiQueryMigemo)
})
