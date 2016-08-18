From: akpm@linux-foundation.org
Subject: +
 sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch
 added to -mm tree
Date: Thu, 18 Aug 2016 15:02:56 -0700
Message-ID: <57b63090.37UP1jFBnnhgQXiv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51324 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754556AbcHSB5F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2016 21:57:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, subashab@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch

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
Subject: sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes

WARNING: please, no spaces at the start of a line
#101: FILE: kernel/sysctl.c:2297:
+    return do_proc_dointvec(table,write,buffer,lenp,ppos,$

ERROR: space required after that ',' (ctx:VxV)
#101: FILE: kernel/sysctl.c:2297:
+    return do_proc_dointvec(table,write,buffer,lenp,ppos,
                                  ^

ERROR: space required after that ',' (ctx:VxV)
#101: FILE: kernel/sysctl.c:2297:
+    return do_proc_dointvec(table,write,buffer,lenp,ppos,
                                        ^

ERROR: space required after that ',' (ctx:VxV)
#101: FILE: kernel/sysctl.c:2297:
+    return do_proc_dointvec(table,write,buffer,lenp,ppos,
                                               ^

ERROR: space required after that ',' (ctx:VxV)
#101: FILE: kernel/sysctl.c:2297:
+    return do_proc_dointvec(table,write,buffer,lenp,ppos,
                                                    ^

WARNING: ENOSYS means 'invalid syscall nr' and nothing else
#115: FILE: kernel/sysctl.c:2899:
+	return -ENOSYS;

total: 4 errors, 2 warnings, 74 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/sysctl-handle-error-writing-uint_max-to-u32-fields.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/sysctl.c~sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes
+++ a/kernel/sysctl.c
@@ -2274,8 +2274,7 @@ static int do_proc_dointvec(struct ctl_t
 int proc_dointvec(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_dointvec(table,write,buffer,lenp,ppos,
-		    	    NULL,NULL);
+    return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);
 }
 
 /**
@@ -2294,7 +2293,7 @@ int proc_dointvec(struct ctl_table *tabl
 int proc_douintvec(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_dointvec(table,write,buffer,lenp,ppos,
+    return do_proc_dointvec(table, write, buffer, lenp, ppos,
 			    do_proc_douintvec_conv, NULL);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

