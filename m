From: akpm@linux-foundation.org
Subject: [merged] linkage-remove-unused-attrib_noret-macro.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:48 -0800
Message-ID: <20120113203148.93558100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36212 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab2AMUbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:31:49 -0500
Received: by yhjj52 with SMTP id j52so101798yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:31:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/linkage.h: remove unused ATTRIB_NORET macro
has been removed from the -mm tree.  Its filename was
     linkage-remove-unused-attrib_noret-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: include/linux/linkage.h: remove unused ATTRIB_NORET macro

The uses have been renamed so delete the unused macro.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/linkage.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/linkage.h~linkage-remove-unused-attrib_noret-macro include/linux/linkage.h
--- a/include/linux/linkage.h~linkage-remove-unused-attrib_noret-macro
+++ a/include/linux/linkage.h
@@ -88,6 +88,4 @@
 
 #endif
 
-#define ATTRIB_NORET  __attribute__((noreturn))
