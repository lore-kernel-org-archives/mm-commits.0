From: akpm@linux-foundation.org
Subject: [folded] printk-add-generic-functions-to-find-kern_level-headers-fix.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:22:49 -0700
Message-ID: <20120730212249.D03A81E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:64700 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3VWv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:22:51 -0400
Received: by obbwc20 with SMTP id wc20so4007822obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:22:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, kay.sievers@vrfy.org, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-add-generic-functions-to-find-kern_level-headers-fix
has been removed from the -mm tree.  Its filename was
     printk-add-generic-functions-to-find-kern_level-headers-fix.patch

This patch was dropped because it was folded into printk-add-generic-functions-to-find-kern_level-headers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: printk-add-generic-functions-to-find-kern_level-headers-fix

fix build error and warning

kernel/printk.c:1357: error: label at end of compound statement
kernel/printk.c:1360: warning: assignment discards qualifiers from pointer target type

Cc: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-add-generic-functions-to-find-kern_level-headers-fix kernel/printk.c
--- a/kernel/printk.c~printk-add-generic-functions-to-find-kern_level-headers-fix
+++ a/kernel/printk.c
@@ -1563,7 +1563,7 @@ asmlinkage int vprintk_emit(int facility
 			break;
 		}
 		text_len -= end_of_header - text;
-		text = end_of_header;
+		text = (char *)end_of_header;
 	}
 
 	if (level == -1)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
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

