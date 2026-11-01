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

