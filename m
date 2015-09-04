From: akpm@linux-foundation.org
Subject: [folded-merged]
 scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch removed from -mm tree
Date: Fri, 04 Sep 2015 15:23:56 -0700
Message-ID: <55ea19fc.g4nAE0x17nKNdl/T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760260AbbIDWX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, maninder1.s@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-spellingtxt-adding-misspelled-word-for-check-fix
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch

This patch was dropped because it was folded into scripts-spellingtxt-adding-misspelled-word-for-check.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts-spellingtxt-adding-misspelled-word-for-check-fix

add whcih->which, whcih I always get wrong

Cc: Kees Cook <keescook@chromium.org>
Cc: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/spelling.txt~scripts-spellingtxt-adding-misspelled-word-for-check-fix scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-adding-misspelled-word-for-check-fix
+++ a/scripts/spelling.txt
@@ -1031,6 +1031,7 @@ visiters||visitors
 vitual||virtual
 wating||waiting
 whataver||whatever
+whcih||which
 whenver||whenever
 wheter||whether
 whe||when
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-activate-syscall-fix-2.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch

