From: akpm@linux-foundation.org
Subject: mmotm 2010-11-03-12-17 uploaded
Date: Wed, 03 Nov 2010 12:18:16 -0700
Message-ID: <201011031919.oA3JJgkF008936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921Ab0KCTTo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Nov 2010 15:19:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org

The mm-of-the-moment snapshot 2010-11-03-12-17 has been uploaded to

   http://userweb.kernel.org/~akpm/mmotm/

and will soon be available at

   git://zen-kernel.org/kernel/mmotm.git

It contains the following patches against 2.6.36:

origin.patch
hpet-factor-timer-allocate-from-open.patch
um-fix-ptrace-build-error.patch
include-linux-fsh-needs-typesh.patch
drivers-macintosh-adb-iopc-flags-should-be-unsigned-long.patch
rapidio-use-resource_size.patch
scripts-kernel-doc-escape-special-characters-for-xml-struct-output.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-misc-isl29020c-fix-signedness-bug.patch
drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch
drivers-misc-apds9802alsc-fix-signedness-bug.patch
memcg-null-dereference-on-allocation-failure.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
fuse-clear-attribute-cache-for-openo_trunc.patch
ipc-shmc-fix-information-leak-to-userland.patch
mm-vmap-area-cache.patch
arch-arm-plat-omap-iovmmc-fix-end-address-of-vm-area-comparation-in-alloc_iovm_area.patch
audit-call-tty_audit_push_task-outside-preempt-disabled.patch
audit-do-not-send-uninitialized-data-for-audit_tty_get.patch
audit-use-rcu-for-task-lookup-protection.patch
backlight-fix-88pm860x_bl-macro-collision.patch
cciss-fix-botched-tag-masking-for-scsi-tape-commands.patch
ibm_rtl-fix-printk-format-warning.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
audit-add-support-to-match-lsm-labels-on-user-audit-messages.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
drivers-dma-kconfig-add-part-number-for-topcliff.patch
drivers-char-pcmcia-cm4000_csc-fix-error-code.patch
powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
drivers-media-video-gspca-cpia1c-fix-error-check.patch
ecryptfs-fix-truncation-error-in-ecryptfs_read_update_atime.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
led-class-always-implement-blinking.patch
leds-driver-for-national-semiconductor-lp5521-chip.patch
leds-driver-for-national-semiconductors-lp5523-chip.patch
leds-update-lp552x-support-kconfig-and-makefile.patch
documentation-led-drivers-lp5521-and-lp5523.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
gpio-led-properly-initialize-return-value.patch
mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch
isdn-capi-unregister-capictr-notifier-after-init-failure.patch
isdn-capi-make-kcapi-use-a-separate-workqueue.patch
net-avoid-limits-overflow.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch
backlight-fix-blanking-for-lms283gf05-lcd.patch
backlight-fix-blanking-for-l4f00242t03-lcd.patch
backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch
backlight-s6e63m0-fix-section-mismatch.patch
backlight-add-low-threshold-to-pwm-backlight.patch
video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch
drivers-video-backlight-adp8860_blc-check-strict_strtoul-return-value.patch
btusb-patch-add_apple_macbookpro62.patch
drivers-char-amiserialc-remove-unused-variable-icount.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
drivers-crypto-dubious-error-check.patch
n_hdlc-fix-read-and-write-locking.patch
n_hdlc-fix-read-and-write-locking-update.patch
mm.patch
mm-smaps-export-mlock-information.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
define-madv_hugepage.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
maintainers-intel-gfx-is-a-subscribers-only-mailing-list.patch
percpucounter-optimize-__percpu_counter_add-a-bit-through-the-use-of-this_cpu-operations.patch
drivers-mmc-host-omapc-use-resource_size.patch
drivers-mmc-host-omap_hsmmcc-use-resource_size.patch
epoll-convert-max_user_watches-to-long.patch
binfmt_elf-cleanups.patch
rtc-add-real-time-clock-driver-for-nvidia-tegra.patch
cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
rapidio-use-common-destid-storage-for-endpoints-and-switches.patch
rapidio-integrate-rio_switch-into-rio_dev.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch
nfc-driver-for-nxp-semiconductors-pn544-nfc-chip.patch
remove-dma64_addr_t.patch
kernel-profilec-use-vzalloc.patch
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
memstick-a-few-changes-to-core.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
memstick-core-fix-device_register-error-handling.patch
w1-ds2423-counter-driver-and-documentation.patch
kernel-relayc-relay_alloc_page_array-use-vzalloc.patch
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
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
