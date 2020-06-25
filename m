From: akpm@linux-foundation.org
Subject: + maintainers-update-info-for-sparse.patch added to -mm
 tree
Date: Thu, 25 Jun 2020 16:15:14 -0700
Message-ID: <20200625231514.T7nGc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406243AbgFYXPP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 19:15:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, luc.vanoostenryck@gmail.com


The patch titled
     Subject: MAINTAINERS: update info for sparse
has been added to the -mm tree.  Its filename is
     maintainers-update-info-for-sparse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-info-for-sparse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-info-for-sparse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: MAINTAINERS: update info for sparse

Update the info for sparse. More specifically:
* change W entry to point to sparse.docs.kernel.org
* add Q & B entry (patchwork & bugzilla)

Link: http://lkml.kernel.org/r/20200621144204.53938-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-info-for-sparse
+++ a/MAINTAINERS
@@ -16058,8 +16058,10 @@ SPARSE CHECKER
 M:	"Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>
 L:	linux-sparse@vger.kernel.org
 S:	Maintained
-W:	https://sparse.wiki.kernel.org/
+W:	https://sparse.docs.kernel.org/
 T:	git git://git.kernel.org/pub/scm/devel/sparse/sparse.git
+Q:	https://patchwork.kernel.org/project/linux-sparse/list/
+B:	https://bugzilla.kernel.org/enter_bug.cgi?component=Sparse&product=Tools
 F:	include/linux/compiler.h
 
 SPEAR CLOCK FRAMEWORK SUPPORT
_

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are

maintainers-update-info-for-sparse.patch
fix-annotation-of-ioreadwrite1632be.patch
lib-generic-radix-treec-remove-unneeded-__rcu.patch
