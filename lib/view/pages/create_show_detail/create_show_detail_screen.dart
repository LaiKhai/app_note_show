import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import '../home/home_page.dart';
import 'index.dart';

class CreateShowDetailScreen extends StatefulWidget {
  const CreateShowDetailScreen({
    required CreateShowDetailBloc createShowDetailBloc,
    super.key,
    required this.controller,
  }) : _createShowDetailBloc = createShowDetailBloc;

  final CreateShowDetailBloc _createShowDetailBloc;
  final DateRangePickerController controller;
  @override
  CreateShowDetailScreenState createState() {
    return CreateShowDetailScreenState();
  }
}

class CreateShowDetailScreenState extends State<CreateShowDetailScreen> {
  CreateShowDetailScreenState();

  final EventCalendarImpl eventCalendarImpl = di.get();

  final _formKey = GlobalKey<FormState>();
  final titleFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final decriptionFocusNode = FocusNode();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final decriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.controller.selectedDates != null) {
      widget.controller.selectedDates!.sort();
    }
    _load();
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    decriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateShowDetailBloc, CreateShowDetailState>(
        bloc: widget._createShowDetailBloc,
        builder: (
          BuildContext context,
          CreateShowDetailState currentState,
        ) {
          if (currentState is UnCreateShowDetailState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorCreateShowDetailState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    onPressed: _load,
                    child: const Text('reload'),
                  ),
                ),
              ],
            ));
          }
          if (currentState is InCreateShowDetailState) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (titleFocusNode.hasFocus ||
                      priceFocusNode.hasFocus ||
                      decriptionFocusNode.hasFocus) {
                    titleFocusNode.unfocus();
                    priceFocusNode.unfocus();
                    decriptionFocusNode.unfocus();
                  }
                });
              },
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(AppSize.s16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: title
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSize.s16),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          controller: titleController,
                          focusNode: titleFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          autofillHints: const [AutofillHints.username],
                          decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: ColorName.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s8))),
                        ),
                      ),
                      //TODO: prices
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSize.s16),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          controller: priceController,
                          focusNode: priceFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          autofillHints: const [AutofillHints.username],
                          inputFormatters: [
                            CurrencyInputFormatter(
                                thousandSeparator: ThousandSeparator.Period,
                                mantissaLength: 0,
                                trailingSymbol: 'đ')
                          ],

                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Prices',
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: ColorName.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s8))),
                        ),
                      ),
                      //TODO: date time
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSize.s16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                // The validator receives the text that the user has entered.

                                enabled: false,
                                autofillHints: const [AutofillHints.username],
                                decoration: InputDecoration(
                                    hintText: DateFormat('dd/MM/yyyy').format(
                                        widget.controller.selectedDates!.first),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: ColorName.black,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(AppSize.s8))),
                              ),
                            ),
                            const SizedBox(width: AppSize.s10),
                            Expanded(
                              child: TextFormField(
                                // The validator receives the text that the user has entered.

                                enabled: false,
                                autofillHints: const [AutofillHints.username],
                                decoration: InputDecoration(
                                    hintText: DateFormat('dd/MM/yyyy').format(
                                        (widget.controller.selectedDates !=
                                                null)
                                            ? widget
                                                .controller.selectedDates!.last
                                            : widget.controller.selectedDates!
                                                .first),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: ColorName.black,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(AppSize.s8))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //TODO: decription
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSize.s16),
                        child: TextFormField(
                          controller: decriptionController,
                          focusNode: decriptionFocusNode,
                          // The validator receives the text that the user has entered.
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter some text';
                          //   }
                          //   return null;
                          // },
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          autofillHints: const [AutofillHints.username],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: ColorName.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s8))),
                        ),
                      ),
                      //TODO: button submit
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
// Validate returns true if the form is valid, or false otherwise.\
                              final eventCalendar = EventCalendar(
                                  name: titleController.text,
                                  price: priceController.text,
                                  decription: decriptionController.text,
                                  startDate: widget.controller.selectedDates !=
                                          null
                                      ? widget.controller.selectedDates!.first
                                      : DateTime.now(),
                                  endDate: (widget.controller.selectedDates !=
                                          null)
                                      ? widget.controller.selectedDates!.last
                                      : widget.controller.selectedDates!.first,
                                  listDate: widget.controller.selectedDates!,
                                  isPaid: false);
                              await eventCalendarImpl
                                  .createEventCalendar(eventCalendar);

                              ScaffoldMessenger.of(navigatorKey.currentContext!)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text('Send data successfully')),
                              );
                              GoRouter.of(navigatorKey.currentContext!)
                                  .pushReplacement(HomePage.routeName);
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._createShowDetailBloc.add(LoadCreateShowDetailEvent());
  }
}
