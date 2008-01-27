From: akpm@linux-foundation.org
Subject: + reiserfs-constify-function-pointer-tables.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:18:31 -0800
Message-ID: <200801270518.m0R5IS1F031205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58448 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbYA0FXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:23:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de, jeffm@suse.com


The patch titled
     reiserfs: constify function pointer tables
has been added to the -mm tree.  Its filename is
     reiserfs-constify-function-pointer-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kbuild.patch
git-net.patch
git-unionfs.patch
git-x86.patch
fs-fat-refine-chmod-checks.patch
documentation-about-unaligned-memory-access.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
reiserfs-constify-function-pointer-tables.patch
procfs-constify-function-pointer-tables.patch
oss-constify-function-pointer-tables.patch
