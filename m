From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-document-improved-handling-of-swappiness==0-fix.patch removed from -mm
 tree
Date: Wed, 29 Jan 2014 14:00:34 -0800
Message-ID: <52e97a02.VQgfuMpZtJlvc99w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaA2WAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jan 2014 17:00:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, atomlin@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-document-improved-handling-of-swappiness==0-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,atomlin@redhat.com,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 29 Jan 2014 14:00:34 -0800


The patch titled
     Subject: mm-document-improved-handling-of-swappiness==0-fix
has been removed from the -mm tree.  Its filename was
     mm-document-improved-handling-of-swappiness==0-fix.patch

This patch was dropped because it was folded into mm-document-improved-handling-of-swappiness==0.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-document-improved-handling-of-swappiness==0-fix

remove comma, per Randy

Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-document-improved-handling-of-swappiness==0-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-document-improved-handling-of-swappiness==0-fix
+++ a/Documentation/sysctl/vm.txt
@@ -697,7 +697,7 @@ swappiness
 This control is used to define how aggressive the kernel will swap
 memory pages.  Higher values will increase agressiveness, lower values
 decrease the amount of swap.  A value of 0 instructs the kernel not to
-initiate swap until the amount of free and file-backed pages, is less
+initiate swap until the amount of free and file-backed pages is less
 than the high water mark in a zone.
 
 The default value is 60.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
mm-document-improved-handling-of-swappiness==0.patch
mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory-fix.patch
mm-mempolicyc-convert-to-pr_foo.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

