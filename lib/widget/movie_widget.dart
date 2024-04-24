import 'package:flutter/material.dart';
import 'package:pbb_sqflite/model/db_model.dart';

class CreateMovieWidget extends StatefulWidget {
  final Model? movie;
  final ValueChanged<String> titleOnSubmit;
  // final ValueChanged<String> descriptionOnSubmit;

  const CreateMovieWidget({
    Key? key,
    this.movie,
    required this.titleOnSubmit,
  }) : super(key: key);

  @override
  State<CreateMovieWidget> createState() => _CreateMovieWidgetState();
}

class _CreateMovieWidgetState extends State<CreateMovieWidget> {
  final controller = TextEditingController();
  final imageC = TextEditingController();
  final descriptionC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = widget.movie?.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;
    return AlertDialog(
      title: Text(isEditing? 'Edit Movie' : 'Add Movie'),
      content: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: controller,
                decoration: const InputDecoration(hintText: 'Title'),
                validator: (value) => value != null && value.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                autofocus: true,
                controller: imageC,
                decoration: const InputDecoration(hintText: 'Image'),
                validator: (value) => value != null && value.isEmpty ? 'Image is required' : null,
              ),
              TextFormField(
                autofocus: true,
                controller: descriptionC,
                decoration: const InputDecoration(hintText: 'Description'),
                validator: (value) => value != null && value.isEmpty ? 'Description is required' : null,
              )
            ],
          )
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                widget.titleOnSubmit(controller.text);
              }
            },
            child: const Text('OK')
        ),
      ],
    );
  }
}
