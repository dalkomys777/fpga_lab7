# LAB7 FPGA sources

- `spi_slave`: 과제 10, Mode 0 SPI 수신과 UART/LED 출력용 top
- `spi_master`: 과제 11, 1 MHz 이하 Mode 0 SPI 송신
- `spi_fpga_link`: 과제 12, master/slave 통합 사전 시뮬레이션

현재 단계에서는 보드 핀 제약(XDC)을 의도적으로 포함하지 않았다. 모든 프로젝트는
핀 제약 없이 Behavioral Simulation을 실행할 수 있다. 실제 보드 커넥터가 확정되면
각 프로젝트에 XDC를 추가한 뒤 합성·구현·비트스트림을 수행한다.

