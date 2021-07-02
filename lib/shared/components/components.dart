import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  @required Function function,
  @required String text,
  bool isUpperCase = true,
}) =>
    Container(
      width: width,
      color: background,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required String text,
  Function onSubmit,
  Function onChange,
  @required Function validate,
  Function onTap,
  @required IconData prefix,
  IconData suffix,
  bool isPassword = false,
  bool isClickable = false,
  Function suffixpressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      // or obscureText: isPassword ? true: false ,
      // means : isPassword have a value or not
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixpressed, icon: Icon(suffix))
            : null,
      ),
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      onTap: onTap,

      readOnly: isClickable,
    );
    final task_Color = Color(0xffEF9731);

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor: task_Color,
              child: Text(
                '${model['time']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5 ,color: Colors.white),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight:FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              icon: Icon(Icons.fact_check_rounded),
              iconSize: 40,
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: "done", id: model['id']);

                print(model);
              },
              color: task_Color,
            ),
            IconButton(
              icon: Icon(Icons.archive_rounded),
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: "archived", id: model['id']);

                print(model);
              },
              color: task_Color,
              iconSize: 40,
            ),
          ],
        ),
      ),
    );

Widget noTaskBuilder({
  @required List<Map> tasks,
  @required String text,
}) {
  return ConditionalBuilder(
    condition: tasks.length > 0,
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey),
          )
        ],
      ),
    ),
    builder: (context) => ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: task_Color,
        ),
      ),
      itemCount: tasks.length,
    ),
  );
}
