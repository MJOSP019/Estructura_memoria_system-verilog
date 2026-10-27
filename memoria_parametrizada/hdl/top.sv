`timescale 1ns / 1ps

// ============================================================================
// Módulo: top
// Descripción: Memoria RAM estática parametrizada (ancho de palabra y profundidad)
//              siguiendo el principio del video de direccionamiento y control
//              Write Enable / Read Enable.
// ============================================================================
module top #(
    parameter int DATA_WIDTH = 8,                 // Ancho de palabra (bits, ej. 1 byte)
    parameter int ADDR_WIDTH = 4,                 // Ancho del bus de direcciones (ej. 4 bits -> 16 posiciones)
    parameter int MEM_DEPTH  = (1 << ADDR_WIDTH)  // Número total de posiciones de memoria (2^ADDR_WIDTH)
)(
    input  logic                  clk,
    input  logic                  reset,
    
    // Señales de control descritas en el video
    input  logic                  write_en,       // Habilita la escritura en la celda seleccionada
    input  logic                  read_en,        // Habilita la lectura (salida en bus de datos)
    
    // Buses de direcciones y datos
    input  logic [ADDR_WIDTH-1:0] addr,           // Dirección decodificada internamente (filas/columnas)
    input  logic [DATA_WIDTH-1:0] data_in,        // Dato a almacenar (Data input)
    output logic [DATA_WIDTH-1:0] data_out        // Dato leído (Data output)
);

    // Matriz de almacenamiento: arreglo de registros/latches agrupados en palabras
    logic [DATA_WIDTH-1:0] memory_array [0:MEM_DEPTH-1];

    // ------------------------------------------------------------------------
    // Proceso Secuencial de Escritura síncrona
    // Si reset = 1, limpia la memoria.
    // Si write_en = 1, almacena data_in en la posición indexada por addr.
    // ------------------------------------------------------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < MEM_DEPTH; i++) begin
                memory_array[i] <= '0;
            end
        end else if (write_en) begin
            memory_array[addr] <= data_in;
        end
    end

    // ------------------------------------------------------------------------
    // Lógica de Lectura síncrona / registrada con Read Enable
    // Mantiene la salida en alta impedancia (o en 0) cuando read_en está inactivo,
    // emulando la desconexión del bus mostrada en el video.
    // ------------------------------------------------------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= '0;
        end else if (read_en) begin
            data_out <= memory_array[addr];
        end else begin
            data_out <= '0; // o {DATA_WIDTH{1'bz}} si se modela bus tri-estado
        end
    end

endmodule