From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memremap-remove-stale-comments.patch added to -mm tree
Date: Wed, 18 Mar 2020 14:19:39 -0700
Message-ID: <20200318211939.C-GOB3G9s%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCRVTl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 17:19:41 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, ira.weiny@intel.com, jgg@ziepe.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/memremap.h: remove stale comments
has been added to the -mm tree.  Its filename is
     memremap-remove-stale-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memremap-remove-stale-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memremap-remove-stale-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memremap-remove-stale-comments.patch
