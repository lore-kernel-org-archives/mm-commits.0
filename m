From: akpm@linux-foundation.org
Subject: [folded] alix2-supplement-driver-to-include-gpio-button-support-fix.patch removed from -mm tree
Date: Wed, 08 Feb 2012 12:40:11 -0800
Message-ID: <20120208204011.75923A03DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:63189 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2BHUkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 15:40:14 -0500
Received: by bkcjk13 with SMTP id jk13so38233bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 12:40:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dilinger@queued.net, kernel@wildgooses.com, philipp@redfish-solutions.com, mm-commits@vger.kernel.org


The patch titled
     Subject: alix2-supplement-driver-to-include-gpio-button-support-fix
has been removed from the -mm tree.  Its filename was
     alix2-supplement-driver-to-include-gpio-button-support-fix.patch

This patch was dropped because it was folded into alix2-supplement-driver-to-include-gpio-button-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: alix2-supplement-driver-to-include-gpio-button-support-fix

make Andres happy!

Cc: Andres Salomon <dilinger@queued.net>
Cc: Ed Wildgoose <kernel@wildgooses.com>
Cc: Philip A. Prindeville <philipp@redfish-solutions.com>
Cc: Philip Prindeville <philipp@redfish-solutions.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/geode/alix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/platform/geode/alix.c~alix2-supplement-driver-to-include-gpio-button-support-fix arch/x86/platform/geode/alix.c
--- a/arch/x86/platform/geode/alix.c~alix2-supplement-driver-to-include-gpio-button-support-fix
+++ a/arch/x86/platform/geode/alix.c
@@ -177,7 +177,7 @@ static bool __init alix_present_dmi(void
 	return true;
 }
 
-static int  __init alix_init(void)
+static int __init alix_init(void)
 {
 	const char tinybios_sig[] = "PC Engines ALIX.";
 	const char coreboot_sig[] = "PC Engines\0ALIX.";
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

