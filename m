From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
 removed from -mm tree
Date: Fri, 08 Aug 2014 14:01:53 -0700
Message-ID: <53e53ac1.ZwLTwVpvfZfsspbx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:43917 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430AbaHHVBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:01:54 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1561425pab.0
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:01:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch

This patch was dropped because it was folded into kexec-implementation-of-new-syscall-kexec_file_load.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes

WARNING: else is not generally useful after a break or return
#673: FILE: kernel/kexec.c:2024:
+		return locate_mem_hole_top_down(start, end, kbuf);
+	else

total: 0 errors, 1 warnings, 677 lines checked

./patches/kexec-implementation-of-new-syscall-kexec_file_load.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/kexec.c~kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes kernel/kexec.c
--- a/kernel/kexec.c~kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes
+++ a/kernel/kexec.c
@@ -2025,8 +2025,7 @@ static int locate_mem_hole_callback(u64
 	 */
 	if (kbuf->top_down)
 		return locate_mem_hole_top_down(start, end, kbuf);
-	else
-		return locate_mem_hole_bottom_up(start, end, kbuf);
+	return locate_mem_hole_bottom_up(start, end, kbuf);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-pcf85063-support.patch
proc-remove-proc_tty_ldisc-variable.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
panic-add-taint_softlockup.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch

