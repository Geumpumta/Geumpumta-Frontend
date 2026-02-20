enum PeriodOption { daily, weekly, monthly }

extension PeriodOptionExtension on PeriodOption {
  String get koreanName {
    switch (this) {
      case PeriodOption.daily:
        return '일간';
      case PeriodOption.weekly:
        return '주간';
      case PeriodOption.monthly:
        return '월간';
    }
  }
}