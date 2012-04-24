From: akpm@linux-foundation.org
Subject: + leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch added to -mm tree
Date: Tue, 24 Apr 2012 14:06:22 -0700
Message-ID: <20120424210622.550B8A009E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:45775 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab2DXVGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Apr 2012 17:06:24 -0400
Received: by wibhj13 with SMTP id hj13so62607wib.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Apr 2012 14:06:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, holler@ahsoftware.de, rpurdie@rpsys.net, shuahkhan@gmail.com


The patch titled
     Subject: leds-heartbeat-stop-on-shutdown-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: leds-heartbeat-stop-on-shutdown-checkpatch-fixes

ERROR: space prohibited after that '!' (ctx:WxW)
#45: FILE: drivers/leds/ledtrig-heartbeat.c:121:
+	if( ! rc )
 	    ^

ERROR: space prohibited after that open parenthesis '('
#45: FILE: drivers/leds/ledtrig-heartbeat.c:121:
+	if( ! rc )

ERROR: space prohibited before that close parenthesis ')'
#45: FILE: drivers/leds/ledtrig-heartbeat.c:121:
+	if( ! rc )

ERROR: space required before the open parenthesis '('
#45: FILE: drivers/leds/ledtrig-heartbeat.c:121:
+	if( ! rc )

total: 4 errors, 0 warnings, 36 lines checked

./patches/leds-heartbeat-stop-on-shutdown.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexander Holler <holler@ahsoftware.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Shuah Khan <shuahkhan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-heartbeat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/leds/ledtrig-heartbeat.c~leds-heartbeat-stop-on-shutdown-checkpatch-fixes drivers/leds/ledtrig-heartbeat.c
--- a/drivers/leds/ledtrig-heartbeat.c~leds-heartbeat-stop-on-shutdown-checkpatch-fixes
+++ a/drivers/leds/ledtrig-heartbeat.c
@@ -118,7 +118,8 @@ static struct notifier_block heartbeat_r
 static int __init heartbeat_trig_init(void)
 {
 	int rc = led_trigger_register(&heartbeat_led_trigger);
-	if( ! rc )
+
+	if (!rc)
 		register_reboot_notifier(&heartbeat_reboot_nb);
 	return rc;
 }
_
Subject: Subject: leds-heartbeat-stop-on-shutdown-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
sound-usb-endpointc-suppress-warning.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

