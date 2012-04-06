From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-remoteproc-f-typo.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:49:05 -0700
Message-ID: <20120406184905.6554BA0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60277 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2DFStG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:49:06 -0400
Received: by ghbz15 with SMTP id z15so298302ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:49:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, ohad@wizery.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix REMOTEPROC F: typo
has been removed from the -mm tree.  Its filename was
     maintainers-fix-remoteproc-f-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: fix REMOTEPROC F: typo

remoteproc.txt should have been .h

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-remoteproc-f-typo MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-remoteproc-f-typo
+++ a/MAINTAINERS
@@ -5637,7 +5637,7 @@ M:	Ohad Ben-Cohen <ohad@wizery.com>
 S:	Maintained
 F:	drivers/remoteproc/
 F:	Documentation/remoteproc.txt
-F:	include/linux/remoteproc.txt
+F:	include/linux/remoteproc.h
 
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-add-pcdp-console-maintainer.patch
checkpatch-check-for-spin_is_locked.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

