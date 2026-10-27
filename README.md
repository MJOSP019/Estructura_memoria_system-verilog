# Memoria Parametrizada en SystemVerilog (Top Module)

**Autor:** Marcos Josué Pineda Urbina  
**Curso:** Arquitectura de Computadoras  

---

## 🎥 Video Explicativo
- Enlace al video de YouTube 
(https://youtu.be/7Kk_LdfHeZI)

---

## 📖 Descripción del Proyecto
Implementación en SystemVerilog de una arquitectura de memoria síncrona parametrizable en tamaño de palabra (`DATA_WIDTH`) y profundidad de direcciones (`ADDR_WIDTH`), fundamentada en los principios explicados en el video *How Transistors Remember Data* de Core Dumped:
1. **Lógica de Retención:** Transición del latch biestable al almacenamiento matricial direccionable.
2. **Decodificación de Direcciones:** Selección de celdas mediante un bus de direcciones (`addr`).
3. **Buses y Habilitadores:** Control coordinado de escritura (`write_en`) y lectura (`read_en`).

---

## 🛠️ Parámetros del Módulo

* `DATA_WIDTH`: Tamaño en bits de cada palabra (por defecto: 8 bits).
* `ADDR_WIDTH`: Tamaño del bus de direcciones (por defecto: 4 bits, permitiendo 2^4 = 16 palabras).
* `MEM_DEPTH`: Capacidad total de almacenamiento calculada automáticamente (2^ADDR_WIDTH palabras).

---

## 📊 Verificación y Simulación
* **Escritura:** Registro de datos en flancos ascendentes cuando `write_en = 1`.
* **Lectura:** Extracción del dato en el bus `data_out` mediante activación de `read_en = 1`.
