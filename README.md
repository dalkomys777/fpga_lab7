# FPGA LAB7

전자전기컴퓨터설계실험 II LAB7 사전 준비 저장소이다. 2026년 11월 2일 STM32_3 실습의 SPI 통신과 MCU·FPGA 연동을 다룬다.

## 실험 범위

- 과제 8: STM32 SPI 송신 파형 확인
- 과제 9: MCU에서 MCU로 SPI 송수신
- 과제 10: MCU에서 FPGA로 SPI 전송
- 과제 11: FPGA에서 MCU로 SPI 전송
- 과제 12: FPGA에서 FPGA로 SPI 송수신

## 폴더 구성

- `circuits/`: FPGA SPI slave, master 및 통합 회로
- `stm32/`: 과제별 STM32 코드
- `evidence/`: 파형, 시리얼 출력 및 보드 동작 증빙
- `reports/pre/`: 예비보고서
- `reports/post/`: 결과보고서

## 공통 통신 조건

- SPI Mode 0
- 8-bit
- MSB first
- SCK 1 MHz 이하
- SCK, MOSI, CS, GND 연결

## 실행

1. VSCode에서 `LAB7.code-workspace`를 연다.
2. `Terminal > Run Task...`에서 원하는 STM32 활성화·빌드 또는 FPGA 시뮬레이션을 선택한다.
3. FPGA GUI 시뮬레이션은 각 `circuits/*/*.xpr` 파일을 Vivado에서 열고
   `Run Simulation > Run Behavioral Simulation > Run All`을 누른다.

STM32 작업은 활성화 전에 현재 `ece2_474_routine.c`를 `ece2_474/lab7_backup`에
자동 보관한다. 현재는 과제 8 송신 코드가 `ece2_474`에 활성화되어 있다.

FPGA 프로젝트는 핀 제약 없이 Behavioral Simulation이 가능하다. 실제 FPGA 핀을
확정한 다음 XDC를 추가해야 합성·구현·비트스트림을 진행할 수 있다.

## 사전 검증 결과

- SPI slave: `55 A5 00 FF`, CS HIGH 무시, 바이트당 `rx_valid` 1회 PASS
- SPI master: Mode 0, 8클록, `55 A5` 송신 PASS
- FPGA link: master의 `55 A5`를 slave가 동일하게 수신 PASS

