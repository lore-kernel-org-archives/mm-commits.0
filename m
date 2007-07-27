From: akpm@linux-foundation.org
Subject: + libata-store-bus-addresses-versus-mm-for-testing-fix.patch added to -mm tree
Date: Thu, 26 Jul 2007 23:18:21 -0700
Message-ID: <200707270618.l6R6IL0v009068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934512AbXG0GSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 02:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata-store-bus-addresses-versus-mm-for-testing-fix
has been added to the -mm tree.  Its filename is
     libata-store-bus-addresses-versus-mm-for-testing-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata-store-bus-addresses-versus-mm-for-testing-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_isapnp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/pata_isapnp.c~libata-store-bus-addresses-versus-mm-for-testing-fix drivers/ata/pata_isapnp.c
--- a/drivers/ata/pata_isapnp.c~libata-store-bus-addresses-versus-mm-for-testing-fix
+++ a/drivers/ata/pata_isapnp.c
@@ -112,7 +112,7 @@ static int isapnp_init_one(struct pnp_de
 		ap->busaddr.ctl_addr = pnp_port_start(idev, 1);
 	}
 
-	ata_std_io_ports(&ap->ioaddr);
+	ata_std_io_ports(&ap->ioaddr, &ap->busaddr);
 
 	/* activate */
 	return ata_host_activate(host, pnp_irq(idev, 0), ata_interrupt, 0,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-stk17ta8-update-for-sysfs-api-change.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
i2c-ds1682-warning-fix.patch
edac-is-bust-on-mips.patch
codingstyle-proscribe-do-while-without-braces-fix.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
kdebugh-forward-declare-struct-struct-notifier_block.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-mark_tsc_unstable-build-fix.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
git-kvm-fixup.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
libata-store-bus-addresses-versus-mm-for-testing-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
ide-bodge-things-around-to-make-arm-work.patch
mmc-build-fix.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
ip_auto_config-fix-fix.patch
fib_trie-cleanup-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-scsi-rc-fixes.patch
git-block-fix-headers_check.patch
git-block-whoops.patch
git-unionfs.patch
git-unionfs-fixup.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-watchdog.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
ip2main-warning-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
tpm_tis-debug.patch
w1-build-fix.patch
