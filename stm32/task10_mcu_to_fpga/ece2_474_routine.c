#include "ece2_474.h"
#include "main.h"
#include <stdint.h>
#include <stdio.h>

void ece2_474_init(void)
{
    HAL_GPIO_WritePin(SPI_CS_ece2_GPIO_Port, SPI_CS_ece2_Pin, GPIO_PIN_SET);
}

void polling_routine(void)
{
    static uint32_t last_ms = 0U;
    static uint8_t tx = 0x55U;
    uint32_t now_ms = HAL_GetTick();
    if ((now_ms - last_ms) < 1000U) return;
    last_ms = now_ms;

    HAL_GPIO_WritePin(SPI_CS_ece2_GPIO_Port, SPI_CS_ece2_Pin, GPIO_PIN_RESET);
    HAL_StatusTypeDef result = HAL_SPI_Transmit(&hspi1, &tx, 1U, 100U);
    HAL_GPIO_WritePin(SPI_CS_ece2_GPIO_Port, SPI_CS_ece2_Pin, GPIO_PIN_SET);
    printf("TASK10 MCU->FPGA TX=%02X result=%d\r\n", (unsigned int)tx, (int)result);
    tx = (tx == 0x55U) ? 0xA5U : 0x55U;
}

