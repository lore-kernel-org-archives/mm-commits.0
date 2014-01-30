From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-convert-to-pr_foo.patch removed from -mm
 tree
Date: Thu, 30 Jan 2014 12:05:08 -0800
Message-ID: <52eab074.7bNy02TwGZH3h99/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaA3UFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, akpm@linux-foundation.org

Subject: [merged] mm-mempolicyc-convert-to-pr_foo.patch removed from -mm tree
To: akpm@linux-foundation.org,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:08 -0800


The patch titled
     Subject: mm/mempolicy.c: convert to pr_foo()
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-convert-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mempolicy.c: convert to pr_foo()

A few printk(KERN_*'s have snuck in there.

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-convert-to-pr_foo mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-convert-to-pr_foo
+++ a/mm/mempolicy.c
@@ -2668,7 +2668,7 @@ static void __init check_numabalancing_e
 		set_numabalancing_state(numabalancing_override == 1);
 
 	if (nr_node_ids > 1 && !numabalancing_override) {
-		printk(KERN_INFO "%s automatic NUMA balancing. "
+		pr_info("%s automatic NUMA balancing. "
 			"Configure with numa_balancing= or the "
 			"kernel.numa_balancing sysctl",
 			numabalancing_default ? "Enabling" : "Disabling");
@@ -2691,7 +2691,7 @@ static int __init setup_numabalancing(ch
 	}
 out:
 	if (!ret)
-		printk(KERN_WARNING "Unable to parse numa_balancing=\n");
+		pr_warn("Unable to parse numa_balancing=\n");
 
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
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

