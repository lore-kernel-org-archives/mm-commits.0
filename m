From: akpm@linux-foundation.org
Subject: + printk-create-pr_level-functions-fix.patch added to -mm tree
Date: Thu, 23 Jun 2016 18:28:39 -0700
Message-ID: <576c8cc7.WO+etWABxgqz81ze%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbcFXB2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jun 2016 21:28:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-create-pr_level-functions-fix
has been added to the -mm tree.  Its filename is
     printk-create-pr_level-functions-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-create-pr_level-functions-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-create-pr_level-functions-fix.patch

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
Subject: printk-create-pr_level-functions-fix

fix LOGLEVEL_INFO, per Joe

Cc: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-create-pr_level-functions-fix kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-create-pr_level-functions-fix
+++ a/kernel/printk/printk.c
@@ -1819,7 +1819,7 @@ define_pr_level(__pr_crit, LOGLEVEL_CRIT
 define_pr_level(__pr_err, LOGLEVEL_ERR);
 define_pr_level(__pr_warn, LOGLEVEL_WARNING);
 define_pr_level(__pr_notice, LOGLEVEL_NOTICE);
-define_pr_level(__pr_info, LOGLEVEL_NOTICE);
+define_pr_level(__pr_info, LOGLEVEL_INFO);
 #endif
 
 int vprintk_default(int level, const char *fmt, va_list args)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

