import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:search/Patients%20class/patient.dart';
import 'package:search/treatement_records_page.dart';
import 'package:search/Widgets/Voicett.dart';
import 'treatement.dart';
import 'package:xml/xml.dart';
import 'Widgets/Drawerwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'OCR.dart';

String dent = '';

class TreatmentChart extends StatefulWidget {
  final Function(Treatement) addtreat;
  final Patient patient;
  const TreatmentChart({super.key, required this.addtreat, required this.patient});

  @override
  State<TreatmentChart> createState() => _TreatmentChartState();
}

class _TreatmentChartState extends State<TreatmentChart> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController natureIntervController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController doitController = TextEditingController();
  final TextEditingController recuController = TextEditingController();

  void populateFormFields(Map<String, String> data) {
    setState(() {
      dateController.text = data['Date'] ?? '';
      dent = data['Dent'] ?? '';
      natureIntervController.text = data['Nature des interventions'] ?? '';
      doitController.text = data['Doit'] ?? '';
      recuController.text = data['Reçu'] ?? '';
    });
  }

  void navigateToOCR() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OCR(
          onDataCollected: populateFormFields,
        ),
      ),
    );

    if (result != null) {
      populateFormFields(result);
    }
  }

  bool isValidDate(String input) {
    // Check yyyy-mm-dd format
    final regExp1 = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (regExp1.hasMatch(input)) {
      return true;
    }

    // Check yyyy/mm/dd format
    final regExp2 = RegExp(r'^\d{4}/\d{2}/\d{2}$');
    if (regExp2.hasMatch(input)) {
      return true;
    }

    return false;
  }

  String? dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Date';
    }
    if (!isValidDate(value)) {
      return 'Please enter a valid Date (yyyy-mm-dd or yyyy/mm/dd)';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    dateController.addListener(() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }
    });
    natureIntervController.addListener(() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }
    });
    notesController.addListener(() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }
    });
    doitController.addListener(() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }
    });
    recuController.addListener(() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }
    });
  }

  void _showdatepicker() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
    );
    if (selectedDate != null) {
      setState(() {
        final formattedDate =
            '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
        dateController.text = formattedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String notes = notesController.text;
      String natureIntv = natureIntervController.text;
      String doit = doitController.text;
      String recu = recuController.text;
      String treatDate = dateController.text;

      Treatement newTreat = Treatement(
        null,
        DateTime.parse(treatDate.replaceAll('/', '-')),
        dent,
        natureIntv,
        notes,
        int.parse(doit),
        int.parse(recu),
        widget.patient.id,
      );

      FirebaseFirestore.instance
          .collection('Patients')
          .doc(widget.patient.id)
          .collection('treatements')
          .add(newTreat.toFirestore())
          .then((docRef) {
        newTreat.id = docRef.id;
        widget.addtreat(newTreat);
        Navigator.pop(context, true);
      }).catchError((error) {
        print("Error adding document: $error");
        Navigator.pop(context, false);
      });

      dateController.clear();
      natureIntervController.clear();
      notesController.clear();
      doitController.clear();
      recuController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check your inputs'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF9FF),
      appBar: AppBar(
        title: const Text('Treatment Chart'),
        backgroundColor: const Color(0xff91C8E4),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 30.0),
            onPressed: navigateToOCR,
            icon: const Icon(Icons.camera_alt),
            iconSize: 30,
          ),
        ],
      ),
      drawer: Drawerw(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Foo(
                  asset: 'assets/teeth.svg',
                  idToString: adultIdToString,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: _showdatepicker,
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Treatment Date (YYYY-MM-DD or YYYY/MM/DD)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: dateValidator,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: natureIntervController,
                        decoration: InputDecoration(
                          labelText: 'Nature of Intervention',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter nature of intervention';
                          }
                          if (value.startsWith(' ')) {
                            return 'Nature of intervention cannot start with a space';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                            return 'Please enter valid nature of intervention';
                          }
                          return null;
                        },
                      ),
                    ),
                    Voicett(controller: natureIntervController),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: notesController,
                        decoration: InputDecoration(
                          labelText: 'Note',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a Note';
                          }
                          if (value.startsWith(' ')) {
                            return 'Note cannot start with a space';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                            return 'Please enter valid Note';
                          }
                          return null;
                        },
                      ),
                    ),
                    Voicett(controller: notesController),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: doitController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Charge',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Your Charge amount';
                          }
                          return null;
                        },
                      ),
                    ),
                    Voicett(controller: doitController),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: recuController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Payment',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Your Payment amount';
                          }
                          return null;
                        },
                      ),
                    ),
                    Voicett(controller: recuController),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff91C8E4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: const TextStyle(color: Colors.white), // Set the text color to white
                    ),
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
      elevation: 0, // Remove elevation to avoid shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.transparent, // Set the card background color to transparent
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: FittedBox(
          child: SizedBox.fromSize(
            size: data.size,
            child: Stack(
              children: [
                for (final MapEntry<int, Tooth> entry in data.teeth.entries)
                  Positioned.fromRect(
                    rect: entry.value.rect,
                    child: Tooltip(
                      message: widget.idToString(entry.key),
                      textAlign: TextAlign.center,
                      preferBelow: false,
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.white54),
                        ),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 750),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: entry.value.selected ? Colors.teal.shade400 : Colors.white, // Set color to white for unselected teeth
                          shadows: entry.value.selected
                              ? [const BoxShadow(blurRadius: 4, offset: Offset(0, 6))]
                              : null,
                          shape: ToothBorder(entry.value.path),
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            splashColor: entry.value.selected ? Colors.white : Colors.teal.shade400,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                entry.value.selected = !entry.value.selected;
                                dent = entry.key.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
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
                          style: Theme.of(context).textTheme.titleLarge!,
                          textAlign: TextAlign.center,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: selected.isNotEmpty ? 1 : 0,
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                  horizontal: BorderSide(width: 3, color: Colors.black26),
                                ),
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                children: selected,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
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
  final Path path;

  const ToothBorder(this.path);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return path.shift(rect.topLeft);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return path.shift(rect.topLeft);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black54;
    canvas.drawPath(path.shift(rect.topLeft), paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}

String adultIdToString(int id) {
  if (id < 0 || id > 36) {
    return '';
  }
  final number = id;
  return 'Tooth #$number';
}
