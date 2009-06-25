From: akpm@linux-foundation.org
Subject: mmotm 2009-06-25-15-49 uploaded
Date: Thu, 25 Jun 2009 15:49:36 -0700
Message-ID: <200906252249.n5PMnaPt016847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbZFYWts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 18:49:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org

The mm-of-the-moment snapshot 2009-06-25-15-49 has been uploaded to

   http://userweb.kernel.org/~akpm/mmotm/

and will soon be available at

   git://git.zen-sources.org/zen/mmotm.git

It contains the following patches against 2.6.31-rc1:

eventfd-revised-interface-and-cleanups-4th-rev.patch
gcov-fix-__ctors_start-alignment.patch
maintainers-update-edac-i82975x.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
kernel-core-add-smp_call_function_any.patch
kernel-core-add-smp_call_function_any-update.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
pcmcia-pccard-deadlock-fix.patch
video-initial-support-for-adv7180.patch
posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
input-more-i8042-reset-quirks-for-msi-wind-clone-netbooks.patch
input-tsc2007-remove-hr-timer.patch
input-tsc2007-make-platform-callbacks-optional.patch
mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch
omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma.patch
jffs2-move-jffs2_gcd_mtd-threads-to-the-new-kthread-api.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
nand-add-new-ecc-mode-ecc_hw_oob_first.patch
3x59x-fix-pci-resource-management.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
parisc-remove-obsolete-hw_interrupt_type.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
icom-converting-space-to-tabs.patch
serial-8250c-irq-handling-race-and-spurious-iir-read.patch
serial-add-parameter-to-force-skipping-the-test-for-the-txen-bug.patch
hypfs-remove-useless-variable-qname.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-improve-comment-describing-fget_light.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch
mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization.patch
xtensa-variant-specific-code.patch
mm.patch
parport-serial-add-support-for-netmos-9901-multi-io-card.patch
edac-add-ddr3-memory-type-for-mpc85xx-edac.patch
elf-limit-max-map-count-to-safe-value.patch
ext2-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch
genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch
dmapools-protect-page_list-walk-in-show_pools.patch
spi-new-spi-mode-bits.patch
spi-add-spi_master-flag-word.patch
fbdev-add-mutex-for-fb_mmap-locking.patch
spi-bitbang-bugfix-in-message-setup.patch
kernel-resourcec-fix-sign-extension-in-reserve_setup.patch
maintainers-starfire-duralan-update.patch
bsdacct-fix-access-to-invalid-filp-in-acct_on.patch
mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
cpusets-document-adding-removing-cpus-to-cpuset-elaborately.patch
alpha-fix-2630-smp-build.patch
cciss-fix-the-termination-of-the-scanning-thread.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
rework-fix-is_single_threaded.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
drivers-hwmon-coretempc-enable-the-intel-atom.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
procfs-provide-stack-information-for-threads-v08.patch
spi-remove-imx-spi-driver.patch
spi-add-spi-driver-for-most-known-imx-socs.patch
sunrpc-use-formatting-of-module-name-in-sunrpc.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links.patch
gpio-add-mc33880-driver.patch
omapfb-add-support-for-the-apollon-lcd.patch
omapfb-add-support-for-mipi-dcs-compatible-lcds.patch
omapfb-add-support-for-the-amstrad-delta-lcd.patch
omapfb-add-support-for-the-2430sdp-lcd.patch
omapfb-add-support-for-the-omap2evm-lcd.patch
omapfb-add-support-for-the-3430sdp-lcd.patch
omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch
omapfb-add-support-for-the-gumstix-overo-lcd.patch
omapfb-add-support-for-the-zoom-mdk-lcd.patch
omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl.patch
n770-enable-lcd-mipi-dcs-in-kconfig.patch
omapfb-dispc-various-typo-fixes.patch
omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
omapfb-dispc-enable-wake-up-capability.patch
omapfb-dispc-allow-multiple-external-irq-handlers.patch
omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch
omapfb-fix-coding-style-remove-dead-line.patch
omapfb-add-fb-manual-update-option-to-kconfig.patch
omapfb-hwa742-fix-pointer-to-be-const.patch
platinumfb-misplaced-parenthesis.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch
hfsplus-identify-journal-info-block-in-volume-header.patch
hfsplus-fix-journal-detection.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
bzip2-lzma-gzip-fix-comments-describing-decompressor-api.patch
bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
lzma-gzip-fix-potential-oops-when-input-data-is-truncated.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4-export-remove_from_page_cache.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
reiser4-update-names-of-quota-methods.patch
reiser4-use-set_page_dirty_notag.patch
make-sure-nobodys-leaking-resources.patch
journal_add_journal_head-debug.patch
releasing-resources-with-children.patch
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
