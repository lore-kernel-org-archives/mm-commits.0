From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-mm-gup-minor-documentation-update.patch
 removed from -mm tree
Date: Fri, 26 Jun 2020 20:33:53 -0700
Message-ID: <20200627033353.vyxz8XeuC%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0Ddy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:54 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, jack@suse.cz, jhubbard@nvidia.com, jrdr.linux@gmail.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: docs: mm/gup: minor documentation update
has been removed from the -mm tree.  Its filename was
     docs-mm-gup-minor-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: docs: mm/gup: minor documentation update

Now there are 5 cases. Updated the same.

Link: http://lkml.kernel.org/r/1592422023-7401-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/core-api/pin_user_pages.rst~docs-mm-gup-minor-documentation-update
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -33,7 +33,7 @@ all combinations of get*(), pin*(), FOLL
 pin_user_pages*() APIs are clearly distinct from the get_user_pages*() APIs, so
 that's a natural dividing line, and a good point to make separate wrapper calls.
 In other words, use pin_user_pages*() for DMA-pinned pages, and
-get_user_pages*() for other cases. There are four cases described later on in
+get_user_pages*() for other cases. There are five cases described later on in
 this document, to further clarify that concept.
 
 FOLL_PIN and FOLL_GET are mutually exclusive for a given gup call. However,
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are
