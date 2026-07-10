#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_input.py
-----------------
Gera o arquivo de vetores de teste 'input.txt' consumido por stimulus.vhd/checker.vhd
no testbench modular da ULA (tb_mips_modular).

Formato de cada linha:  <A_hex(8)> <B_hex(8)> <funct_bin(6)>
  - A, B     : operandos de 32 bits em hexadecimal
  - funct    : codigo de 6 bits da operacao (mesmos codigos decodificados pela ULA)

Uso:
    python3 generate_input.py            # grava input.txt neste diretorio
    python3 generate_input.py saida.txt  # grava em outro caminho
"""
import sys, random

# funct codes suportados pela ULA / checker (sem shift, pois o harness fixa shamt=0)
FUNCT = {
    "ADD" : "100000",
    "ADDU": "100001",
    "SUB" : "100010",
    "SUBU": "100011",
    "AND" : "100100",
    "OR"  : "100101",
    "XOR" : "100110",
    "NOR" : "100111",
    "SLT" : "101010",
}

def line(a, b, fn):
    return f"{a & 0xFFFFFFFF:08x} {b & 0xFFFFFFFF:08x} {FUNCT[fn]}"

def main():
    out = sys.argv[1] if len(sys.argv) > 1 else "input.txt"
    linhas = []

    # 1) Casos de borda deterministicos (overflow, iguais, negativos)
    linhas += [
        line(0x7FFFFFFF, 0x00000001, "ADD"),   # overflow com sinal
        line(0x7FFFFFFF, 0x00000001, "ADDU"),  # sem overflow (unsigned)
        line(0x7FFFFFFF, 0x00000001, "SUB"),
        line(0x7FFFFFFF, 0x00000001, "SUBU"),
        line(0x0000000F, 0x000000F0, "AND"),
        line(0x0000000F, 0x000000F0, "OR"),
        line(0x000000FF, 0x0000000F, "XOR"),
        line(0x00000000, 0x00000000, "NOR"),
        line(0x00000005, 0x0000000A, "SLT"),   # 5 <  10 -> 1
        line(0x0000000A, 0x00000005, "SLT"),   # 10 < 5  -> 0
    ]

    # 2) Casos aleatorios reprodutiveis para cada operacao
    random.seed(42)
    for fn in FUNCT:
        for _ in range(2):
            a = random.getrandbits(32)
            b = random.getrandbits(32)
            linhas.append(line(a, b, fn))

    with open(out, "w") as f:
        f.write("\n".join(linhas) + "\n")

    print(f"{len(linhas)} vetores escritos em {out}")

if __name__ == "__main__":
    main()
