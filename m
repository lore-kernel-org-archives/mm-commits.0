From: akpm@linux-foundation.org
Subject: + kasan-various-fixes-in-documentation-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 14 Sep 2015 14:48:10 -0700
Message-ID: <55f7409a.ywTfVWovAdc4xPJV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbINVsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-various-fixes-in-documentation-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kasan-various-fixes-in-documentation-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-various-fixes-in-documentation-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-various-fixes-in-documentation-checkpatch-fixes.patch

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
Subject: kasan-various-fixes-in-documentation-checkpatch-fixes

WARNING: 'happend' may be misspelled - perhaps 'happened'?
#79: FILE: Documentation/kasan.txt:121:
+The header of the report discribe what kind of bug happend and what kind of

total: 0 errors, 1 warnings, 82 lines checked

./patches/kasan-various-fixes-in-documentation.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kasan.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kasan.txt~kasan-various-fixes-in-documentation-checkpatch-fixes Documentation/kasan.txt
--- a/Documentation/kasan.txt~kasan-various-fixes-in-documentation-checkpatch-fixes
+++ a/Documentation/kasan.txt
@@ -118,7 +118,7 @@ Memory state around the buggy address:
  ffff8800693bc800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================
 
-The header of the report discribe what kind of bug happend and what kind of
+The header of the report discribe what kind of bug happened and what kind of
 access caused it. It's followed by the description of the accessed slub object
 (see 'SLUB Debug output' section in Documentation/vm/slub.txt for details) and
 the description of the accessed memory page.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

