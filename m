From: akpm@linux-foundation.org
Subject: + scripts-spellingtxt-fix-incorrect-typo-words-fix.patch added to -mm tree
Date: Mon, 06 Feb 2017 16:37:27 -0800
Message-ID: <589916c7.VA604FYMI/W1lkN4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37388 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdBGAh2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 19:37:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-spellingtxt-fix-incorrect-typo-words-fix
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-fix-incorrect-typo-words-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-fix-incorrect-typo-words-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-fix-incorrect-typo-words-fix.patch

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
Subject: scripts-spellingtxt-fix-incorrect-typo-words-fix

"licencing" is valid British spelling and should be kept, per Joe

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/spelling.txt~scripts-spellingtxt-fix-incorrect-typo-words-fix scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-fix-incorrect-typo-words-fix
+++ a/scripts/spelling.txt
@@ -604,7 +604,7 @@ libaries||libraries
 libary||library
 librairies||libraries
 libraris||libraries
-licenceing||licensing
+licenceing||licencing
 loggging||logging
 loggin||login
 logile||logfile
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
scripts-spellingtxt-fix-incorrect-typo-words-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

