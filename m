From: akpm@linux-foundation.org
Subject: mmotm 2009-09-25-14-35 uploaded
Date: Fri, 25 Sep 2009 14:35:46 -0700
Message-ID: <200909252158.n8PLwFhG024011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZIYV6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 17:58:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org

The mm-of-the-moment snapshot 2009-09-25-14-35 has been uploaded to

   http://userweb.kernel.org/~akpm/mmotm/

and will soon be available at

   git://git.zen-sources.org/zen/mmotm.git

It contains the following patches against 2.6.31:

origin.patch
module-fix-up-config_kallsyms=3Dn-build.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by=
-using-smp_call_function_any.patch
dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-ch=
anging-the-softblock-status.patch
acpi-reintroduce-acpi_device_ops-shutdown-method.patch
cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs5535-gpio-request-function-mask-names-added.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimi=
zation.patch
agp-correct-missing-cleanup-on-error-in-agp_add_bridge.patch
avr32-convert-to-asm-generic-hardirqh.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hpilo-add-locking-comment.patch
drm-via-add-pci-id-for-via-vx800-chipset.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
ia64-use-printk_once.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sys=
fs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.p=
atch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
kconfig-cross_compile-option.patch
ide-use-printk_once.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
isdn-hisax-fix-lock-imbalance.patch
hfc_usb-fix-read-buffer-overflow.patch
isdn-fix-netjet-build-errors.patch
misdn-fix-reversed-if-in-st_own_ctrl.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
sunrpc-use-formatting-of-module-name-in-sunrpc.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
serial-add-parameter-to-force-skipping-the-test-for-the-txen-bug.patch
drivers-md-introduce-missing-kfree.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
scsi-fix-func-names-in-kernel-doc.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.pat=
ch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
sparc32-convert-to-asm-generic-hardirqh.patch
synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-c=
ode.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-val=
ue-from-task_struct-to-mm_struct.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-improve-comment-describing-fget_light.patch
ecryptfs-another-lockdep-issue.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
xtensa-use-generic-sys_pipe.patch
xtensa-convert-to-asm-generic-hardirqh.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
mm.patch
ksm-more-on-default-values.patch
mm-includecheck-fix-vmallocc.patch
fs-includecheck-fix-proc-kcorec.patch
video-includecheck-fix-msm-mddic.patch
video-includecheck-fix-da8xx-fbc.patch
cgroups-update-documentation-of-cgroups-tasks-and-procs-files.patch
drivers-input-inputc-fix-config_pm=3Dn-warning.patch
x86-_end-symbol-missing-from-symbolmap.patch
sched-fix-htmldocs-schedc.patch
scsi_libc-avoid-calling-scsi_device_put-from-under-host_lock.patch
hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-inf=
o.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
readahead-add-blk_run_backing_dev.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch
pcmcia-fix-controller-printk-warnings.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cris-convert-to-use-arch_gettimeoffset.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch
mmc-make-the-configuration-memory-resource-optional.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch
sdio-recognize-io-card-without-powercycle.patch
sdio-pass-whitelisted-cis-funce-tuples-to-sdio-drivers.patch
hwmon-driver-for-texas-instruments-amc6821-chip.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.pat=
ch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch
hfsplus-identify-journal-info-block-in-volume-header.patch
hfsplus-fix-journal-detection.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-l=
ist.patch
utrace-core.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in=
=2Epatch
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
fs-reiser4-add-parenths-around-x-y.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
make-sure-nobodys-leaking-resources.patch
journal_add_journal_head-debug.patch
releasing-resources-with-children.patch
make-frame_pointer-default=3Dy.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
add-debugging-aid-for-memory-initialisation-problems.patch
keep-track-of-network-interface-renaming.patch
workaround-for-a-pci-restoring-bug.patch
prio_tree-debugging-patch.patch
single_open-seq_release-leak-diagnostics.patch
add-a-refcount-check-in-dput.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
