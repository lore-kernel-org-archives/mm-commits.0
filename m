From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 32/32] MAINTAINERS: update info for sparse
Date: Thu, 25 Jun 2020 20:30:54 -0700
Message-ID: <20200626033054.6LIGX0I_f%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgFZDaz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:30:55 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, luc.vanoostenryck@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
