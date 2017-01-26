From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 26 Jan 2017 13:14:43 -0800
Message-ID: <588a66c3.lc/pK+BCAkLiJ1lc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753022AbdAZVPl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2017 16:15:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pinctrl/pinctrl-amd.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/pinctrl/pinctrl-amd.c~linux-next-git-rejects drivers/pinctrl/pinctrl-amd.c
--- a/drivers/pinctrl/pinctrl-amd.c~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-amd.c
@@ -202,10 +202,6 @@ static void amd_gpio_dbg_show(struct seq
 			i = 128;
 			pin_num = AMD_GPIO_PINS_BANK2 + i;
 			break;
-<<<<<<< HEAD
-		default:
-			return;
-=======
 		case 3:
 			i = 192;
 			pin_num = AMD_GPIO_PINS_BANK3 + i;
@@ -213,7 +209,6 @@ static void amd_gpio_dbg_show(struct seq
 		default:
 			/* Illegal bank number, ignore */
 			continue;
->>>>>>> linux-next/akpm-base
 		}
 		for (; i < pin_num; i++) {
 			seq_printf(s, "pin%d\t", i);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

