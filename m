From: akpm@linux-foundation.org
Subject: [merged] documentation-dma-attributestxt-fix-typo.patch removed
 from -mm tree
Date: Thu, 31 Oct 2013 10:59:57 -0700
Message-ID: <52729a9d.MdISvQmkIasG9Qkt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JaR75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 13:59:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: [merged] documentation-dma-attributestxt-fix-typo.patch removed from -mm tree
To: qiuxishi@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 10:59:57 -0700


The patch titled
     Subject: Documentation/DMA-attributes.txt fix typo
has been removed from the -mm tree.  Its filename was
     documentation-dma-attributestxt-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: Documentation/DMA-attributes.txt fix typo

Fix some typos in Documentation/DMA-attributes.txt.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-attributes.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/DMA-attributes.txt~documentation-dma-attributestxt-fix-typo Documentation/DMA-attributes.txt
--- a/Documentation/DMA-attributes.txt~documentation-dma-attributestxt-fix-typo
+++ a/Documentation/DMA-attributes.txt
@@ -13,7 +13,7 @@ all pending DMA writes to complete, and
 strictly order DMA from a device across all intervening busses and
 bridges.  This barrier is not specific to a particular type of
 interconnect, it applies to the system as a whole, and so its
-implementation must account for the idiosyncracies of the system all
+implementation must account for the idiosyncrasies of the system all
 the way from the DMA device to memory.
 
 As an example of a situation where DMA_ATTR_WRITE_BARRIER would be
@@ -60,7 +60,7 @@ such mapping is non-trivial task and con
 Buffers allocated with this attribute can be only passed to user space
 by calling dma_mmap_attrs(). By using this API, you are guaranteeing
 that you won't dereference the pointer returned by dma_alloc_attr(). You
-can threat it as a cookie that must be passed to dma_mmap_attrs() and
+can treat it as a cookie that must be passed to dma_mmap_attrs() and
 dma_free_attrs(). Make sure that both of these also get this attribute
 set on each call.
 
@@ -82,7 +82,7 @@ to 'device' domain, what synchronizes CP
 (usually it means that the cache has been flushed or invalidated
 depending on the dma direction). However, next calls to
 dma_map_{single,page,sg}() for other devices will perform exactly the
-same sychronization operation on the CPU cache. CPU cache sychronization
+same synchronization operation on the CPU cache. CPU cache synchronization
 might be a time consuming operation, especially if the buffers are
 large, so it is highly recommended to avoid it if possible.
 DMA_ATTR_SKIP_CPU_SYNC allows platform code to skip synchronization of
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-arch-use-__free_reserved_page-to-simplify-the-code.patch
drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch
mm-use-populated_zone-instead-of-ifzone-present_pages.patch
mm-memory_hotplugc-rename-the-function-is_memblock_offlined_cb.patch
mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch
linux-next.patch

