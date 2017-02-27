From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplugc-unexport-__remove_pages.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:24:20 -0800
Message-ID: <58b48af4.6gDdvRWhimthlpJo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60398 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbdB0UYo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:24:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: unexport __remove_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-unexport-__remove_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memory_hotplug.c: unexport __remove_pages()

It has no modular callers.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-unexport-__remove_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-unexport-__remove_pages
+++ a/mm/memory_hotplug.c
@@ -864,7 +864,6 @@ int __remove_pages(struct zone *zone, un
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__remove_pages);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 int set_online_page_callback(online_page_callback_t callback)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

