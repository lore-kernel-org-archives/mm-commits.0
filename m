From: akpm@linux-foundation.org
Subject: [folded-merged] mm-tracing-refresh-__def_vmaflag_names-fix.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 13:55:19 -0700
Message-ID: <56eb19b7.7V9iNjaBaKMQdHCy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030465AbcCQUzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-tracing-refresh-__def_vmaflag_names-fix
has been removed from the -mm tree.  Its filename was
     mm-tracing-refresh-__def_vmaflag_names-fix.patch

This patch was dropped because it was folded into mm-tracing-refresh-__def_vmaflag_names.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-tracing-refresh-__def_vmaflag_names-fix

Add a note above vmaflag definitions to update the names when changing.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/mm.h~mm-tracing-refresh-__def_vmaflag_names-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-tracing-refresh-__def_vmaflag_names-fix
+++ a/include/linux/mm.h
@@ -143,6 +143,7 @@ extern unsigned int kobjsize(const void
 
 /*
  * vm_flags in vm_area_struct, see mm_types.h.
+ * When changing, update also include/trace/events/mmflags.h
  */
 #define VM_NONE		0x00000000
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names.patch
mm-use-radix_tree_iter_retry-fix.patch

