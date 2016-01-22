From: akpm@linux-foundation.org
Subject: [folded-merged] pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
 removed from -mm tree
Date: Fri, 22 Jan 2016 14:57:09 -0800
Message-ID: <56a2b3c5.UoBe7yKOuyyjI3h/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbcAVW5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jan 2016 17:57:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pmem-add-wb_cache_pmem-to-the-pmem-api-v6
has been removed from the -mm tree.  Its filename was
     pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch

This patch was dropped because it was folded into pmem-add-wb_cache_pmem-to-the-pmem-api.patch

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: pmem-add-wb_cache_pmem-to-the-pmem-api-v6

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pmem.h~pmem-add-wb_cache_pmem-to-the-pmem-api-v6 arch/x86/include/asm/pmem.h
--- a/arch/x86/include/asm/pmem.h~pmem-add-wb_cache_pmem-to-the-pmem-api-v6
+++ a/arch/x86/include/asm/pmem.h
@@ -134,7 +134,7 @@ static inline void arch_clear_pmem(void
 	void *vaddr = (void __force *)addr;
 
 	memset(vaddr, 0, size);
-	arch_wb_cache_pmem(vaddr, size);
+	arch_wb_cache_pmem(addr, size);
 }
 
 static inline bool __arch_has_wmb_pmem(void)
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
dax-support-dirty-dax-entries-in-radix-tree-v6.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-sync-v6.patch
dax-add-support-for-fsync-msync-v7.patch
dax-add-support-for-fsync-msync-v8.patch
dax-add-support-for-fsync-msync-v8-fix.patch
dax-add-support-for-fsync-msync-v8-fix-2-v2.patch
dax-add-support-for-fsync-msync-v8-fix-3-v2.patch
dax-add-support-for-fsync-sync-v8-fix-4.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

