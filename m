From: akpm@linux-foundation.org
Subject: + fs-clarify-dummy-member-in-struct.patch added to -mm tree
Date: Wed, 30 May 2007 15:35:58 -0700
Message-ID: <200705302235.l4UMZwt5006840@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbXE3WgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 18:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefanr@s5r6.in-berlin.de, randy.dunlap@oracle.com


The patch titled
     fs: clarify "dummy" member in struct inodes_stat_t
has been added to the -mm tree.  Its filename is
     fs-clarify-dummy-member-in-struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: clarify "dummy" member in struct inodes_stat_t
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

git-ieee1394.patch
git-scsi-misc.patch
fs-clarify-dummy-member-in-struct.patch
