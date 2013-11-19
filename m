From: akpm@linux-foundation.org
Subject: +
 kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch added to -mm tree
Date: Mon, 18 Nov 2013 16:01:49 -0800
Message-ID: <528aaa6d.OMDMFIhORCi215Ss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KSABu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 19:01:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, felipe.contreras@gmail.com, akpm@linux-foundation.org

Subject: + kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,felipe.contreras@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 16:01:49 -0800


The patch titled
     Subject: kernel-paramsc-improve-standard-definitions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch

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
Subject: kernel-paramsc-improve-standard-definitions-checkpatch-fixes

WARNING: please, no space before tabs
#25: FILE: kernel/params.c:230:
+#define STANDARD_PARAM_DEF(name, type, format, strtolfn)      ^I^I\$

total: 0 errors, 1 warnings, 39 lines checked

./patches/kernel-paramsc-improve-standard-definitions.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Felipe Contreras <felipe.contreras@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/params.c~kernel-paramsc-improve-standard-definitions-checkpatch-fixes kernel/params.c
--- a/kernel/params.c~kernel-paramsc-improve-standard-definitions-checkpatch-fixes
+++ a/kernel/params.c
@@ -227,7 +227,7 @@ int parse_args(const char *doing,
 }
 
 /* Lazy bastard, eh? */
-#define STANDARD_PARAM_DEF(name, type, format, strtolfn)      		\
+#define STANDARD_PARAM_DEF(name, type, format, strtolfn)		\
 	int param_set_##name(const char *val, const struct kernel_param *kp) \
 	{								\
 		return strtolfn(val, 0, (type *)kp->arg);		\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

