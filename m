From: akpm@linux-foundation.org
Subject: [merged] edac-add-maintainers-entry-for-i5400-edac-driver.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:30 -0800
Message-ID: <200901161916.n0GJGULP024962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932915AbZAPTRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mchehab@infradead.org, norsk5@yahoo.com, woodard@redhat.com, mm-commits@vger.kernel.org


The patch titled
     edac: add MAINTAINERS entry for i5400 EDAC driver
has been removed from the -mm tree.  Its filename was
     edac-add-maintainers-entry-for-i5400-edac-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: add MAINTAINERS entry for i5400 EDAC driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>

i5400 EDAC driver were added upstream by those changesets:

920c8df6ac678fdb8c49a6ce2e47a98e62757d77
8375d4909aee4c18798f373ecf24a79f040f75fc

Update MAINTAINERS entry for this file to correspond to the driver
maintainer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ben Woodard <woodard@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~edac-add-maintainers-entry-for-i5400-edac-driver MAINTAINERS
--- a/MAINTAINERS~edac-add-maintainers-entry-for-i5400-edac-driver
+++ a/MAINTAINERS
@@ -1581,6 +1581,13 @@ L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 
+EDAC-I5400
+P:	Mauro Carvalho Chehab
+M:	mchehab@redhat.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
 EDAC-I82975X
 P:	Ranganathan Desikan
 P:	Arvind R.
_

Patches currently in -mm which might be from mchehab@infradead.org are

origin.patch

