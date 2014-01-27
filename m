From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-convert-to-pr_foo.patch added to -mm tree
Date: Mon, 27 Jan 2014 14:45:56 -0800
Message-ID: <52e6e1a4.v+YghKR8euf/pY8U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaA0Wp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 17:45:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, akpm@linux-foundation.org

Subject: + mm-mempolicyc-convert-to-pr_foo.patch added to -mm tree
To: akpm@linux-foundation.org,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 14:45:56 -0800


The patch titled
     Subject: mm/mempolicy.c: convert to pr_foo()
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-convert-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicyc-convert-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicyc-convert-to-pr_foo.patch

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
Subject: mm/mempolicy.c: convert to pr_foo()

A few printk(KERN_*'s have snuck in thereWu
Cc: Mel Gorman <mgorman@suse.de>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-convert-to-pr_foo mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-convert-to-pr_foo
+++ a/mm/mempolicy.c
@@ -2669,7 +2669,7 @@ static void __init check_numabalancing_e
 		set_numabalancing_state(numabalancing_override == 1);
 
 	if (nr_node_ids > 1 && !numabalancing_override) {
-		printk(KERN_INFO "%s automatic NUMA balancing. "
+		pr_info("%s automatic NUMA balancing. "
 			"Configure with numa_balancing= or the "
 			"kernel.numa_balancing sysctl",
 			numabalancing_default ? "Enabling" : "Disabling");
@@ -2692,7 +2692,7 @@ static int __init setup_numabalancing(ch
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
arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
mm-document-improved-handling-of-swappiness==0-fix.patch
mm-mempolicyc-convert-to-pr_foo.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

