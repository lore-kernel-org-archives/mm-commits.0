From: akpm@linux-foundation.org
Subject: + docs-mm-gup-minor-documentation-update.patch added to -mm
 tree
Date: Wed, 17 Jun 2020 14:04:21 -0700
Message-ID: <20200617210421.wUd4R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgFQVEW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 17:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, jhubbard@nvidia.com, jack@suse.cz, corbet@lwn.net, jrdr.linux@gmail.com


The patch titled
     Subject: docs: mm/gup: minor documentation update
has been added to the -mm tree.  Its filename is
     docs-mm-gup-minor-documentation-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/docs-mm-gup-minor-documentation-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/docs-mm-gup-minor-documentation-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: docs: mm/gup: minor documentation update

Now there are 5 cases. Updated the same.

Link: http://lkml.kernel.org/r/1592422023-7401-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
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

docs-mm-gup-minor-documentation-update.patch
