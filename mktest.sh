cd booter && make clean && make && cd .. && sh mkbootimg.sh disk.img booter/stage_zero booter/stage_one kernel && qemu-system-i386 -m 2 -boot a -fda disk.img
