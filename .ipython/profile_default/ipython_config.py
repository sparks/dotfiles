c = get_config()

c.TerminalIPythonApp.extensions = [
    'line_profiler_ext',
]
c.InteractiveShellApp.extensions = [
    'line_profiler_ext',
]
