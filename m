From: akpm@linux-foundation.org
Subject: + mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch added to
 -mm tree
Date: Fri, 19 Jul 2013 16:16:33 -0700
Message-ID: <51e9c8d1.LefZigXrTyKbeKAI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab3GSXQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 19:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dave@sr71.net, akpm@linux-foundation.org

Subject: + mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch added to -mm tree
To: akpm@linux-foundation.org,dave@sr71.net
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 16:16:33 -0700


The patch titled
     Subject: mm-vmstats-track-tlb-flush-stats-on-up-too-fix
has been added to the -mm tree.  Its filename is
     mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch

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
Subject: mm-vmstats-track-tlb-flush-stats-on-up-too-fix

Cc: Dave Hansen <dave@sr71.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlbflush.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/tlbflush.h~mm-vmstats-track-tlb-flush-stats-on-up-too-fix arch/x86/include/asm/tlbflush.h
--- a/arch/x86/include/asm/tlbflush.h~mm-vmstats-track-tlb-flush-stats-on-up-too-fix
+++ a/arch/x86/include/asm/tlbflush.h
@@ -85,11 +85,10 @@ static inline void __flush_tlb_one(unsig
 
 #ifndef CONFIG_SMP
 
-/* "_up" is for UniProcessor
+/* "_up" is for UniProcessor.
  *
- * This is a helper for other header functions.  *Not*
- * intended to be called directly.  All global TLB
- * flushes need to either call this, or do the bump the
+ * This is a helper for other header functions.  *Not* intended to be called
+ * directly.  All global TLB flushes need to either call this, or to bump the
  * vm statistics themselves.
  */
 static inline void __flush_tlb_up(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

