import 'package:flutter/material.dart';
import 'package:supermapper_app/configuration/feedback_category.dart';

class AddSpotStepDetails extends StatefulWidget {
  const AddSpotStepDetails({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.category,
    required this.onCategoryChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final FeedbackCategory? category;
  final ValueChanged<FeedbackCategory?> onCategoryChanged;

  @override
  State<AddSpotStepDetails> createState() => _AddSpotStepDetailsState();
}

class _AddSpotStepDetailsState extends State<AddSpotStepDetails> {
  final _descriptionFocus = FocusNode();

  @override
  void dispose() {
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      // Un tap en dehors des champs ferme le clavier
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        // Le clavier se ferme aussi quand on fait défiler
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about this spot',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Give it a clear name and say what makes it worth a visit.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),

           Listener(
            // Ferme le clavier du champ Title avant d'ouvrir la liste
            onPointerDown: (_) => FocusScope.of(context).unfocus(),
            child: DropdownMenu<FeedbackCategory>(
              initialSelection: widget.category,
              expandedInsets: EdgeInsets.zero, // pleine largeur, menu aligné sur le champ
              label: const Text('Category'),
              hintText: 'Select a category',
              requestFocusOnTap: false, // simple sélection, pas de saisie ni de clavier
              enableFilter: false,
              menuHeight: 280,
              leadingIcon: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: widget.category == null
                      ? const Icon(Icons.category_outlined)
                      : Text(
                          widget.category!.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                ),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
                elevation: const WidgetStatePropertyAll(4),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              dropdownMenuEntries: FeedbackCategory.values
                  .map(
                    (c) => DropdownMenuEntry(
                      value: c,
                      label: c.label,
                      leadingIcon: Text(
                        c.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
              onSelected: widget.onCategoryChanged,
            ),
          ),
            const SizedBox(height: 16),

            TextField(
              controller: widget.titleController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              maxLength: 60,
              onSubmitted: (_) => _descriptionFocus.requestFocus(),
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g. Hidden rooftop bar',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: widget.descriptionController,
              focusNode: _descriptionFocus,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 4,
              maxLines: 8,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'What can people do here? Any tips?',
                hintStyle: TextStyle(color: Colors.grey),
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
