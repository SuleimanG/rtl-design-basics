# 2-FF Synchronizer

## What it does
Moves a signal that changes asynchronously (relative to `clk`) safely into
the `clk` domain by stacking two flip-flops in series. The first flop may go
metastable if `async_in` toggles right at the clock edge, but it has a full
clock period to resolve before the second flop samples it.

```
async_in ──▶[FF1: N1]──▶[FF2: sync_out]──▶ (safe to use downstream)
              clk           clk
```

## Testbench approach (`tb/synchronizer_tb.sv`)
1. **Golden reference model** – a correctly-written 2-FF shift register runs
   alongside the DUT with the same clock and reset.
2. **Asynchronous stimulus** – `async_in` toggles at random delays that are
   *not* aligned to `clk` edges, since that's the actual scenario a
   synchronizer exists to handle.
3. **Self-checking scoreboard** – every clock edge, `sync_out` (DUT) is
   compared against `ref_sync_out` (reference model); any mismatch is
   printed with `$display` and counted.
4. **Directed reset check** – confirms `sync_out` is `0` immediately after
   `rst_n` deasserts.
5. **Waveform dump** – `$dumpfile` / `$dumpvars` for viewing in GTKWave
   (Icarus) or EPWave (EDA Playground).

## Running it

 
**Try it live:** [edaplayground.com/x/SchJ](https://edaplayground.com/x/SchJ)
— open the link, hit Run, then open the generated `.vcd` in EPWave.

**Locally with Icarus Verilog + GTKWave:**
```bash
iverilog -g2012 -o sim.out rtl/synchronizer.sv tb/synchronizer_tb.sv
vvp sim.out
gtkwave synchronizer_tb.vcd
```

## Expected output
```
[15] Reset check passed: sync_out is cleanly 0
--------------------------------------------------
TEST PASSED: XX checks, 0 mismatches
--------------------------------------------------
```
