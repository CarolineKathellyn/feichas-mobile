import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendamento de Eventos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EventSchedulerPage(),
    );
  }
}

class Event {
  final String name;
  final DateTime date;
  final String time;

  Event({
    required this.name,
    required this.date,
    required this.time,
  });
}

class EventSchedulerPage extends StatefulWidget {
  const EventSchedulerPage({super.key});

  @override
  State<EventSchedulerPage> createState() => _EventSchedulerPageState();
}

class _EventSchedulerPageState extends State<EventSchedulerPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final List<Event> _events = [];

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventTimeController.dispose();
    super.dispose();
  }

  void _addEvent() {
    if (_eventNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o nome do evento')),
      );
      return;
    }

    setState(() {
      _events.add(Event(
        name: _eventNameController.text,
        date: _selectedDay,
        time: _eventTimeController.text.isEmpty 
            ? 'Sem horário' 
            : _eventTimeController.text,
      ));
      _eventNameController.clear();
      _eventTimeController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento adicionado com sucesso!')),
    );
  }

  void _deleteEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento removido')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Agendamento de Eventos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const Divider(),
          
          // Input Fields
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _eventNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Evento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _eventTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Horário (ex: 14:30)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                    hintText: 'HH:MM',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addEvent,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Evento'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          
          // Events List
          Expanded(
            child: _events.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_note, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum evento agendado',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            event.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(event.date),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16),
                                  const SizedBox(width: 4),
                                  Text(event.time),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEvent(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
