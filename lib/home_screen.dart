import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  final picker = ImagePicker();
  final ApiService _apiService = ApiService();
  String _analysisResult = "사진을 찍거나 업로드하면 AI가 칼로리를 분석합니다.";
  bool _isLoading = false;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _analyzeImage();
      }
    });
  }

  Future _analyzeImage() async {
    setState(() {
      _isLoading = true;
      _analysisResult = "AI가 분석 중입니다...";
    });

    // 실제로는 이미지 인식(Vision) 모델을 쓰거나, 텍스트 모델인 Nemotron에 설명을 보냅니다.
    // 여기서는 텍스트 모델 인터페이스 예시를 위해 임시 설명을 보냅니다.
    final result = await _apiService.analyzeFood("업로드된 음식 사진(이미지 데이터 기반 분석 필요)");
    
    setState(() {
      _analysisResult = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("Workout AI Manager", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildImageCard(),
            SizedBox(height: 20),
            _buildResultCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPicker(context),
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("오늘의 칼로리", style: TextStyle(color: Colors.white70, fontSize: 16)),
              Text("1,450 / 2,200 kcal", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(Icons.directions_run, color: Colors.white, size: 40),
        ],
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: _image == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text("음식 사진을 추가해 주세요", style: TextStyle(color: Colors.grey)),
              ],
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(_image!, fit: BoxFit.cover),
            ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("분석 결과", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
          SizedBox(height: 10),
          _isLoading 
            ? Center(child: CircularProgressIndicator())
            : Text(_analysisResult, style: TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('갤러리에서 선택'),
                    onTap: () {
                      getImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('카메라로 촬영'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
