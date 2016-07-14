From: akpm@linux-foundation.org
Subject: + allow-kdump-with-crash_kexec_post_notifiers-fix.patch added to
 -mm tree
Date: Thu, 14 Jul 2016 13:01:40 -0700
Message-ID: <5787efa4.Syrod3nvLAUELpDv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcGNUBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 16:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ptesarik@suse.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: allow-kdump-with-crash_kexec_post_notifiers-fix
has been added to the -mm tree.  Its filename is
     allow-kdump-with-crash_kexec_post_notifiers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/allow-kdump-with-crash_kexec_post_notifiers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/allow-kdump-with-crash_kexec_post_notifiers-fix.patch

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
Subject: allow-kdump-with-crash_kexec_post_notifiers-fix

build fix: unconditionally include kexec.h

Cc: Petr Tesarik <ptesarik@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/enlighten.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/x86/xen/enlighten.c~allow-kdump-with-crash_kexec_post_notifiers-fix arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~allow-kdump-with-crash_kexec_post_notifiers-fix
+++ a/arch/x86/xen/enlighten.c
@@ -34,9 +34,7 @@
 #include <linux/edd.h>
 #include <linux/frame.h>
 
-#ifdef CONFIG_KEXEC_CORE
 #include <linux/kexec.h>
-#endif
 
 #include <xen/xen.h>
 #include <xen/events.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-improve-recovery-performance-v2-fix.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
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
mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

