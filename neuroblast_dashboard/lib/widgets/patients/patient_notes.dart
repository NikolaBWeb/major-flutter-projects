import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/widgets/patients/hoverable_list_tile.dart';

class PatientNotes extends StatefulWidget {
  const PatientNotes({
    required this.patientId,
    super.key,
  });

  final String patientId;

  @override
  State<PatientNotes> createState() => _PatientNotesState();
}

class _PatientNotesState extends State<PatientNotes> {
  final TextEditingController _noteController = TextEditingController();
  bool _isAddingNote = false;
  bool isSending = false;
  bool isNoteAdding =
      false; // This will control when to display the updated list

  Future<void> addPatientNote() async {
    final noteText = _noteController.text.trim();
    if (noteText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a note before adding')),
      );
      return;
    }

    setState(() {
      _isAddingNote = true;
      isNoteAdding = true; // Prevent old notes from displaying
      isSending = true;
    });

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adding note...')),
      );
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.patientId)
          .collection('notes')
          .add({
        'note': noteText,
        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Note added successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }

      _noteController.clear(); // Clear the text field
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add note: $e')),
        );
      }
    } finally {
      setState(() {
        _isAddingNote = false;
        isSending = false;
        isNoteAdding = false; // Re-enable the display of the updated list
      });
      if (mounted) {
        Navigator.pop(context); // Close the modal
      }
    }
  }

  Future<void> deletePatientNote(String noteId) async {
    setState(() {
      isSending = true;
    });
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.patientId)
        .collection('notes')
        .doc(noteId)
        .delete();
    setState(() {
      isSending = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note deleted successfully'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Patient Notes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.note,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // While adding a note, show loading indicator instead of old list
              if (isNoteAdding)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              else
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('patients')
                        .doc(widget.patientId)
                        .collection('notes')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No notes available.'),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final noteDoc = snapshot.data!.docs[index];
                          final note = noteDoc['note'] as String;
                          final createdAt = noteDoc['createdAt'] as Timestamp;

                          return HoverableListTile(
                            note: note,
                            createdAt: createdAt,
                            onDelete: () {
                              deletePatientNote(noteDoc.id);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter setModalState) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextField(
                                controller: _noteController,
                                decoration: const InputDecoration(
                                  hintText: 'Add a new note',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: isSending
                                    ? null
                                    : () {
                                        setModalState(() {
                                          isSending = true;
                                        });
                                        addPatientNote().then((_) {
                                          setModalState(() {
                                            isSending = false;
                                          });
                                        });
                                      },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(120, 40),
                                  backgroundColor: Colors.green,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSending)
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      isSending ? 'Adding...' : 'Add Note',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .appBarTheme
                                        .titleTextStyle
                                        ?.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: const Icon(
                Icons.note_add_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
