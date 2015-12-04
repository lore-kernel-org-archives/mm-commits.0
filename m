From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 03 Dec 2015 16:49:31 -0800
Message-ID: <5660e31b.Jd7nF6nhoRA4fkoZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbbLDAtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2015 19:49:32 -0500
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

 drivers/spi/spi-mt65xx.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/spi/spi-mt65xx.c~linux-next-git-rejects drivers/spi/spi-mt65xx.c
--- a/drivers/spi/spi-mt65xx.c~linux-next-git-rejects
+++ a/drivers/spi/spi-mt65xx.c
@@ -634,11 +634,7 @@ static int mtk_spi_probe(struct platform
 			dev_err(&pdev->dev,
 				"cs_gpios not specified and num_chipselect > 1\n");
 			ret = -EINVAL;
-<<<<<<< HEAD
-			goto err_put_master;
-=======
 			goto err_disable_runtime_pm;
->>>>>>> linux-next/akpm-base
 		}
 
 		if (master->cs_gpios) {
@@ -649,11 +645,7 @@ static int mtk_spi_probe(struct platform
 				if (ret) {
 					dev_err(&pdev->dev,
 						"can't get CS GPIO %i\n", i);
-<<<<<<< HEAD
-					goto err_put_master;
-=======
 					goto err_disable_runtime_pm;
->>>>>>> linux-next/akpm-base
 				}
 			}
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

