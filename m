From: akpm@linux-foundation.org
Subject: [merged] linkage-remove-unused-noret_and-macro.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:32 -0800
Message-ID: <20120113203133.051BB5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64132 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061Ab2AMUbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:31:34 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25335eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:31:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/linkage.h: remove unused NORET_AND macro
has been removed from the -mm tree.  Its filename was
     linkage-remove-unused-noret_and-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: include/linux/linkage.h: remove unused NORET_AND macro

The only use in kernel.h is gone so remove the macro.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/linkage.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/linkage.h~linkage-remove-unused-noret_and-macro include/linux/linkage.h
--- a/include/linux/linkage.h~linkage-remove-unused-noret_and-macro
+++ a/include/linux/linkage.h
@@ -90,6 +90,5 @@
 
 #define NORET_TYPE    /**/
 #define ATTRIB_NORET  __attribute__((noreturn))
-#define NORET_AND     noreturn,
 
 #endif
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch

