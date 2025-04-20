import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

const _template = """# heading1
## heading2
### heading3
#### heading4
##### heading5
###### heading6

paragraph content line 1  
paragraph content line 2  
paragraph content line 3

- unordered list item1
- unordered list item2
- unordered list item3

1. ordered list item1
2. ordered list item2
3. ordered list item3

_strong 1_

*strong 2*

__emphasis 1__

**emphasis 2**

~delete 1~

~~delete 2~~

`inline code`

```
code block 1
```

    code block 2 (indent with at least 4 spaces)

[link](https://example.com)

![image](https://example.com)

horizontal rules

___

_ _ _

---

- - -

***

* * *
""";

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExampleState();
}

class _ExampleState extends State<ExamplePage> {
  String _content = _template;

  final TextEditingController _textEditingController =
      TextEditingController(text: _template);

  void handleReset() {
    _textEditingController.text = _template;
    setState(() {
      _content = _template;
    });
  }

  void handleClear() {
    _textEditingController.clear();
    setState(() {
      _content = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Text(
                  'BadMarkdown',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(onPressed: handleReset, child: const Text('Reset')),
                TextButton(onPressed: handleClear, child: const Text('Clear')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: CupertinoTextField.borderless(
                      controller: _textEditingController,
                      padding: EdgeInsets.zero,
                      maxLines: null,
                      expands: true,
                      onChanged: (s) {
                        setState(() {
                          _content = s;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: SingleChildScrollView(child: GptMarkdown(_content)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
