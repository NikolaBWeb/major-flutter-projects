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

  Future<void> addPatientNote() async {
    if (_noteController.text.isEmpty) return;

    setState(() {
      _isAddingNote = true;
      isSending = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adding note...'),
      ),
    );

    await FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.patientId)
        .collection('notes')
        .add({
      'note': _noteController.text,
      'createdAt': Timestamp.now(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note added successfully'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    setState(() {
      _isAddingNote = false;
      _noteController.clear(); // Clear the note field after adding
      isSending = false;
    });

    Navigator.pop(context); // Close the bottom sheet
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
  }

  @override
  void dispose() {
    _noteController.dispose(); // Clean up controller when widget is disposed
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Patient Notes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.note,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .doc(widget.patientId)
                      .collection('notes')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No notes available.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final note = doc['note'] as String;
                        final createdAt = doc['createdAt'] as Timestamp;
                        final noteId = doc.id;

                        return HoverableListTile(
                          note: note,
                          createdAt: createdAt,
                          onDelete: () => deletePatientNote(noteId),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextField(
                                controller: _noteController,
                                decoration: const InputDecoration(
                                  hintText: 'Add a new note',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 10),
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
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
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
