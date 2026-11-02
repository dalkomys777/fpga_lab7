"""Compile a LAB7 Verilog project with Icarus and publish its VCD."""
import argparse, json, shutil, subprocess, sys
from pathlib import Path

ROOT = Path.cwd()

def main():
    parser=argparse.ArgumentParser(); parser.add_argument("action",choices=["simulate","wave"]); args=parser.parse_args()
    cfg=json.loads((ROOT/"simulation.json").read_text(encoding="utf-8"))
    out=ROOT/"build"/"sim"; out.mkdir(parents=True,exist_ok=True)
    wave=out/"wave.vcd"
    if args.action=="wave":
        if not wave.exists(): raise SystemExit("simulate를 먼저 실행하세요.")
        print("WAVE",wave); return
    iverilog=shutil.which("iverilog") or r"C:\msys64\mingw64\bin\iverilog.exe"
    vvp=shutil.which("vvp") or r"C:\msys64\mingw64\bin\vvp.exe"
    exe=out/"sim.vvp"
    sources=[ROOT/p for p in cfg["sources"]]+[ROOT/cfg["testbench"]]
    cmd=[iverilog,"-g2012","-Wall","-s",cfg["simulation_top"],"-o",str(exe),*map(str,sources)]
    print("RUN",subprocess.list2cmdline(cmd))
    compiled=subprocess.run(cmd,check=False)
    # The bundled Windows Icarus build can report an access violation while
    # shutting down even though it already wrote a valid VVP program.
    if compiled.returncode and (not exe.exists() or exe.stat().st_size == 0):
        raise subprocess.CalledProcessError(compiled.returncode,cmd)
    if compiled.returncode:
        print("WARNING: Icarus teardown error after valid sim.vvp; continuing")
    subprocess.run([vvp,"-N",str(exe)],cwd=out,check=True)
    generated=out/"wave.vcd"
    if not generated.exists(): raise SystemExit("wave.vcd가 생성되지 않았습니다.")
    print("WAVE",generated)

if __name__=="__main__":
    try: main()
    except subprocess.CalledProcessError as exc: print("ERROR",exc,file=sys.stderr);sys.exit(exc.returncode)

