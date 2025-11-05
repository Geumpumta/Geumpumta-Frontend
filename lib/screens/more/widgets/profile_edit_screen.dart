import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nicknameController = TextEditingController(text: '학과대표는나');
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _photoChanged = false;
  bool _saveCompleted = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _photoChanged = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  void _checkDuplication() {
    // 중복 확인, 추후 API 연동시 다시 해야함!
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('사용 가능한 닉네임입니다.')),
    );
  }

  void _saveProfile() {
    // 저장 로직도 마찬가지
    setState(() {
      _saveCompleted = true;
      _photoChanged = false;
    });

    // 2초 지연 후 메시지 숨기기
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _saveCompleted = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0BAEFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '프로필 수정',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildProfilePictureSection(),
            const SizedBox(height: 40),
            _buildNicknameSection(),
            const SizedBox(height: 40),
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F7FF),
            shape: BoxShape.circle,
          ),
          child: _selectedImage != null
              ? ClipOval(
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFF0BAEFF),
                ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _pickImage,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            side: const BorderSide(color: Color(0xFF0BAEFF), width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.white,
          ),
          child: const Text(
            '사진 변경하기',
            style: TextStyle(
              color: Color(0xFF0BAEFF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (_photoChanged) ...[
          const SizedBox(height: 8),
          const Text(
            '사진이 변경되었습니다',
            style: TextStyle(
              color: Color(0xFF0BAEFF),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNicknameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '닉네임을 입력하세요',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '닉네임은 언제든 변경할 수 있습니다',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nicknameController,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0BAEFF), width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0BAEFF), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _checkDuplication,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            side: const BorderSide(color: Color(0xFF0BAEFF), width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.white,
          ),
          child: const Text(
            '중복 확인하기',
            style: TextStyle(
              color: Color(0xFF0BAEFF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF0BAEFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              '저장하기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (_saveCompleted) ...[
          const SizedBox(height: 8),
          const Text(
            '저장이 완료되었습니다',
            style: TextStyle(
              color: Color(0xFF0BAEFF),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

