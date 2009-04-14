From: akpm@linux-foundation.org
Subject: [merged] include-linux-fiemaph-include-typesh-now-that-its-exported.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:09 -0700
Message-ID: <200904141949.n3EJn991019409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbZDNTwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/fiemap.h: include types.h now that it's exported
has been removed from the -mm tree.  Its filename was
     include-linux-fiemaph-include-typesh-now-that-its-exported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/fiemap.h: include types.h now that it's exported
From: Eric Sandeen <sandeen@redhat.com>

Include <linux/types.h> in fiemap.h.  Sam Ravnborg pointed out that this
was missing in this newly-exported header which uses the __u32 and __u64
types.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fiemap.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/fiemap.h~include-linux-fiemaph-include-typesh-now-that-its-exported include/linux/fiemap.h
--- a/include/linux/fiemap.h~include-linux-fiemaph-include-typesh-now-that-its-exported
+++ a/include/linux/fiemap.h
@@ -11,6 +11,8 @@
 #ifndef _LINUX_FIEMAP_H
 #define _LINUX_FIEMAP_H
 
+#include <linux/types.h>
+
 struct fiemap_extent {
 	__u64 fe_logical;  /* logical offset in bytes for the start of
 			    * the extent from the beginning of the file */
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch

