with open('interface_pl.html', 'r') as input, open('interface-new.js', 'w') as output:
    contents = input.read()
    cleaned_contents = contents.replace('"', '\\"').replace('\n', '')
    js_contents = '''
BlockPyInterface = "{interface_code}";
'''.format(interface_code=cleaned_contents)
    output.write(js_contents)