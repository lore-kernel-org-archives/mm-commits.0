From: akpm@linux-foundation.org
Subject: [folded-merged]
 thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch removed from -mm
 tree
Date: Thu, 14 Jan 2016 14:44:00 -0800
Message-ID: <569824b0.zjQ8xEyM93bdZFqc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbcANWoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:44:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, kirill.shutemov@linux.intel.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-add-debugfs-handle-to-split-all-huge-pages-fix
has been removed from the -mm tree.  Its filename was
     thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

This patch was dropped because it was folded into thp-add-debugfs-handle-to-split-all-huge-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-add-debugfs-handle-to-split-all-huge-pages-fix

fix printk text, per Vlastimil

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-add-debugfs-handle-to-split-all-huge-pages-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-add-debugfs-handle-to-split-all-huge-pages-fix
+++ a/mm/huge_memory.c
@@ -3463,7 +3463,7 @@ static int __init split_huge_pages_debug
 	ret = debugfs_create_file("split_huge_pages", 0644, NULL, NULL,
 			&split_huge_pages_fops);
 	if (!ret)
-		pr_warn("Failed to create fault_around_bytes in debugfs");
+		pr_warn("Failed to create split_huge_pages in debugfs");
 	return 0;
 }
 late_initcall(split_huge_pages_debugfs);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch

