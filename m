From: akpm@linux-foundation.org
Subject: [folded] avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:22:09 -0700
Message-ID: <20120730212210.6AF3D100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43046 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3VWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:22:13 -0400
Received: by obbwc20 with SMTP id wc20so4007383obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:22:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, consul.kautuk@gmail.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, mohdfarisq2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix
has been removed from the -mm tree.  Its filename was
     avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch

This patch was dropped because it was folded into avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix

fix comment layout

Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Havard Skinnemoen <hskinnemoen@gmail.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Mohd. Faris <mohdfarisq2010@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/fault.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/avr32/mm/fault.c~avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix
+++ a/arch/avr32/mm/fault.c
@@ -153,11 +153,11 @@ good_area:
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 
-			 /* No need to up_read(&mm->mmap_sem) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
+			/*
+			 * No need to up_read(&mm->mmap_sem) as we would have
+			 * already released it in __lock_page_or_retry() in
+			 * mm/filemap.c.
 			 */
-
 			goto retry;
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
minixfs-fix-block-limit-check-fix.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch

