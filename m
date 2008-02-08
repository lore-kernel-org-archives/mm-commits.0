From: akpm@linux-foundation.org
Subject: - reiserfs-constify-function-pointer-tables.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:56 -0800
Message-ID: <200802082018.m18KIbUW010945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763012AbYBHUqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: constify function pointer tables
has been removed from the -mm tree.  Its filename was
     reiserfs-constify-function-pointer-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: constify function pointer tables
From: Jan Engelhardt <jengelh@computergmbh.de>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/procfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/procfs.c~reiserfs-constify-function-pointer-tables fs/reiserfs/procfs.c
--- a/fs/reiserfs/procfs.c~reiserfs-constify-function-pointer-tables
+++ a/fs/reiserfs/procfs.c
@@ -444,7 +444,7 @@ static int r_show(struct seq_file *m, vo
 	return show(m, v);
 }
 
-static struct seq_operations r_ops = {
+static const struct seq_operations r_ops = {
 	.start = r_start,
 	.next = r_next,
 	.stop = r_stop,
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

origin.patch
git-dvb.patch
git-kvm.patch
git-ocfs2.patch
git-unionfs.patch
git-watchdog.patch
