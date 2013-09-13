From: akpm@linux-foundation.org
Subject: + documentation-dma-attributestxt-fix-typo.patch added to -mm
 tree
Date: Fri, 13 Sep 2013 16:16:24 -0700
Message-ID: <52339cc8.4n8mLli9E/pwCnwK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3IMXQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 19:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: + documentation-dma-attributestxt-fix-typo.patch added to -mm tree
To: qiuxishi@huawei.com
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 16:16:24 -0700


The patch titled
     Subject: Documentation/DMA-attributes.txt fix typo
has been added to the -mm tree.  Its filename is
     documentation-dma-attributestxt-fix-typo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-dma-attributestxt-fix-typo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-dma-attributestxt-fix-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
documentation-dma-attributestxt-fix-typo.patch

