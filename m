From: akpm@linux-foundation.org
Subject: [merged] minix-describe-usage-of-different-magic-numbers.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:26:19 -0800
Message-ID: <201111072026.pA7KQJD0009963@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5192 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1KGU0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:26:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kerolasa@iki.fi, mm-commits@vger.kernel.org


The patch titled
     Subject: minix: describe usage of different magic numbers
has been removed from the -mm tree.  Its filename was
     minix-describe-usage-of-different-magic-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sami Kerola <kerolasa@iki.fi>
Subject: minix: describe usage of different magic numbers

One can get this information from minix/inode.c, but adding the
explanations at the definition sites is more appropriate.

Signed-off-by: Sami Kerola <kerolasa@iki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/magic.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/magic.h~minix-describe-usage-of-different-magic-numbers include/linux/magic.h
--- a/include/linux/magic.h~minix-describe-usage-of-different-magic-numbers
+++ a/include/linux/magic.h
@@ -30,11 +30,11 @@
 #define ANON_INODE_FS_MAGIC	0x09041934
 #define PSTOREFS_MAGIC		0x6165676C
 
-#define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
-#define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */
-#define MINIX2_SUPER_MAGIC	0x2468		/* minix V2 fs */
-#define MINIX2_SUPER_MAGIC2	0x2478		/* minix V2 fs, 30 char names */
-#define MINIX3_SUPER_MAGIC	0x4d5a		/* minix V3 fs */
+#define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
+#define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
+#define MINIX2_SUPER_MAGIC	0x2468		/* minix v2 fs, 14 char names */
+#define MINIX2_SUPER_MAGIC2	0x2478		/* minix v2 fs, 30 char names */
+#define MINIX3_SUPER_MAGIC	0x4d5a		/* minix v3 fs, 60 char names */
 
 #define MSDOS_SUPER_MAGIC	0x4d44		/* MD */
 #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
_

Patches currently in -mm which might be from kerolasa@iki.fi are

origin.patch

