From: akpm@linux-foundation.org
Subject: + mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch added to -mm tree
Date: Mon, 30 Jan 2012 12:41:59 -0800
Message-ID: <20120130204159.D4B8CA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:33186 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab2A3UmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 15:42:03 -0500
Received: by bkas6 with SMTP id s6so297232bka.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 12:42:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, carsteno@de.ibm.com, cotte@de.ibm.com, hughd@google.com


The patch titled
     Subject: mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix
has been added to the -mm tree.  Its filename is
     mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch

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
Subject: mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix

use conventional (and consistent) comment layout

Cc: Carsten Otte <carsteno@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/filemap_xip.c~mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix
+++ a/mm/filemap_xip.c
@@ -263,8 +263,10 @@ found:
 							xip_pfn);
 		if (err == -ENOMEM)
 			return VM_FAULT_OOM;
-		/* err == -EBUSY is fine, we've raced against another thread
-		   that faulted-in the same page */
+		/*
+		 * err == -EBUSY is fine, we've raced against another thread
+		 * that faulted-in the same page
+		 */
 		if (err != -EBUSY)
 			BUG_ON(err);
 		return VM_FAULT_NOPAGE;
_
Subject: Subject: mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

