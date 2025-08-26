# Stack Logic Circuit

Этот репозиторий содержит реализацию стека на Logisim и Verilog (структурная и поведенческая модели).

## Структура репозитория

- `templates/` - директория с шаблонами для Logisim, SystemVerilog и отчета.
- `*.sv` - файлы с реализацией на SystemVerilog (структурная и поведенческая модели).
- `*.circ` - файл проекта Logisim.

## Требования к загрузке

1. **Проект Logisim** (файл с расширением `.circ`). Если представлены две версии (lite и normal), проверяется normal.
2. **Структурная модель на Verilog**: `stack_structural.sv` - модуль `stack_structural` и все вспомогательные модули.
3. **Поведенческая модель на Verilog**: `stack_behaviour.sv` - модуль `stack_behaviour`.

## Проверка Verilog локально

Для проверки моделей на Verilog используйте следующие команды (из корня репозитория):

### Сборка и симуляция
1. Сборка: 
   ```bash
   iverilog -g2012 -o stack_tb.out stack_behaviour_tb.sv
   ```
2. Симуляция:
   ```bash
   vvp stack_tb.out +TIMES=5 +OUTCSV=st_stack_5.csv
   ```
3. Запуск проверки:
   - Для lite версии:
     ```bash
     python ".github/workflows/verilog_checker.py" st_stack_5.csv ".github/workflows/ref_stack_lite_5.csv"
     ```
   - Для normal версии:
     ```bash
     python ".github/workflows/verilog_checker.py" st_stack_5.csv ".github/workflows/ref_stack_normal_5.csv"
     ```

### Примечание
Закрытые тесты для Verilog представляют собой запуск testbench с различными значениями `TIMES`.

## Инструментарий

- Icarus Verilog **v12-20220611**
- Logisim Evolution **3.8.0**

## Детали реализации

### Logisim

Схема в Logisim разделена на три основные части:
- Счётчик (counter_mod5)
- Память на 4 бита (D_register_4)
- Дешифраторы (decoder_8)

#### Счётчик
Используются T-триггеры, которые удваивают тактность. Счетчик настроен на модуль 5 с обработкой переполнения.

#### Память
Реализована на D-триггерах. Для записи значения требуется выставить данные на входах и подать тактовый импульс.

#### Дешифраторы
Однобитный и двухбитный дешифраторы используются для преобразования команд и индексов в управляющие сигналы.

### Verilog Structural

Переписанная версия схемы Logisim на Verilog. Включает те же модули: счетчик, память, дешифраторы. Для реализации IN-OUT используются элементы `nmos`.

### Verilog Behaviour

Поведенческая модель стека с использованием регистров для хранения данных и управления индексом. Обработка команд (PUSH, POP, GET, NOP) происходит по фронту тактового сигнала.

#### Ключевые особенности
- Используется массив из 5 элементов по 4 бита.
- Индекс текущего элемента управляется арифметикой по модулю 5.
- Вход-выход реализован через управление состоянием высокого импеданса.

## Решение

### Поведенческая модель (stack_behaviour.sv)

```verilog
`define NOP 2'b00
`define PUSH 2'b01 
`define POP 2'b10
`define GET 2'b11

module stack_behaviour_normal(
    inout wire[3:0] IO_DATA,
     
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX
    ); 

    reg [3:0] array [4:0];
    reg [2:0] index;

    reg[2:0] temp_ind;
        
    reg if_output;

    reg [3:0] DATA_in;
    reg [3:0] DATA_out;

    integer i;

    assign DATA_in = IO_DATA;
    assign IO_DATA = (if_output == 1 && CLK == 1) ? DATA_out : 4'bz;

    initial begin
        for (i = 0; i < 5; ++i) begin
            array[i] = 4'b0;
        end
        index = 4;
    end

    always @(posedge RESET) begin
        for (i = 0; i < 5; ++i) begin
            array[i] = 4'b0;
        end
        index = 4;
    end   

    always @(posedge CLK) begin
        if (RESET == 0) begin
            case (COMMAND)
                    `PUSH:  begin
                                index = (index + 1) % 5;
                                array[index] = DATA_in;

                                if_output = 0;
                            end

                    `POP:   begin
                                DATA_out = array[index];
                            
                                if (index == 0) begin
                                    index = 4;
                                end else begin
                                    index = index - 1;
                                end

                                if_output = 1;
                            end

                    `GET:   begin
                                temp_ind = index;
                                for (i = 0; i < INDEX; ++i) begin
                                    temp_ind -= 1;
                                    if (temp_ind == 7) begin
                                        temp_ind = 4;
                                    end
                                end
                                DATA_out = array[temp_ind];

                                if_output = 1;
                            end
                    `NOP: begin
                        if_output = 0;
                    end
                    endcase
                end 
    end
endmodule
```

### Структурная модель (stack_structural.sv)

Структурная модель содержит все описанные модули (гейты, триггеры, регистры, счетчики, декодеры) и соединяет их в соответствии со схемой Logisim. Из-за большого объема кода приведена только основа. Полный код доступен в репозитории.

## Заключение

Проект демонстрирует реализацию стека на разных уровнях абстракции: от схемы в Logisim до структурной и поведенческой моделей на Verilog.

Для более подробного ознакомления с деталями реализации см. исходные файлы в репозитории.