From: akpm@linux-foundation.org
Subject: [merged]
 coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:39:03 -0700
Message-ID: <53960d57.02we7LLO/sAEfyZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:03 -0700


The patch titled
     Subject: coda: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: coda: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/coda/sysctl.c~coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/coda/sysctl.c
--- a/fs/coda/sysctl.c~coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/coda/sysctl.c
@@ -14,7 +14,7 @@
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fs_table_header;
 
-static ctl_table coda_table[] = {
+static struct ctl_table coda_table[] = {
 	{
 		.procname	= "timeout",
 		.data		= &coda_timeout,
@@ -39,7 +39,7 @@ static ctl_table coda_table[] = {
 	{}
 };
 
-static ctl_table fs_table[] = {
+static struct ctl_table fs_table[] = {
 	{
 		.procname	= "coda",
 		.mode		= 0555,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

