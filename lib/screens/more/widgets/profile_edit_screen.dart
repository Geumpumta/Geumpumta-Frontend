import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/repository/profile/profile_repository.dart';
import 'package:geumpumta/viewmodel/user/profile_edit_viewmodel.dart';
import 'package:geumpumta/viewmodel/user/user_viewmodel.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImageFile;
  String? _currentImageUrl;
  String _currentPublicId = '';

  bool _photoChanged = false;
  bool _saveCompleted = false;
  bool _isCheckingNickname = false;
  bool? _isNicknameAvailable;
  bool _isUploadingImage = false;
  bool _initialized = false;
  bool _nicknameEdited = false;
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_onNicknameChanged);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _onNicknameChanged() {
    setState(() {
      _nicknameEdited = true;
      _isNicknameAvailable = null;
      _updateSaveButtonState();
    });
  }

  void _updateSaveButtonState() {
    final nicknameValid = _nicknameEdited && (_isNicknameAvailable == true);
    final imageChanged = _photoChanged;
    setState(() {
      _canSave = nicknameValid || imageChanged;
    });
  }

  Future<void> _pickImage() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );
      if (image != null) {
        await _uploadImage(File(image.path));
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e')),
      );
    }
  }

  Future<void> _uploadImage(File file) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _isUploadingImage = true;
    });
    try {
      final viewModel = ref.read(profileEditViewModelProvider.notifier);
      final ImageUploadResult result = await viewModel.uploadImage(file);
      setState(() {
        _selectedImageFile = file;
        _currentImageUrl = result.imageUrl;
        _currentPublicId = result.publicId;
        _photoChanged = true;
      });
      _updateSaveButtonState();
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('이미지 업로드에 실패했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  Future<void> _checkDuplication() async {
    final messenger = ScaffoldMessenger.of(context);
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('닉네임을 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isCheckingNickname = true;
    });

    try {
      final viewModel = ref.read(profileEditViewModelProvider.notifier);
      final isAvailable = await viewModel.verifyNickname(nickname);
      if (mounted) {
        setState(() {
          _isNicknameAvailable = isAvailable;
          _nicknameEdited = !isAvailable;
        });
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              isAvailable ? '사용 가능한 닉네임입니다.' : '이미 사용 중인 닉네임입니다.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('닉네임 확인 중 오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingNickname = false;
        });
        _updateSaveButtonState();
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_canSave) return;
    final messenger = ScaffoldMessenger.of(context);
    final nickname = _nicknameController.text.trim();
    final imageUrl = _currentImageUrl ?? '';
    final publicId = _currentPublicId;

    final viewModel = ref.read(profileEditViewModelProvider.notifier);
    final userViewModel = ref.read(userViewModelProvider.notifier);

    try {
      await viewModel.updateProfile(
        nickname: nickname,
        imageUrl: imageUrl,
        publicId: publicId,
      );
      await userViewModel.loadUserProfile();
      if (!mounted) return;
      setState(() {
        _photoChanged = false;
        _isNicknameAvailable = null;
        _nicknameEdited = false;
        _canSave = false;
        _saveCompleted = true;
      });
      messenger.showSnackBar(
        const SnackBar(content: Text('프로필이 저장되었습니다.')),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _saveCompleted = false;
        });
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('프로필 저장 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);
    userState.whenOrNull(data: (user) {
      if (!_initialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_initialized && mounted) {
            setState(() {
              _nicknameController.text = user.nickName ?? '';
              _currentImageUrl = user.profileImage;
              _currentPublicId = '';
              _initialized = true;
            });
          }
        });
      }
    });

    final editState = ref.watch(profileEditViewModelProvider);
    final isSaving = editState.isLoading && !_isCheckingNickname && !_isUploadingImage;

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
            _buildSaveButton(isSaving: isSaving),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    final imageWidget = _selectedImageFile != null
        ? Image.file(_selectedImageFile!, fit: BoxFit.cover)
        : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty)
            ? Image.network(
                _currentImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFF0BAEFF),
                ),
              )
            : const Icon(
                Icons.person,
                size: 60,
                color: Color(0xFF0BAEFF),
              );

    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F7FF),
            shape: BoxShape.circle,
          ),
          child: ClipOval(child: imageWidget),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 120,
          child: OutlinedButton(
            onPressed: _isUploadingImage ? null : _pickImage,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              side: const BorderSide(color: Color(0xFF0BAEFF), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
            ),
            child: _isUploadingImage
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    '사진 변경하기',
                    style: TextStyle(
                      color: Color(0xFF0BAEFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0BAEFF), width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0BAEFF), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            suffixIcon: _isCheckingNickname
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : (_isNicknameAvailable == true
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : (_isNicknameAvailable == false
                        ? const Icon(Icons.cancel, color: Colors.red)
                        : null)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isCheckingNickname ? null : _checkDuplication,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: const BorderSide(color: Color(0xFF0BAEFF), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
            ),
            child: _isCheckingNickname
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    '중복 확인하기',
                    style: TextStyle(
                      color: Color(0xFF0BAEFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton({required bool isSaving}) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canSave && !isSaving ? _saveProfile : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF0BAEFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
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

