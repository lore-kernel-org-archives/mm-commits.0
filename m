From: akpm@linux-foundation.org
Subject: [merged]
 tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:38:38 -0700
Message-ID: <53960d3e.yW8cbrD+DhZ9puUK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:38 -0700


The patch titled
     Subject: tile: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: tile: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/tile/kernel/proc.c~tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table arch/tile/kernel/proc.c
--- a/arch/tile/kernel/proc.c~tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/arch/tile/kernel/proc.c
@@ -113,7 +113,7 @@ arch_initcall(proc_tile_init);
  * Support /proc/sys/tile directory
  */
 
-static ctl_table unaligned_subtable[] = {
+static struct ctl_table unaligned_subtable[] = {
 	{
 		.procname	= "enabled",
 		.data		= &unaligned_fixup,
@@ -138,7 +138,7 @@ static ctl_table unaligned_subtable[] =
 	{}
 };
 
-static ctl_table unaligned_table[] = {
+static struct ctl_table unaligned_table[] = {
 	{
 		.procname	= "unaligned_fixup",
 		.mode		= 0555,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

