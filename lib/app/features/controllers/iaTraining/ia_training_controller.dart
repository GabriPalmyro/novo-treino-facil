import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tabela_treino/app/features/models/exercises/exercises.dart';
import 'package:tabela_treino/app/features/models/iaTraining/ia_training_create_props.dart';
import 'package:tabela_treino/app/features/models/iaTraining/ia_training_result.dart';

class IATrainingController extends ChangeNotifier {
  bool _isLoading = false;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get getIsLoading => _isLoading;

  IaTrainingCreateProps props = IaTrainingCreateProps();

  IATrainingResult? result;

  void setName(String value) {
    props = props.copyWith(name: value);
    notifyListeners();
  }

  void setGoal(String value) {
    props = props.copyWith(goal: value);
    notifyListeners();
  }

  void setGroups(List<String> value) {
    props = props.copyWith(groups: value);
    notifyListeners();
  }

  void setTime(String value) {
    props = props.copyWith(time: value);
    notifyListeners();
  }

  void setWeight(String value) {
    props = props.copyWith(weight: value);
    notifyListeners();
  }

  void setHeight(String value) {
    props = props.copyWith(height: value);
    notifyListeners();
  }

  void setPhysicalCondition(String value) {
    props = props.copyWith(physicalCondition: value);
    notifyListeners();
  }

  void clear() {
    props = IaTrainingCreateProps();
    notifyListeners();
  }

  Future<void> createIaTraining({
    required List<Exercise> groupExercises,
    required String sex,
    // required String dateOfBirth,
  }) async {
    if (props.name != null && props.name!.isEmpty) {
      throw Exception("Name is required");
    }

    if (props.groups == null || props.groups!.isEmpty) {
      throw Exception("At least one group is required");
    }

    if (props.time == null || props.time!.isEmpty) {
      throw Exception("Time is required");
    }

    if (props.weight == null || props.weight!.isEmpty) {
      throw Exception("Weight is required");
    }

    if (props.height == null || props.height!.isEmpty) {
      throw Exception("Height is required");
    }

    if (props.physicalCondition == null || props.physicalCondition!.isEmpty) {
      throw Exception("Physical condition is required");
    }

    // All validations passed, proceed with creating the IA training
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception("API key not found");
    }

    // Simulate a delay to show the loading indicator
    setLoading(true);

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'application/json',
      ),
    );

    final chat = model.startChat(history: []);
    final message = '''
      Create a training plan for a person with the following characteristics:
      - Name of training: ${props.name}
      - Goal of training: ${props.goal}
      - Groups selected for training: ${props.groups!.join(', ')}
      - Time available for training: ${props.time}
      - Weight of the person: ${props.weight}
      - Height of the person: ${props.height}
      - Physical condition of the person: ${props.physicalCondition}
      - Gender of the person: $sex
      And now there all all the exercises available for the training:
      ${groupExercises.map((item) => item.toMap()).toList()}

      You can ONLY USE the exercises that i sent to you, and you need to create a training plan with them, not using any other exercises.
      All the video links are available in the exercises, you can use them to show the user how to do the exercise.

      The "peso" field is the weight that the person should use for the exercise and should be returned as integer.

      This is the json format that I need to receive to create the training plan.

      {
        "title": "Example Title",
        "description": "Example description",
        "exercises": [
            {
                "title": "Example Exercise 1",
                "muscleId": "pernas",
                "obs": "Example observation",
                "series": "3",
                "reps": "10",
                "peso": 10,
                "set_type": "uniset",
                "video": "video_from_selected_exercise"
            },
            {
                "title": "Example Exercise 2",
                "muscleId": "costas",
                "obs": "Example observation",
                "series": "5",
                "reps": "25",
                "peso": 10,
                "set_type": "uniset",
                "video": "video_from_selected_exercise"
            },
            {
                "title1": "Example Exercise 1 on Biset",
                "title2": "Example Exercise 2 on Biset",
                "set_type": "biset",
                "sets": [
                    {
                        "title": "Example Exercise 1 on Biset",
                        "muscleId": "costas",
                        "obs": "Example observation",
                        "series": "5",
                        "reps": "25",
                        "peso": 45,
                        "set_type": "uniset",
                        "video": "video_from_selected_exercise"
                    },
                    {
                        "title": "Example Exercise 2 on Biset",
                        "muscleId": "pernas",
                        "obs": "Example observation",
                        "series": "3",
                        "reps": "10",
                        "peso": 120,
                        "set_type": "uniset",
                        "video": "video_from_selected_exercise"
                    }
                ]
            }
        ]
    }
    ''';

    log('Message: $message', name: 'IATrainingController - createIaTraining');

    final content = Content.text(message);

    try {
      final response = await chat.sendMessage(content);
      log('Response: ${response.text}', name: 'IATrainingController - createIaTraining');

      if (response.text == null) {
        throw Exception("Failed to create the IA training");
      }

      result = IATrainingResult.fromJson(
        jsonDecode(response.text!),
      );

      setLoading(false);
    } catch (e) {
      setLoading(false);
      throw Exception("Failed to create the IA training: $e");
    }
  }

  Future<void> createWorksheetFromIATraining() async {}
}
