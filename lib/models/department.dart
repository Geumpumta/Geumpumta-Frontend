enum Department {
  none,
  architectureEngineering,      // 건축공학전공
  architecture,                 // 건축학전공
  civilEngineering,             // 토목공학전공
  environmentalEngineering,     // 환경공학전공
  mechanicalEngineering,        // 기계공학전공
  mechanicalSystemsEngineering, // 기계시스템공학전공
  smartMobility,                // 스마트모빌리티전공
  industrialEngineering,        // 산업공학전공
  appliedMathBigData,           // 수리빅데이터전공
  polymerEngineering,           // 고분자공학전공
  materialsEngineering,         // 신소재공학전공
  semiconductorSystems,         // 반도체시스템전공
  electronicSystems,            // 전자시스템전공
  software,                     // 소프트웨어전공
  artificialIntelligence,       // 인공지능공학전공
  computerEngineering,          // 컴퓨터공학전공
  materialsDesignEngineering,   // 소재디자인공학전공
  chemicalEngineering,          // 화학공학전공
  chemicalBioMaterials,         // 화학생명소재전공
  opticalSystems,               // 광시스템공학과
  biomedicalEngineering,        // 바이오메디컬공학과
  itConvergence,                // IT융합학과
  liberalMajor,                 // 자율전공학부
  businessAdministration,       // 경영학과
}

extension DepartmentExtension on Department {
  String get koreanName {
    switch (this) {
      case Department.architectureEngineering:
        return '건축공학전공';
      case Department.architecture:
        return '건축학전공';
      case Department.civilEngineering:
        return '토목공학전공';
      case Department.environmentalEngineering:
        return '환경공학전공';
      case Department.mechanicalEngineering:
        return '기계공학전공';
      case Department.mechanicalSystemsEngineering:
        return '기계시스템공학전공';
      case Department.smartMobility:
        return '스마트모빌리티전공';
      case Department.industrialEngineering:
        return '산업공학전공';
      case Department.appliedMathBigData:
        return '수리빅데이터전공';
      case Department.polymerEngineering:
        return '고분자공학전공';
      case Department.materialsEngineering:
        return '신소재공학전공';
      case Department.semiconductorSystems:
        return '반도체시스템전공';
      case Department.electronicSystems:
        return '전자시스템전공';
      case Department.software:
        return '소프트웨어전공';
      case Department.artificialIntelligence:
        return '인공지능공학전공';
      case Department.computerEngineering:
        return '컴퓨터공학전공';
      case Department.materialsDesignEngineering:
        return '소재디자인공학전공';
      case Department.chemicalEngineering:
        return '화학공학전공';
      case Department.chemicalBioMaterials:
        return '화학생명소재전공';
      case Department.opticalSystems:
        return '광시스템공학과';
      case Department.biomedicalEngineering:
        return '바이오메디컬공학과';
      case Department.itConvergence:
        return 'IT융합학과';
      case Department.liberalMajor:
        return '자율전공학부';
      case Department.businessAdministration:
        return '경영학과';
      case Department.none:
      default:
        return '학과 선택';
    }
  }
}
