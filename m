From: akpm@linux-foundation.org
Subject: [merged]
 ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:39:28 -0700
Message-ID: <53960d70.abJeHlAWO3e0UnQs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:28 -0700


The patch titled
     Subject: ntfs: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ntfs: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ntfs/sysctl.c~ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/ntfs/sysctl.c
--- a/fs/ntfs/sysctl.c~ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/ntfs/sysctl.c
@@ -34,7 +34,7 @@
 #include "debug.h"
 
 /* Definition of the ntfs sysctl. */
-static ctl_table ntfs_sysctls[] = {
+static struct ctl_table ntfs_sysctls[] = {
 	{
 		.procname	= "ntfs-debug",
 		.data		= &debug_msgs,		/* Data pointer and size. */
@@ -46,7 +46,7 @@ static ctl_table ntfs_sysctls[] = {
 };
 
 /* Define the parent directory /proc/sys/fs. */
-static ctl_table sysctls_root[] = {
+static struct ctl_table sysctls_root[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

