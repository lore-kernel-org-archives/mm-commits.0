From: akpm@linux-foundation.org
Subject: [folded] isdn-add-missing-kern_cont-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 16:13:29 -0700
Message-ID: <20120531231329.8361AA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:48400 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758592Ab2EaXNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 19:13:32 -0400
Received: by lagr15 with SMTP id r15so82859lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:13:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, isdn@linux-pingi.de, levinsasha928@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: isdn-add-missing-kern_cont-fix
has been removed from the -mm tree.  Its filename was
     isdn-add-missing-kern_cont-fix.patch

This patch was dropped because it was folded into isdn-add-missing-kern_cont.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: isdn-add-missing-kern_cont-fix

fix non-modular build

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/i4l/isdn_common.c~isdn-add-missing-kern_cont-fix drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~isdn-add-missing-kern_cont-fix
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -2362,7 +2362,7 @@ static int __init isdn_init(void)
 #ifdef MODULE
 	printk(KERN_CONT " loaded\n");
 #else
-	printk(KERN_CONG "\n");
+	printk(KERN_CONT "\n");
 #endif
 	isdn_info_update();
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

