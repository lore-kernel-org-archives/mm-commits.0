From: akpm@linux-foundation.org
Subject: +
 xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
 added to -mm tree
Date: Tue, 04 Feb 2014 12:47:10 -0800
Message-ID: <52f151ce.nckjD2mZn2oEpsIv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaBDUrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 15:47:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, akpm@linux-foundation.org

Subject: + xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch added to -mm tree
To: akpm@linux-foundation.org,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 12:47:10 -0800


The patch titled
     Subject: xen-properly-account-for-_page_numa-during-xen-pte-translations-fix
has been added to the -mm tree.  Its filename is
     xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch

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
Subject: xen-properly-account-for-_page_numa-during-xen-pte-translations-fix

fix typo in comment

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pgtable.h~xen-properly-account-for-_page_numa-during-xen-pte-translations-fix arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~xen-properly-account-for-_page_numa-during-xen-pte-translations-fix
+++ a/arch/x86/include/asm/pgtable.h
@@ -449,7 +449,7 @@ static inline int pteval_present(pteval_
 {
 	/*
 	 * Yes Linus, _PAGE_PROTNONE == _PAGE_NUMA. Expressing it this
-	 * way clearly states that the intent is that a protnone and numa
+	 * way clearly states that the intent is that protnone and numa
 	 * hinting ptes are considered present for the purposes of
 	 * pagetable operations like zapping, protection changes, gup etc.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

