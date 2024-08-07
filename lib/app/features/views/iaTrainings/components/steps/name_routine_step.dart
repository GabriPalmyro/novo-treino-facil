import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/button_continue.dart';

class NameRoutineStep extends StatefulWidget {
  const NameRoutineStep({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  State<NameRoutineStep> createState() => _NameRoutineStepState();
}

class _NameRoutineStepState extends State<NameRoutineStep> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Nome da rotina',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          )
              .animate()
              .fade(
                duration: 500.ms,
                curve: Curves.easeInOut,
              )
              .slideY(
                begin: 0.5,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeInOut,
              ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Nome da rotina',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          )
              .animate()
              .fade(
                duration: 500.ms,
                curve: Curves.easeInOut,
              )
              .slideY(
                begin: 0.5,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeInOut,
              ),
          Expanded(child: SizedBox()),
          ButtonContinue(title: 'Continuar', onTap: widget.onContinue)
              .animate()
              .fade(
                duration: 500.ms,
                curve: Curves.easeInOut,
              )
              .slideY(
                begin: 0.5,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeInOut,
              ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 24,
          )
        ],
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
