From: akpm@linux-foundation.org
Subject: - fbcon-remove-stray-semicolons.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:23 -0700
Message-ID: <200807242333.m6ONXNBD011924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756608AbYGXXdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: remove stray semicolons
has been removed from the -mm tree.  Its filename was
     fbcon-remove-stray-semicolons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: remove stray semicolons
From: "Jan Beulich" <jbeulich@novell.com>

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/console/fbcon.h~fbcon-remove-stray-semicolons drivers/video/console/fbcon.h
--- a/drivers/video/console/fbcon.h~fbcon-remove-stray-semicolons
+++ a/drivers/video/console/fbcon.h
@@ -146,10 +146,8 @@ static inline int attr_col_ec(int shift,
 	return is_fg ? fg : bg;
 }
 
-#define attr_bgcol_ec(bgshift,vc,info)		\
-	attr_col_ec(bgshift,vc,info,0);
-#define attr_fgcol_ec(fgshift,vc,info)		\
-	attr_col_ec(fgshift,vc,info,1);
+#define attr_bgcol_ec(bgshift, vc, info) attr_col_ec(bgshift, vc, info, 0)
+#define attr_fgcol_ec(fgshift, vc, info) attr_col_ec(fgshift, vc, info, 1)
 
 /* Font */
 #define REFCOUNT(fd)	(((int *)(fd))[-1])
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
linux-next.patch

