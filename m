Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC40168B9
	for <mm-commits@vger.kernel.org>; Tue,  2 Jan 2024 19:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wn0u2a26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31385C433C9;
	Tue,  2 Jan 2024 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704222137;
	bh=GSN4hFWgLgvUt88FZ8ZVMCpdeJAvR/0foP/R+1Q2j/g=;
	h=Date:To:From:Subject:From;
	b=wn0u2a26mJ8En2fppEre0vL/skZEp9yQhg0aiKkfZ+DK+MDH69Pu6xRUe1lGgDvZk
	 cKpgBsKgqEMBQwDtrNhDGquu+nCF6//EiSsUloNDDQh1JmzVtw0RjJPdjUsLLfei3A
	 LclC2WE+mQOgjlioQI66NqRjPXVB0GuqqvZ1eb0Q=
Date: Tue, 02 Jan 2024 11:02:16 -0800
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-treewide-introduce-nr_page_orders-fix.patch added to mm-unstable branch
Message-Id: <20240102190217.31385C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-treewide-introduce-nr_page_orders-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-treewide-introduce-nr_page_orders-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-treewide-introduce-nr_page_orders-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-treewide-introduce-nr_page_orders-fix.patch
mm-treewide-rename-max_order-to-max_page_order.patch

