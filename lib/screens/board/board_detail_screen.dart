import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/board/board_detail_dto.dart';
import 'package:geumpumta/provider/api_provider.dart';
import 'package:geumpumta/widgets/back_and_title/back_and_title.dart';

class BoardDetailScreen extends ConsumerStatefulWidget {
  final int boardId;

  const BoardDetailScreen({
    super.key,
    required this.boardId,
  });

  @override
  ConsumerState<BoardDetailScreen> createState() =>
      _BoardDetailScreenState();
}

class _BoardDetailScreenState extends ConsumerState<BoardDetailScreen> {
  BoardDetailDto? _board;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBoardDetail();
  }

  Future<void> _loadBoardDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final boardApi = ref.read(boardApiProvider);
      final response = await boardApi.getBoardDetail(widget.boardId);

      if (response.success) {
        setState(() {
          _board = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = '공지사항을 불러오는데 실패했습니다.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = '공지사항을 불러오는데 실패했습니다: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            BackAndTitle(title: _board?.title ?? '공지사항'),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadBoardDetail,
                                child: const Text('다시 시도'),
                              ),
                            ],
                          ),
                        )
                      : _board == null
                          ? const Center(
                              child: Text(
                                '공지사항을 찾을 수 없습니다.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _board!.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _formatDate(_board!.createdAt),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    _board!.content,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF555555),
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

