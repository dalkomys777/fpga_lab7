#ifndef ECE2_474_H
#define ECE2_474_H
#include <stdint.h>
typedef struct { struct { int Mode; int NSS; } Init; } SPI_HandleTypeDef;
typedef struct { uint32_t Pin, Mode, Pull, Speed, Alternate; } GPIO_InitTypeDef;
typedef int HAL_StatusTypeDef;
typedef int GPIO_PinState;
extern SPI_HandleTypeDef hspi1;
extern int dummy_gpio_a, dummy_gpio_b;
#define HAL_OK 0
#define HAL_TIMEOUT 3
#define SPI_MODE_SLAVE 1
#define SPI_NSS_HARD_INPUT 2
#define GPIO_PIN_4 4U
#define GPIO_MODE_AF_PP 2U
#define GPIO_PULLUP 1U
#define GPIO_SPEED_FREQ_LOW 0U
#define GPIO_AF5_SPI1 5U
#define GPIO_PIN_RESET 0
#define GPIO_PIN_SET 1
#define GPIOA (&dummy_gpio_a)
uint32_t HAL_GetTick(void);
HAL_StatusTypeDef HAL_SPI_DeInit(SPI_HandleTypeDef *h);
HAL_StatusTypeDef HAL_SPI_Init(SPI_HandleTypeDef *h);
HAL_StatusTypeDef HAL_SPI_Transmit(SPI_HandleTypeDef *h,uint8_t *p,uint16_t n,uint32_t timeout);
HAL_StatusTypeDef HAL_SPI_Receive(SPI_HandleTypeDef *h,uint8_t *p,uint16_t n,uint32_t timeout);
void HAL_GPIO_WritePin(void *port,uint16_t pin,GPIO_PinState state);
void HAL_GPIO_Init(void *port,GPIO_InitTypeDef *gpio);
void Error_Handler(void);
#endif

