From: akpm@linux-foundation.org
Subject: + pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch added to -mm
 tree
Date: Wed, 23 Dec 2015 12:48:57 -0800
Message-ID: <567b08b9.gRBTaKX9XSd+Bufq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965439AbbLWUs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Dec 2015 15:48:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pmem-add-wb_cache_pmem-to-the-pmem-api-v6
has been added to the -mm tree.  Its filename is
     pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch

