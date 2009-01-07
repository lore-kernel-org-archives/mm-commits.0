From: akpm@linux-foundation.org
Subject: - dmitry-has-been-renamed.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:59 -0800
Message-ID: <200901072215.n07MFxQh015716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761975AbZAGWQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Dmitry has been renamed
has been removed from the -mm tree.  Its filename was
     dmitry-has-been-renamed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Dmitry has been renamed
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

My surname has changed due to marriage. Change MAINTAINERS entry
and add .mailmap entry to reflect that.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN .mailmap~dmitry-has-been-renamed .mailmap
--- a/.mailmap~dmitry-has-been-renamed
+++ a/.mailmap
@@ -32,6 +32,7 @@ Christoph Hellwig <hch@lst.de>
 Corey Minyard <minyard@acm.org>
 David Brownell <david-b@pacbell.net>
 David Woodhouse <dwmw2@shinybook.infradead.org>
+Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
 Domen Puncer <domen@coderock.org>
 Douglas Gilbert <dougg@torque.net>
 Ed L. Cashin <ecashin@coraid.com>
diff -puN MAINTAINERS~dmitry-has-been-renamed MAINTAINERS
--- a/MAINTAINERS~dmitry-has-been-renamed
+++ a/MAINTAINERS
@@ -616,7 +616,7 @@ M:	mkpetch@internode.on.net
 S:	Maintained
 
 ARM/TOSA MACHINE SUPPORT
-P:	Dmitry Baryshkov
+P:	Dmitry Eremin-Solenikov
 M:	dbaryshkov@gmail.com
 P:	Dirk Opfer
 M:	dirk@opfer-online.de
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

origin.patch
linux-next.patch

