CPPPARAMS = -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti
ASPARAMS = 
LDPARAMS = -ffreestanding -O2 -nostdlib -lgcc

PREFIX = $(HOME)/opt/cross/bin
TARGET = i686-elf

objects = kernel.o boot.o

%.o: %.cpp
	$(PREFIX)/$(TARGET)-g++ $(CPPPARAMS) -c $< -o $@

%.o: %.s
	$(PREFIX)/$(TARGET)-as $< -o $@ $(ASPARAMS)

myos.bin: linker.ld $(objects)
	$(PREFIX)/$(TARGET)-gcc -T $< -o $@ $(LDPARAMS) $(objects)

myos.iso: myos.bin
	mkdir -p iso/boot/grub
	cp $< iso/boot/
	echo 'set timeout=0' >> iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo '' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My Operating System" {' >> iso/boot/grub/grub.cfg
	echo '	multiboot /boot/myos.bin' >> iso/boot/grub/grub.cfg
	echo '	boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso

clear:
	rm *.o *.bin *.iso