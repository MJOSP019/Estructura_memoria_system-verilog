`timescale 1ns / 1ps

module tb_top;

    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;
    localparam int CLK_PERIOD = 10; // 10 ns -> 100 MHz

    logic                  clk;
    logic                  reset;
    logic                  write_en;
    logic                  read_en;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;

    // Instancia del módulo top parametrizado
    top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk      (clk),
        .reset    (reset),
        .write_en (write_en),
        .read_en  (read_en),
        .addr     (addr),
        .data_in  (data_in),
        .data_out (data_out)
    );

    // Generador de Reloj
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Secuencia de Pruebas
    initial begin
        // Inicialización
        reset    = 1;
        write_en = 0;
        read_en  = 0;
        addr     = '0;
        data_in  = '0;
        #(CLK_PERIOD * 2);
        
        reset = 0;
        #(CLK_PERIOD);

        // 1. Escritura en múltiples direcciones
        $display("[INFO] Iniciando fase de escritura...");
        for (int i = 0; i < 4; i++) begin
            @(negedge clk);
            addr     = i;
            data_in  = 8'hA0 + i; // Valores: A0, A1, A2, A3
            write_en = 1;
            read_en  = 0;
        end

        @(negedge clk);
        write_en = 0;
        #(CLK_PERIOD * 2);

        // 2. Lectura y comprobación de datos almacenados
        $display("[INFO] Iniciando fase de lectura...");
        for (int i = 0; i < 4; i++) begin
            @(negedge clk);
            addr    = i;
            read_en = 1;
            @(posedge clk);
            #1; // Margen de retardo
            $display("Direccion: 0x%0h | Dato Leido: 0x%0h | Esperado: 0x%0h", addr, data_out, (8'hA0 + i));
            assert(data_out == (8'hA0 + i)) else $error("Error de coincidencia en direccion %0d", i);
        end

        @(negedge clk);
        read_en = 0;
        #(CLK_PERIOD * 2);

        $display("[EXITO] Todas las pruebas de la memoria completadas correctamente.");
        $finish;
    end

endmodule