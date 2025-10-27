import 'package:flutter/material.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/screens/signin/widgets/department_scroll_down.dart';
import 'package:geumpumta/widgets/custom_search_bar/custom_search_bar.dart';
import '../../widgets/back_and_progress/back_and_progress.dart';
import '../../widgets/custom_button/custom_button.dart';

class SignIn3Screen extends StatefulWidget {
  const SignIn3Screen({super.key});

  @override
  State<SignIn3Screen> createState() => _SignIn3ScreenState();
}

class _SignIn3ScreenState extends State<SignIn3Screen> {
  final TextEditingController _searchController = TextEditingController();
  String department = Department.none.koreanName;

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackAndProgress(percent: 0.6),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      '학과 선택',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  CustomSearchBar(
                    controller: _searchController,
                    value: _searchController.text,
                    onActive: ()=>print(_searchController.text),
                  ),
                  Expanded(child: DepartmentScrollDown(onDepartmentSelected: (dept){
                    print('선택된 학과: ${dept.koreanName}');
                    setState(() {
                      department = dept.koreanName;
                    });
                  },
                  selected: department,)),
                  // DepartmentScrollDown(),
                ],
              ),
            ),
            CustomButton(
              buttonText: '확인',
              onActive: department!=Department.none.koreanName,
              onPressed: () => Navigator.pushNamed(context, '/main'),
            ),
          ],
        ),
      ),
    );
  }
}
