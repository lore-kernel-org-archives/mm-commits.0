From: akpm@linux-foundation.org
Subject: [merged] memremap-remove-stale-comments.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:00:02 -0700
Message-ID: <20200408020002.BCjtr6t6K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgDHCAE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, ira.weiny@intel.com, jgg@ziepe.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/memremap.h: remove stale comments
has been removed from the -mm tree.  Its filename was
     memremap-remove-stale-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: include/linux/memremap.h: remove stale comments

Link: http://lkml.kernel.org/r/20200316213205.145333-1-ira.weiny@intel.com
Fixes: 80a72d0af05a ("memremap: remove the data field in struct dev_pagemap")
Fixes: fdc029b19dfd ("memremap: remove the dev field in struct dev_pagemap")
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/memremap.h~memremap-remove-stale-comments
+++ a/include/linux/memremap.h
@@ -98,8 +98,6 @@ struct dev_pagemap_ops {
  * @ref: reference count that pins the devm_memremap_pages() mapping
  * @internal_ref: internal reference if @ref is not provided by the caller
  * @done: completion for @internal_ref
- * @dev: host device of the mapping for debug
- * @data: private data pointer for page_free()
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
  * @ops: method table
_

Patches currently in -mm which might be from ira.weiny@intel.com are
