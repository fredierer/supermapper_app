import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

class FilterButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();

}

class _FilterButtonState extends State<FilterButton> {
  bool _isChecked = true;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
          print(_isChecked);
        });
        widget.onPressed();
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: _isChecked ? widget.color : widget.color.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordure subtile
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, size:40, color: _isChecked ? Colors.black : Colors.grey.shade800,),
            Text(widget.label, style: TextStyle(fontSize: 10, color: _isChecked ? Colors.black : Colors.grey.shade800),)
          ],
        ),
      ),
    );
  }
}