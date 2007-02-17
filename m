From: akpm@linux-foundation.org
Subject: - use-__u64-rather-than-u64-in-parisc-statfs-structs.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:17:15 -0800
Message-ID: <200702170717.l1H7HFcG021777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51238 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946545AbXBQHRT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     use __u64 rather than u64 in parisc statfs structs
has been removed from the -mm tree.  Its filename was
     use-__u64-rather-than-u64-in-parisc-statfs-structs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use __u64 rather than u64 in parisc statfs structs
From: Mike Frysinger <vapier@gentoo.org>

Use __u64 rather than u64 in the struct statfs64 exported to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/statfs.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/asm-parisc/statfs.h~use-__u64-rather-than-u64-in-parisc-statfs-structs include/asm-parisc/statfs.h
--- a/include/asm-parisc/statfs.h~use-__u64-rather-than-u64-in-parisc-statfs-structs
+++ a/include/asm-parisc/statfs.h
@@ -30,11 +30,11 @@ struct statfs {
 struct statfs64 {
 	long f_type;
 	long f_bsize;
-	u64 f_blocks;
-	u64 f_bfree;
-	u64 f_bavail;
-	u64 f_files;
-	u64 f_ffree;
+	__u64 f_blocks;
+	__u64 f_bfree;
+	__u64 f_bavail;
+	__u64 f_files;
+	__u64 f_ffree;
 	__kernel_fsid_t f_fsid;
 	long f_namelen;
 	long f_frsize;
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
git-sh.patch
