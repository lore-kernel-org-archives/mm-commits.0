From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-update-info-for-sparse.patch removed
 from -mm tree
Date: Fri, 26 Jun 2020 20:34:17 -0700
Message-ID: <20200627033417.uRvGQwzzF%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0DeR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:34:17 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luc.vanoostenryck@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update info for sparse
has been removed from the -mm tree.  Its filename was
     maintainers-update-info-for-sparse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

fix-annotation-of-ioreadwrite1632be.patch
sparse-group-the-defines-by-functionality.patch
lib-generic-radix-treec-remove-unneeded-__rcu.patch
