#include "lcd9341.h"
#include <stdio.h>
#include <math.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "alt_types.h"

// 修改采样点为256满足FFT要求
#define N_FFT 256
#define Fs 1000000.0        // 采样频率1MHz
#define Freq_Interval (Fs/N_FFT)

// 复数结构体
typedef struct {
    float real;
    float imag;
} Complex;

// FFT相关变量
Complex fft_data[N_FFT];
float spectrum_abs[N_FFT/2];
alt_16 adc_data[N_FFT];  // ADC采样数据

// 屏幕参数
#define LCD_WIDTH 320				//Y轴
#define LCD_HEIGHT 240				//X轴
#define GRAPH_X 30
#define GRAPH_Y 30
#define GRAPH_WIDTH 260
#define GRAPH_HEIGHT 150

// FFT函数实现
void FFT_Transform() {
    int i, j, k, m;			//
    Complex wn, t, u;		//声明结构体
    int le, le2, ip;
    // 位反转重排
    j = 0;
    for(i = 0; i < N_FFT-1; i++) {
        if(i < j) {
            t = fft_data[i];
            fft_data[i] = fft_data[j];
            fft_data[j] = t;
        }
        k = N_FFT/2;			//k=256/2=128;
        while(k <= j) {
            j -= k;				//j=j-k;
            k /= 2;				//k=k/2;
        }
        j += k;					//j=j+k;
    }
    // 蝶形运算
    for(m = 2; m <= N_FFT; m <<= 1) {
        le = m;
        le2 = m/2;
        for(j = 0; j < le2; j++) {
            float angle = -2 * M_PI * j / m;
            wn.real = cos(angle);
            wn.imag = sin(angle);
            for(i = j; i < N_FFT; i += le) {
                ip = i + le2;
                // 复数乘法
                t.real = fft_data[ip].real * wn.real - fft_data[ip].imag * wn.imag;
                t.imag = fft_data[ip].real * wn.imag + fft_data[ip].imag * wn.real;
                // 复数加减
                u = fft_data[i];
                fft_data[i].real = u.real + t.real;
                fft_data[i].imag = u.imag + t.imag;
                fft_data[ip].real = u.real - t.real;
                fft_data[ip].imag = u.imag - t.imag;
            }
        }
    }
}
// 计算频谱幅度
void Calculate_Spectrum() {
    for(int k = 0; k < N_FFT/2; k++) {
        // 幅度计算 (sqrt(re^2 + im^2))
        spectrum_abs[k] = sqrt(fft_data[k].real * fft_data[k].real +
                              fft_data[k].imag * fft_data[k].imag);
        // 归一化处理
        spectrum_abs[k] /= (N_FFT/2);
    }
}
// 在LCD上绘制频谱图
void Draw_Spectrum() {
    // 清空频谱显示区域
    LCD_Fill(GRAPH_X, GRAPH_Y, GRAPH_X + GRAPH_WIDTH, GRAPH_Y + GRAPH_HEIGHT, BLACK);  //(30,30,290,180黑色)   （20，20，220，300，黑色）
    // 绘制坐标轴
    POINT_COLOR = WHITE;

    LCD_DrawLine(GRAPH_X, GRAPH_Y + GRAPH_HEIGHT,
                 GRAPH_X + GRAPH_WIDTH, GRAPH_Y + GRAPH_HEIGHT);  // 画X轴 （30，180，290，180）//有问题   （20，20，20，300）
    LCD_DrawLine(GRAPH_X, GRAPH_Y,
                 GRAPH_X, GRAPH_Y + GRAPH_HEIGHT);  // 画Y轴  （30，30，30，290）						（20，20，220，20）
    // 查找最大幅度值
    float max_amp = 0;
    for(int i = 1; i < N_FFT/2; i++) {
        if(spectrum_abs[i] > max_amp) max_amp = spectrum_abs[i];
    }
    if(max_amp < 1e-5) max_amp = 1;  // 防止除零错误
    // 绘制频谱柱状图
    int bar_width = GRAPH_WIDTH / (N_FFT/4);  // 只显示前1/2频谱     260/（256/4） = 4
    for(int k = 1; k < N_FFT/4; k++) {
        int bar_height = (int)((spectrum_abs[k] / max_amp) * GRAPH_HEIGHT);		//     (一个小于等于1的数)*150   之后在取整;
        int x1 = GRAPH_X + k * bar_width;				//30+4k		平移柱宽		每次加 4
        int y1 = GRAPH_Y + GRAPH_HEIGHT - bar_height;	//30+150 - 高度
        // 绘制柱状图
        POINT_COLOR = BLUE;
        LCD_DrawLine(x1, GRAPH_Y + GRAPH_HEIGHT, x1, y1);  //（30+4k,180，30+4k,180 - 高度）
    }
    // 标注频率信息
    char freqInfo[30];
    sprintf(freqInfo, "Fs:%.1fkHz", Fs/1000);
    LCD_ShowString(GRAPH_X + 10, GRAPH_Y + 10, freqInfo);
}

int main() {
    LCD9341_Init();
    POINT_COLOR = GREEN;
    BACK_COLOR = BLACK;
    LCD_Clear(BLACK);
    // 绘制标题
    LCD_ShowString(10, 5, "FFT Spectrum Analyzer");
    while(1) {
        // 采集ADC数据
        for(int n = 0; n < N_FFT; n++) {
            adc_data[n] = IORD_ALTERA_AVALON_PIO_DATA(PIO_AUDIO_BASE);		//读取  数据
            usleep(1);  // 根据采样率调整延时
        }
        // 准备FFT输入数据
        for(int n = 0; n < N_FFT; n++) {
            fft_data[n].real = (float)adc_data[n];  // 实部为ADC采样值
            fft_data[n].imag = 0.0;                 // 虚部为0
        }
        // 执行FFT变换
        FFT_Transform();
        // 计算频谱幅度
        Calculate_Spectrum();
        // 在LCD上绘制频谱
        Draw_Spectrum();
        // 控制刷新率
        usleep(50000);  // 约20Hz刷新率
    }
    return 0;
}
