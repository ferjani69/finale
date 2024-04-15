import'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';
class treatementChart extends StatefulWidget {
  const treatementChart({super.key});

  @override
  State<treatementChart> createState() => _treatementChartState();
}

class _treatementChartState extends State<treatementChart> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          width: 16,
          height: 1,
          image: Svg('assets/teeth.svg'),
        ),
        SizedBox(height: 20), // Adjust the spacing between the Image and Foo widget as needed
        Foo(
          asset: 'assets/teeth.svg',
          idToString: adultIdToString,
        ),
      ],
    );
  }

}
typedef Data = ({Size size, Map<int, Tooth> teeth});

class Foo extends StatefulWidget {
  const Foo({
    super.key,
    required this.asset,
    required this.idToString,
  });
  final String asset;
  final String Function(int id) idToString;

  @override
  State<Foo> createState() => _FooState();
}

class _FooState extends State<Foo> {
  Data data = (size: Size.zero, teeth: {});

  @override
  void initState() {
    super.initState();
    loadTeeth(widget.asset).then((value) {
      setState(() => data = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data.size == Size.zero) return const UnconstrainedBox();

    return Card(
      child: FittedBox(
        child: SizedBox.fromSize(
          size: data.size,
          child: Stack(
            children: [
              // teeth
              for (final MapEntry(key: key, value: tooth) in data.teeth.entries)
                Positioned.fromRect(
                  rect: tooth.rect,
                  child: Tooltip(
                    message: 'tooth\n${widget.idToString(key)}',
                    textAlign: TextAlign.center,
                    preferBelow: false,
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.white54)
                      ),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 750),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: tooth.selected? Colors.teal.shade400 : Colors.white,
                        shadows: tooth.selected? [const BoxShadow(blurRadius: 4, offset: Offset(0, 6))] : null,
                        shape: ToothBorder(tooth.path),
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          splashColor: tooth.selected? Colors.white : Colors.teal.shade400,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            print('tooth ${widget.idToString(key)} pressed (id $key)');
                            setState(() => tooth.selected = !tooth.selected);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              // selected teeth list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 150),
                child: Center(
                  child: Builder(
                      builder: (context) {
                        final selected = data.teeth.entries
                            .where((e) => e.value.selected)
                            .map((e) => Text(widget.idToString(e.key)))
                            .toList();
                        return DefaultTextStyle(
                          style: Theme.of(context).textTheme.headlineMedium!,
                          textAlign: TextAlign.center,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: selected.isNotEmpty? 1 : 0,
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(width: 3, color: Colors.black26)
                                ),
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                children: selected,
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Data> loadTeeth(String asset) async {
    final xml = await rootBundle.loadString(asset);

    final doc = XmlDocument.parse(xml);
    final viewBox = doc.rootElement.getAttribute('viewBox')!.split(' ');
    final w = double.parse(viewBox[2]);
    final h = double.parse(viewBox[3]);

    final teeth = doc.rootElement.findAllElements('path');
    print('loaded ${teeth.length} paths');
    return (
    size: Size(w, h),
    teeth: <int, Tooth>{
      for (final tooth in teeth)
        int.parse(tooth.getAttribute('id')!): Tooth(parseSvgPathData(tooth.getAttribute('d')!)),
    },
    );
  }
}

class Tooth {
  Tooth(Path originalPath) {
    rect = originalPath.getBounds();
    path = originalPath.shift(-rect.topLeft);
  }

  late final Path path;
  late final Rect rect;
  bool selected = false;
}

class ToothBorder extends ShapeBorder {
  const ToothBorder(this.path);

  final Path path;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return rect.topLeft == Offset.zero? path : path.shift(rect.topLeft);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black54;
    canvas.drawPath(getOuterPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}

String adultIdToString(int id) {
  final (up, left, number) = switch (id) {
    < 8 => (true, false, 8 - id),
    < 16 => (true, true, id - 8 + 1),
    < 24 => (false, true, 24 - id),
    _ => (false, false, id - 24 + 1),
  };
  return '${up? 'up' : 'down'} ${left? 'left' : 'right'} #$number';
}

String childIdToString(int id) {
  final (up, left, number) = switch (id) {
    < 6 => (true, false, 6 - id),
    < 12 => (true, true, id - 6 + 1),
    < 18 => (false, true, 18 - id),
    _ => (false, false, id - 18 + 1),
  };
  return '${up? 'up' : 'down'} ${left? 'left' : 'right'} #$number';
}