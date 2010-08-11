From: akpm@linux-foundation.org
Subject: mmotm 2010-08-11-16-10 uploaded
Date: Wed, 11 Aug 2010 16:10:49 -0700
Message-ID: <201008112340.o7BNenDe021017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab0HKXlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 19:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org

The mm-of-the-moment snapshot 2010-08-11-16-10 has been uploaded to

   http://userweb.kernel.org/~akpm/mmotm/

and will soon be available at

   git://zen-kernel.org/kernel/mmotm.git

It contains the following patches against 2.6.35:

origin.patch
kernel-kfifoc-add-handling-of-chained-scatterlists.patch
acpi-fix-bogus-preemption-logic.patch
mm-fix-fatal-kernel-doc-error.patch
pc8736x_gpio-depends-on-x86_32.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
parisc-fix-wrong-page-aligned-size-calculation-in-ioremapping-code.patch
fs-move-code-out-of-bufferc.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds.patch
writeback-add-comment-to-the-dirty-limit-functions.patch
writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch
writeback-fix-queue_io-ordering.patch
writeback-merge-for_kupdate-and-for_kupdate-cases.patch
mm-fix-writeback_in_progress.patch
mmc-add-erase-secure-erase-trim-and-secure-trim-operations.patch
mmc_block-add-discard-support.patch
omap_hsmmc-add-erase-capability.patch
block-add-secure-discard.patch
mmc_block-add-support-for-secure-discard.patch
mmc_test-add-performance-tests.patch
mmc_test-fix-large-memory-allocation.patch
memstick-init-sysfs-attributes.patch
memstick-fix-hangs-on-unexpected-device-removal-in-mspro_blk.patch
aio-always-reinitialize-iocb-ki_run_list-at-the-end-of-aio_run_iocb.patch
matroxfb-fix-incorrect-use-of-memcpy_toio.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
mm-vmap-area-cache.patch
backlight-fix-88pm860x_bl-macro-collision.patch
drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
drivers-acpi-debugfsc-needs-uaccessh.patch
drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
hpet-factor-timer-allocate-from-open.patch
timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch
kbuild-fix-config_cross_compile-issue-in-config.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch
backlight-fix-blanking-for-lms283gf05-lcd.patch
backlight-fix-blanking-for-l4f00242t03-lcd.patch
backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch
backlight-s6e63m0-fix-section-mismatch.patch
btusb-patch-add_apple_macbookpro62.patch
drivers-serial-68328serialc-check-return-value-of-copy__user-instead-of-access_ok.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
percpu-fix-list_head-init-bug-in-__percpu_counter_init.patch
drivers-scsi-qla4xxx-fix-build.patch
fs-bio-integrityc-remove-dependency-on-__gfp_nofail.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
drivers-usb-serial-io_tic-dont-return-0-if-writing-the-download-record-failed.patch
scsi-sr-add-no_read_disc_info-scsi_device-flag.patch
usb-storage-add-new-no_read_disc_info-quirk.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
scsi-sd-add-a-no_read_capacity_16-scsi_device-flag.patch
usb-storage-add-new-no_read_capacity_16-quirk.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm.patch
define-madv_hugepage.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
lib-div64c-document-that-div64_u64-is-not-precise-on-32bit-platforms.patch
s5pc110-sdhci-s3c-can-override-host-capabilities.patch
s5pc110-sdhci-s3c-support-on-s5pc110.patch
sdhci-add-no-hi-speed-bit-quirk-support.patch
sdhci-turn-timeout-timer-into-delayed-work.patch
sdhci-use-work-structs-instead-of-tasklets.patch
sdhci-use-work-structs-instead-of-tasklets-fix.patch
sdhci-clear-interrupt-status-register-just-once.patch
sdhci-use-threaded-irq-handler.patch
sdhci-turn-host-lock-into-a-mutex.patch
sdhci-get-rid-of-card-detect-work.patch
sdhci-get-rid-of-card-detect-work-fix.patch
sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch
sdhci-use-jiffies-instead-of-a-timeout-counter.patch
checkpatchpl-add-check-for-space-after-struct-or-union-definition.patch
jbd-remove-dependency-on-__gfp_nofail.patch
hfsplus-identify-journal-info-block-in-volume-header.patch
hfsplus-fix-journal-detection.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch
pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-add-async-pps-event-handler-fix.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
aio-do-not-return-erestartsys-and-friends-from-aio.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
vfs-take-2add-set_page_dirty_notag.patch
vfs-change-writeback_inodes-signature.patch
reiser4-export-remove_from_page_cache.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-rename-quota-methods.patch
reiser4-remove-inode_setattr.patch
reiser4-change-fsync-signature.patch
reiser4-writeback_inodes-implementation.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-writeback_inodes-implementation-adjust-to-writeback-changes.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch
reiser4-fixups.patch
reiser4-broke.patch
make-sure-nobodys-leaking-resources.patch
journal_add_journal_head-debug.patch
releasing-resources-with-children.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
add-debugging-aid-for-memory-initialisation-problems.patch
workaround-for-a-pci-restoring-bug.patch
prio_tree-debugging-patch.patch
single_open-seq_release-leak-diagnostics.patch
add-a-refcount-check-in-dput.patch
getblk-handle-2tb-devices.patch
