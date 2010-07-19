From: akpm@linux-foundation.org
Subject: + gpio-sx150x-add-semtech-i2c-sx150x-gpio-expander-driver-fix.patch added to -mm tree
Date: Mon, 19 Jul 2010 16:02:26 -0700
Message-ID: <201007192331.o6JNVoAo027185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab0GSXcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Jul 2010 19:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david-b@pacbell.net, gbean@codeaurora.org, khali@linux-fr.org, tsoni@codeaurora.org


The patch titled
     gpio-sx150x-add-semtech-i2c-sx150x-gpio-expander-driver-fix
has been added to the -mm tree.  Its filename is
     gpio-sx150x-add-semtech-i2c-sx150x-gpio-expander-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-sx150x-add-semtech-i2c-sx150x-gpio-expander-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

s/tristate/bool/ to fix allmodonfig

Cc: David Brownell <david-b@pacbell.net>
Cc: Gregory Bean <gbean@codeaurora.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Trilok Soni <tsoni@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/Kconfig~gpio-sx150x-add-semtech-i2c-sx150x-gpio-expander-driver-fix drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-sx150x-add-semtech-i2c-sx150x-gpio-expander-driver-fix
+++ a/drivers/gpio/Kconfig
@@ -203,7 +203,7 @@ config GPIO_STMPE
 	  Expanders.
 
 config GPIO_SX150X
-	tristate "Semtech SX150x I2C GPIO expander"
+	bool "Semtech SX150x I2C GPIO expander"
 	depends on I2C
 	default n
 	help
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
mm-vmap-area-cache-fix.patch
x86-numa-fix-boot-without-ram-on-node0-again-fix.patch
linux-next.patch
next-remove-localversion.patch
revert-driver-core-remove-config_sysfs_deprecated.patch
revert-sysfs-dont-allow-the-creation-of-symlinks-we-cant-remove.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
acpi-fix-bogus-preemption-logic-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
acer-wmi-fix-memory-leaks-in-wmab_execute-error-path-v2-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
fs-squashfs-xattrc-fix-warning.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
drivers-net-82596c-fix-warning.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
serial-mmio32-support-for-8250_earlyc-fix-fix.patch
security-add-const-to-security_task_setscheduler-fix.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
gpio-sx150x-add-semtech-i2c-sx150x-gpio-expander-driver-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

