From: akpm@osdl.org
Subject: + kernel-doc-remove-martin-from-maintainers.patch added to -mm tree
Date: Wed, 20 Dec 2006 20:43:54 -0800
Message-ID: <200612210443.kBL4hsoL015806@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37414 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422703AbWLUEoU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 23:44:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tali@admingilde.org, randy.dunlap@oracle.com


The patch titled
     kernel-doc: remove Martin from MAINTAINERS
has been added to the -mm tree.  Its filename is
     kernel-doc-remove-martin-from-maintainers.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: remove Martin from MAINTAINERS
From: Martin Waitz <tali@admingilde.org>

I don't have the time to work on Linux Documentation, so I really should
document that in MAINTAINERS.  With Randy, kernel-doc is in good hands
anyway.

Signed-off-by: Martin Waitz <tali@admingilde.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    3 ---
 1 file changed, 3 deletions(-)

diff -puN MAINTAINERS~kernel-doc-remove-martin-from-maintainers MAINTAINERS
--- a/MAINTAINERS~kernel-doc-remove-martin-from-maintainers
+++ a/MAINTAINERS
@@ -943,11 +943,8 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 DOCBOOK FOR DOCUMENTATION
-P:	Martin Waitz
-M:	tali@admingilde.org
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
-T:	git http://tali.admingilde.org/git/linux-docbook.git
 S:	Maintained
 
 DOCKING STATION DRIVER
_

Patches currently in -mm which might be from tali@admingilde.org are

kernel-doc-remove-martin-from-maintainers.patch

