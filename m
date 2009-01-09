From: akpm@linux-foundation.org
Subject: mmotm 2009-01-09-12-12 uploaded
Date: Fri, 09 Jan 2009 12:13:33 -0800
Message-ID: <200901092013.n09KDXg2011856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955AbZAIUN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 15:13:57 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n09KDYY0020958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 9 Jan 2009 12:13:35 -0800
Received: from localhost.localdomain (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id n09KDXg2011856
	for <mm-commits@vger.kernel.org>; Fri, 9 Jan 2009 12:13:33 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org

The mm-of-the-moment snapshot 2009-01-09-12-12 has been uploaded to

   http://userweb.kernel.org/~akpm/mmotm/

and will soon be available at

   git://git.zen-sources.org/zen/mmotm.git

It contains the following patches against 2.6.28:

origin.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
next-remove-localversion.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
acpi-check-_pss-invalidation-when-bios-report-_pss-with-all-0x80000000.patch
eeepc-laptop-enable-bluetooth-for-asus-eee-901.patch
misc-add-dell-wmi-driver-for-hotkey-control.patch
drivers-acpi-hardware-hwsleepc-fix-warning-msg.patch
acpi-dock-terminate-eject-request-is-the-dock-is-not-present.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-only-scan-the-root-bus-in-early-pci-quirks.patch
x86-hpet-allow-force-enable-on-ich10-hpet.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
x86-avoid-theoretical-vmalloc-fault-loop.patch
kgdb-fix-kernel-doc-error.patch
pcmcia-pccard-deadlock-fix.patch
i2c-fix-i2c-mpc-driver-for-multi-master-i2c-busses.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
clocksource-add-enable-and-disable-callbacks.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
serio_raw-add-support-for-translated-serio_i8042xl-ports.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
i8042-add-blue-fb5601-to-noloop-execption-table.patch
input-ad7879-touchscreen-driver.patch
input-mouse-alpsc-handle-touchpoints-buttons-correctly.patch
input-ads7846c-sparse-lock-annotation.patch
drivers-input-keyboard-atkbdc-use-function-for-generation-of-keyrelease-events.patch
drivers-input-keyboard-atkbdc-make-forced_release_keys-static.patch
drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks.patch
input-uvc-the-button-on-the-camera-is-key_camera.patch
input-allow-certain-ev_abs-events-to-bypass-all-filtering.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2.patch
input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch
dmar-fix-endless-unknown-dmar-structure-type-loop.patch
leds-add-a-dac124s085-spi-led-driver.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
ricoh_mmc-use-suspend-resume_noirq-v2.patch
physmap-make-map_info-customizable.patch
jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
mtd-fix-nettel-printk-formats.patch
net-tipc-bcasth-use-array_size.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch
misdn-indentation-braces-disagree-add-braces.patch
misdn-one-handmade-array_size-converted.patch
misdn-indentation-and-braces-disagree-add-braces.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch
netdev-gianfar-add-mii-ioctl-handler.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
3x59x-fix-pci-resource-management.patch
video-mbp_nvidia_bl-fix-brightness-after-suspend-hibernation.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch
video-mbp_nvidia_bl-add-a-debug-switch.patch
gpio_free-might-sleep-blackfin-architecture.patch
ext4-allocate-s_blockgroup_lock-separately.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-tighten-restrictions-on-inode-flags.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
pci-msi-bugfix-utilize-for-msi_capability_init.patch
fakephp-allocate-pci-resources-before-adding-the-device.patch
aerdrv-fix-sanity-check-in-report_resume.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
kernel-trace-ring_bufferc-use-div_round_up-fix.patch
irq-free-setup_irq-interrupt-using-free_irq.patch
if-0-ses_match_host.patch
scsi-replace-__inline-with-inline.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
esp-fix-section-mismatch-warning.patch
scsi-fix-bad-use-of-udelay-in-atp870uc.patch
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
bio-zero-inlined-bio_vec.patch
radio-si470x-add-usb-id-for-dealextreme-usb-radio.patch
usb-another-unusual_devs-entry-for-another-bad-argosy-storage-device.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-qe-usb-controller-initialization.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
pika-warp-appliance-watchdog-timer.patch
mm.patch
core_dump_default_elf_headers-depends-on-elf_core.patch
compiler-gcch-add-more-comments-to-reloc_hide.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-shmemc-fix-division-by-zero.patch
mm-fix-pdflush-thread-creation-upper-bound.patch
mm-add-proc-controls-for-pdflush-threads.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
hp-wmi-handle-rfkill_register-failure.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
atmel_serial-might-lose-modem-status-change.patch
8250_pci-add-support-for-netmos-9835.patch
max3100-spi-uart-driver.patch
max3100-spi-uart-driver-fix.patch
max3100-spi-uart-driver-select-serial_core.patch
sm501-fix-section-mismatches.patch
intelfb-support-i854.patch
hfsplus-identify-journal-info-block-in-volume-header.patch
hfsplus-fix-journal-detection.patch
ufs-sector_t-cannot-be-negative.patch
relay-reset-consumed.patch
trace-code-and-documentation.patch
trace-code-and-documentation-merging-documentation-tracetxt-with-documentation-filesystems-relaytxt.patch
trace-sample.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
usb-use-unaligned-endian-helpers-in-storage-drivers.patch
filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
filesystem-freeze-implement-generic-freeze-feature.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch
linuxpps-core-support.patch
linuxpps-core-support-sysfs-not-needed-variables-removed.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch
nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-inode-operations.patch
nilfs2-inode-operations-fix.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-pathname-operations-fix.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-super-block-operations-fix.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
nilfs2-cleanup-nilfs_clear_inode.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-insert-explanations-in-gcinode-file.patch
nilfs2-add-maintainer.patch
nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4-export-remove_from_page_cache.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
make-sure-nobodys-leaking-resources.patch
journal_add_journal_head-debug.patch
releasing-resources-with-children.patch
nr_blockdev_pages-in_interrupt-warning.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
add-debugging-aid-for-memory-initialisation-problems.patch
shrink_slab-handle-bad-shrinkers.patch
keep-track-of-network-interface-renaming.patch
workaround-for-a-pci-restoring-bug.patch
prio_tree-debugging-patch.patch
single_open-seq_release-leak-diagnostics.patch
add-a-refcount-check-in-dput.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch
