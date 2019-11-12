import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trainer_app_flutter/app.dart';
import 'package:trainer_app_flutter/components/custom_card.dart';
import 'package:trainer_app_flutter/models/workout.dart';
import '../../models/history_request.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage(this.workouts);

  final List<Workout> workouts;

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin {
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    // for (var i = 0; i < widget.workouts.length; i++) {
    //   _events.addAll({DateTime.now().add(Duration(days: i)) : [widget.workouts[i]]});
    // }

    _selectedEvents = [];

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    _getDates();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _getDates() async {
    for (var workout in widget.workouts) {
      var response = (await HistoryRequest.fetchHistoryWorkout(workout.sId)).data;
      setState(() {
        for (var item in response) {
          this._events.addAll({DateTime.parse(item.date) : [workout]});
        }
      });
    }
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('A title'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => CustomCard(workout: event, onTap: () => openTraining(context, event)))
          .toList(),
    );
  }

  openTraining(BuildContext context, Workout workout) {
    Navigator.pushNamed(context, TrainingRoute, arguments: {'workout': workout});
  }

  List<Widget> exercisesList(List<String> list) {
    return list.map((title) => Text(title)).toList();
  }
}