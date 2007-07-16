From: akpm@linux-foundation.org
Subject: - fs-clarify-dummy-member-in-struct.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:21 -0700
Message-ID: <200707162055.l6GKtLLO001906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755014AbXGPVMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:12:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefanr@s5r6.in-berlin.de, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs: clarify "dummy" member in struct inodes_stat_t
has been removed from the -mm tree.  Its filename was
     fs-clarify-dummy-member-in-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: clarify "dummy" member in struct inodes_stat_t
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~fs-clarify-dummy-member-in-struct include/linux/fs.h
--- a/include/linux/fs.h~fs-clarify-dummy-member-in-struct
+++ a/include/linux/fs.h
@@ -44,7 +44,7 @@ extern int get_max_files(void);
 struct inodes_stat_t {
 	int nr_inodes;
 	int nr_unused;
-	int dummy[5];
+	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
 extern struct inodes_stat_t inodes_stat;
 
_

Patches currently in -mm which might be from stefanr@s5r6.in-berlin.de are

origin.patch
git-ieee1394.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
