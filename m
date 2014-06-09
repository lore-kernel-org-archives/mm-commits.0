From: akpm@linux-foundation.org
Subject: [merged]
 fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:39:08 -0700
Message-ID: <53960d5c.BQ/De5nD7O7+vKyn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:08 -0700


The patch titled
     Subject: fscache: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fscache: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fscache/main.c~fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/fscache/main.c
--- a/fs/fscache/main.c~fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/fscache/main.c
@@ -67,7 +67,7 @@ static int fscache_max_active_sysctl(str
 	return ret;
 }
 
-ctl_table fscache_sysctls[] = {
+struct ctl_table fscache_sysctls[] = {
 	{
 		.procname	= "object_max_active",
 		.data		= &fscache_object_max_active,
@@ -87,7 +87,7 @@ ctl_table fscache_sysctls[] = {
 	{}
 };
 
-ctl_table fscache_sysctls_root[] = {
+struct ctl_table fscache_sysctls_root[] = {
 	{
 		.procname	= "fscache",
 		.mode		= 0555,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

