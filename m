From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix.patch removed
 from -mm tree
Date: Wed, 08 Apr 2020 17:06:12 -0700
Message-ID: <20200409000612.kTlgYDORo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDIAGN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix

fix spello in comment

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix
+++ a/mm/mempolicy.c
@@ -902,7 +902,7 @@ static int lookup_node(struct mm_struct
 	int locked = 1;
 	err = get_user_pages_locked(addr & PAGE_MASK, 1, 0, &p, &locked);
 	if (err == 0) {
-		/* E.g. GUP interupted by fatal signal */
+		/* E.g. GUP interrupted by fatal signal */
 		err = -EFAULT;
 	} else if (err > 0) {
 		err = page_to_nid(p);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage-checkpatch-fixes.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
