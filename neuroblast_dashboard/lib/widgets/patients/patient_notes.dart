import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/models/patient/patient.dart';
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
    final noteText = _noteController.text.trim();
    if (noteText.isEmpty) {
      // Show message if note is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a note before adding')),
      );
      return;
    }

    setState(() {
      _isAddingNote = true;
      isSending = true;
    });

    try {
      // Add the note to the "notes" subcollection within the "patients" collection
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.patientId)
          .collection('notes') // Subcollection for notes
          .add({
        'note': noteText,
        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note added successfully')),
        );
      }

      // Clear the text field
      _noteController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add note: $e')),
      );
    } finally {
      setState(() {
        _isAddingNote = false;
        isSending = false;
      });

      Navigator.pop(context); // Close the modal bottom sheet
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
                child: StreamBuilder<QuerySnapshot>(
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
                        final noteDoc = snapshot.data!.docs[index];
                        final note = noteDoc['note'] as String;
                        final createdAt = noteDoc['createdAt'] as Timestamp;

                        return HoverableListTile(
                          note: note,
                          createdAt: createdAt,
                          onDelete: () {
                            deletePatientNote(noteDoc.id); // Delete the note
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
                                // This button is used to add a new patient note
                                // It is disabled when a note is currently
                                // being sent
                                onPressed: isSending
                                    ? null
                                    : () {
                                        // Set the sending state to true when
                                        //the button is pressed
                                        setModalState(() {
                                          isSending = true;
                                        });
                                        // Call the addPatientNote function and
                                        //update the state when it's done
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
