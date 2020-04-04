# makefile

#
# Patches/Installs/Builds DSDT patches for Intel NUC8
#

# set build products
BUILDDIR=./build
AML_PRODUCTS=$(BUILDDIR)/SSDT-NUC8-BC.aml \
	$(BUILDDIR)/SSDT_NVMe09.aml \
	$(BUILDDIR)/SSDT_NVMe13.aml \
	$(BUILDDIR)/SSDT-DDA.aml \
	$(BUILDDIR)/SSDT_CFLALT.aml
PRODUCTS=$(AML_PRODUCTS)

IASLOPTS=-vw 2095 -vw 2008
IASL=iasl

.PHONY: all
all: $(PRODUCTS)

$(BUILDDIR)/%.aml : %.dsl
	iasl $(IASLOPTS) -p $@ $<

# dependencies
$(BUILDDIR)/SSDT-NUC8-BC.aml : SSDT-NUC8-BC.dsl SSDT-XOSI.dsl SSDT-IGPU.dsl SSDT-USBX.dsl SSDT-USB-NUC8-BC.dsl SSDT-XHC.dsl SSDT-XDCI.dsl SSDT-NUCHDA.dsl SSDT-HDEF.dsl


.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*.dsl $(BUILDDIR)/*.aml

# --------------------------------------------------------
# BUILD DRIVE
# -------------------------------------------------------
.PHONY: build_nuc8bc
build_nuc8bc: $(AML_PRODUCTS)
	mkdir -p ./DRIVE/EFI/OC/ACPI/

	# clean output
	rm -f ./DRIVE/EFI/OC/ACPI/SSDT-*.aml
	rm -f ./DRIVE/EFI/OC/ACPI/SSDT.aml
	
	# copy files
	cp $(BUILDDIR)/SSDT-NUC8-BC.aml ./DRIVE/EFI/OC/ACPI/
	cp $(BUILDDIR)/SSDT-DDA.aml ./DRIVE/EFI/OC/ACPI/
	if [[ -e ./DRIVE/EFI/OC/ACPI/SSDT_CFLALT.aml ]]; then make install_cflalt; fi

# optional CoffeeLake Alternate configuration for systems where 0x3e9b0007 works better than 0x3ea50000.
.PHONY: build_cflalt
build_cflalt: $(AML_PRODUCTS)
	mkdir -p ./DRIVE/EFI/OC/ACPI/
	cp $(BUILDDIR)/SSDT_CFLALT.aml ./DRIVE/EFI/OC/ACPI/



# -------------------------------------------------------
# INSTALL TO SYSTEM DRIVE
# -------------------------------------------------------
.PHONY: install_nuc8bc
install_nuc8bc: $(AML_PRODUCTS)
	$(eval EFIDIR:=$(shell ./mount_efi.sh))
	
	# clean output
	rm -f "$(EFIDIR)"/EFI/CLOVER/ACPI/patched/SSDT-*.aml
	rm -f "$(EFIDIR)"/EFI/CLOVER/ACPI/patched/SSDT.aml
	
	# copy files
	cp $(BUILDDIR)/SSDT-NUC8-BC.aml "$(EFIDIR)"/EFI/OC/ACPI/
	cp $(BUILDDIR)/SSDT-DDA.aml "$(EFIDIR)"/EFI/OC/ACPI/
	if [[ -e "$(EFIDIR)"/EFI/OC/ACPI/SSDT_CFLALT.aml ]]; then make install_cflalt; fi

# optional CoffeeLake Alternate configuration for systems where 0x3e9b0007 works better than 0x3ea50000.
.PHONY: install_cflalt
install_cflalt: $(AML_PRODUCTS)
	$(eval EFIDIR:=$(shell ./mount_efi.sh))
	cp $(BUILDDIR)/SSDT_CFLALT.aml "$(EFIDIR)"/EFI/OC/ACPI/

