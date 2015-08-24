From: akpm@linux-foundation.org
Subject: [merged] add-myself-to-get_maintainerignore.patch removed from
 -mm tree
Date: Mon, 24 Aug 2015 11:41:32 -0700
Message-ID: <55db655c.zwOQxAFeuHUSfER/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbHXSlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 14:41:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Add hch to .get_maintainer.ignore
has been removed from the -mm tree.  Its filename was
     add-myself-to-get_maintainerignore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: Add hch to .get_maintainer.ignore

While the idea behind get_maintainer seems highly useful it's
unfortunately way to trigger happy to grab people that once had a few
commits to files.  For someone like me who does a lot of tree-wide API
work that leads to an incredible amount of Cc spam.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .get_maintainer.ignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN /dev/null .get_maintainer.ignore
--- /dev/null
+++ a/.get_maintainer.ignore
@@ -0,0 +1 @@
+Christoph Hellwig <hch@lst.de>
_

Patches currently in -mm which might be from hch@lst.de are

dma-mapping-consolidate-dma_allocfree_attrscoherent.patch
dma-mapping-consolidate-dma_allocfree_noncoherent.patch
dma-mapping-cosolidate-dma_mapping_error.patch
dma-mapping-consolidate-dma_supported.patch
dma-mapping-consolidate-dma_set_mask.patch

