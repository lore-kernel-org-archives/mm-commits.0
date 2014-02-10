From: akpm@linux-foundation.org
Subject: [folded-merged]
 xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
 removed from -mm tree
Date: Mon, 10 Feb 2014 14:21:24 -0800
Message-ID: <52f950e4.Ivo/wpPx3ewcGOPS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaBJWVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:21:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, akpm@linux-foundation.org

Subject: [folded-merged] xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:21:24 -0800


The patch titled
     Subject: xen-properly-account-for-_page_numa-during-xen-pte-translations-fix
has been removed from the -mm tree.  Its filename was
     xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch

This patch was dropped because it was folded into xen-properly-account-for-_page_numa-during-xen-pte-translations.patch

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
xen-properly-account-for-_page_numa-during-xen-pte-translations.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

