import 'dart:async';

import 'package:clozii/core/theme/context_extension.dart';
import 'package:clozii/core/utils/animation.dart';
import 'package:clozii/core/utils/loading_overlay.dart';
import 'package:clozii/features/auth/presentation/widgets/verification/verification_field.dart';
import 'package:clozii/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  /// 인증번호 유효 시간 - 타이머
  Timer? _timer;
  int _minutes = 1;
  int _seconds = 0;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() async {
      if (_controller.text.length == 6 && _isValidCode()) {
        final loading = showLoadingOverlay(context); // ⬅️ 현재 화면 위에 로딩만 띄움

        try {
          // 이미 계정이 존재하는 지 확인
          // 없으면 -> 새로 생성
          // 있으면 -> 로그인
          await Future.delayed(const Duration(seconds: 2)); // 예시

          if (!mounted) return;

          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            fadeInRoute(HomeScreen()),
            (route) => false, // 스택 전부 제거
          );
        } finally {
          loading.remove();
        }
      }
    });

    _startTimer();
  }

  @override
  void dispose() {
    // 타이머 해제
    if (_timer != null) _timer!.cancel();

    _controller.dispose();
    super.dispose();
  }

  // SMS 인증번호 검증 - 아마 Future<bool> 로 변경해야 할것 같다
  bool _isValidCode() {
    if (_controller.text == '123123') {
      return true;
    }
    return false;
  }

  /// 인증번호 유효시간 카운트다운 시작
  void _startTimer() {
    // 기존 타이머가 동작 중이면 취소
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    // 초기값 1분
    _minutes = 1;
    _seconds = 0;

    // 타이머 초기화 - Timer.periodic (일정 주기마다 특정 로직 수행)
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (!mounted) return; // 화면이 사라진 상태라면 아무것도 안 함

        if (_seconds > 0) {
          _seconds--;
        } else {
          _minutes--;
          _seconds = 59;
        }
      });

      // 시간이 다 되면 타이머 종료
      if (_minutes == 0 && _seconds == 0) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter the verification code',
                style: context.textTheme.titleLarge,
              ),

              const SizedBox(height: 24),

              VerificationField(
                minutes: _minutes,
                seconds: _seconds,
                onVerified: () {},
                controller: _controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
