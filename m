Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C1411C86
	for <mm-commits@vger.kernel.org>; Sun,  7 Jan 2024 22:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OGmo6qS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF387C433C8;
	Sun,  7 Jan 2024 22:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704665550;
	bh=XUMiK+5yquqNBgXZ9coMfYh8o+XTNgEUHljr7Vl/A5s=;
	h=Date:To:From:Subject:From;
	b=OGmo6qS0/veli5ioCUE94eVQ4Rn1QWdvL0lkw9pHX7HimNd/YilI8LMqX8qGZVZy6
	 IXnHYiowg+D8OaeAZFxOa3V44TJ9VKhh38HLWbVKuwiyms7H8tS5p1KDYtDnNRsGS7
	 nWuVq+o4rtrg8r8khn1FiyXr6Nq1+dPCkbKMy2c4=
Date: Sun, 07 Jan 2024 14:12:30 -0800
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-treewide-introduce-nr_page_orders-fix.patch removed from -mm tree
Message-Id: <20240107221230.DF387C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-treewide-introduce-nr_page_orders-fix
has been removed from the -mm tree.  Its filename was
     mm-treewide-introduce-nr_page_orders-fix.patch

This patch was dropped because it was folded into mm-treewide-introduce-nr_page_orders.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm-treewide-introduce-nr_page_orders-fix
Date: Mon, 1 Jan 2024 14:15:12 +0300

fixup for kerneldoc warning

Link: https://lkml.kernel.org/r/20240101111512.7empzyifq7kxtzk3@box
Signed-off-by: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~mm-treewide-introduce-nr_page_orders-fix
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -190,7 +190,7 @@ information. Makedumpfile gets the start
 from this.
 
 (zone.free_area, NR_PAGE_ORDERS)
--------------------------------
+--------------------------------
 
 Free areas descriptor. User-space tools use this value to iterate the
 free_area ranges. MAX_ORDER is used by the zone buddy allocator.
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-treewide-introduce-nr_page_orders.patch
mm-treewide-rename-max_order-to-max_page_order.patch

