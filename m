From: akpm@linux-foundation.org
Subject: + spellingtxt-add-unnecessary-typo-variants.patch added to -mm
 tree
Date: Mon, 02 Oct 2017 16:04:45 -0700
Message-ID: <59d2c60d.ZAjit+06s8Qpvh8+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbdJBXEq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 19:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: spelling.txt: add "unnecessary" typo variants
has been added to the -mm tree.  Its filename is
     spellingtxt-add-unnecessary-typo-variants.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/spellingtxt-add-unnecessary-typo-variants.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/spellingtxt-add-unnecessary-typo-variants.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: spelling.txt: add "unnecessary" typo variants

Add unnecessary typos by copying the necessary typos.

Link: http://lkml.kernel.org/r/1505074722.22023.6.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/spelling.txt~spellingtxt-add-unnecessary-typo-variants scripts/spelling.txt
--- a/scripts/spelling.txt~spellingtxt-add-unnecessary-typo-variants
+++ a/scripts/spelling.txt
@@ -1187,6 +1187,10 @@ unknonw||unknown
 unknow||unknown
 unkown||unknown
 unneded||unneeded
+unneccecary||unnecessary
+unneccesary||unnecessary
+unneccessary||unnecessary
+unnecesary||unnecessary
 unneedingly||unnecessarily
 unnsupported||unsupported
 unmached||unmatched
_

Patches currently in -mm which might be from joe@perches.com are

spellingtxt-add-unnecessary-typo-variants.patch
parse-maintainers-add-ability-to-specify-filenames.patch

