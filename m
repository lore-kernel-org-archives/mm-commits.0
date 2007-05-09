From: akpm@linux-foundation.org
Subject: - kernel-paramsc-fix-lying-comment-for-param_array.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:55 -0700
Message-ID: <200705090248.l492mtEt009164@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755002AbXEICtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wesarg@informatik.uni-halle.de, mm-commits@vger.kernel.org


The patch titled
     kernel/params.c: fix lying comment for param_array()
has been removed from the -mm tree.  Its filename was
     kernel-paramsc-fix-lying-comment-for-param_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/params.c: fix lying comment for param_array()
From: Bert Wesarg <wesarg@informatik.uni-halle.de>

This fixes the comment for the function param_array. Which lies that it
only *temporarily* mangle the input string @val.

Signed-off-by: Bert Wesarg <wesarg@informatik.uni-halle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/params.c~kernel-paramsc-fix-lying-comment-for-param_array kernel/params.c
--- a/kernel/params.c~kernel-paramsc-fix-lying-comment-for-param_array
+++ a/kernel/params.c
@@ -269,7 +269,7 @@ int param_get_invbool(char *buffer, stru
 	return param_get_bool(buffer, &dummy);
 }
 
-/* We cheat here and temporarily mangle the string. */
+/* We break the rule and mangle the string. */
 static int param_array(const char *name,
 		       const char *val,
 		       unsigned int min, unsigned int max,
_

Patches currently in -mm which might be from wesarg@informatik.uni-halle.de are

origin.patch
