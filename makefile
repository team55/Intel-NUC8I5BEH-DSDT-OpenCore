# makefile

#
# Patches/Installs/Builds DSDT patches for Intel NUC8
#
# Created by RehabMan 
#

# set build products
BUILDDIR=./build
AML_PRODUCTS=$(BUILDDIR)/SSDT-NUC8-BC.aml \
	$(BUILDDIR)/SSDT_NVMe09.aml $(BUILDDIR)/SSDT_NVMe13.aml \
	$(BUILDDIR)/SSDT-DDA.aml $(BUILDDIR)/SSDT_SKLSPF.aml $(BUILDDIR)/SSDT_KBLSPF.aml \
	$(BUILDDIR)/SSDT_CFLALT.aml
PRODUCTS=$(AML_PRODUCTS)

IASLOPTS=-vw 2095 -vw 2008
IASL=iasl

.PHONY: all
all: $(PRODUCTS)

$(BUILDDIR)/%.aml : %.dsl
	iasl $(IASLOPTS) -p $@ $<

# generated with: ./find_dependencies.sh

$(BUILDDIR)/SSDT-NUC8-BC.aml : SSDT-NUC8-BC.dsl SSDT-XOSI.dsl SSDT-IGPU.dsl SSDT-USBX.dsl SSDT-USB-NUC8-BC.dsl SSDT-XHC.dsl SSDT-XDCI.dsl SSDT-NUCHDA.dsl SSDT-HDEF.dsl

# end generated

.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*.dsl $(BUILDDIR)/*.aml

# NUC8 Bean Canyon
.PHONY: install_nuc8bc
install_nuc8bc: $(AML_PRODUCTS)
	$(eval EFIDIR:=$(shell ./mount_efi.sh))
	
	# clean output
	rm -f "$(EFIDIR)"/EFI/CLOVER/ACPI/patched/SSDT-*.aml
	rm -f "$(EFIDIR)"/EFI/CLOVER/ACPI/patched/SSDT.aml
	
	# copy files
	cp $(BUILDDIR)/SSDT-NUC8-BC.aml "$(EFIDIR)"/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-DDA.aml "$(EFIDIR)"/EFI/CLOVER/ACPI/patched
	if [[ -e "$(EFIDIR)"/EFI/CLOVER/ACPI/patched/SSDT_CFLALT.aml ]]; then make install_cflalt; fi

# optional CoffeeLake Alternate configuration for systems where 0x3e9b0007 works better than 0x3ea50000.
.PHONY: install_cflalt
install_cflalt: $(AML_PRODUCTS)
	$(eval EFIDIR:=$(shell ./mount_efi.sh))
	cp $(BUILDDIR)/SSDT_CFLALT.aml "$(EFIDIR)"/EFI/CLOVER/ACPI/patched

