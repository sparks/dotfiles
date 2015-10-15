from IPython.core.magic import register_line_magic
@register_line_magic
def clip(line):
    global_dict = globals()
    if not line in global_dict:
        return
    value = global_dict[line]
    import os    
    os.system("echo '%s' | pbcopy" % str(value))
del clip