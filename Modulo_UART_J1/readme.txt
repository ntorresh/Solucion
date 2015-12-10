

---------------------------------------- Modulo UART ----------------------------------------

Digital I.
Docente Ferney Beltran.
Universidad Nacional de Colombia.
Sede Bogotá.
2015-II

Nicolas Torres.
Rubén Parra.
Sergio Gil.

En esta carpeta encontrara todo el código, hardware y software, desarrollado e implementado 
para controlar un modulo UART y un modulo multiplicación por medio de un procesador J1 en un
Nexys4. El software se creó en forth, y el hardware en verilog, se sintetizó por ISE de Xilinx.

Para la demostración la FPGA recibirá por medio de bluetooth, conectado a los pines rx y tx
del modulo UART, dos números hexadecimales positivos cuya multiplicación sea menor a FF, los
cuales se multiplicaran por medio del modulo multiplicación, controlado por el J1 programado
en forth, y trasmitirá la respuesta por medio del mismo bluetooth. La transmisión y recepción
de los números se realizara por medio de cutecom de linux, usando el bluetooth del computador.

---------------------------------------- Modulo UART ----------------------------------------

