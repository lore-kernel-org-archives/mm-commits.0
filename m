From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:37:35 -0800
Message-ID: <5283e30f.icsPOCbwDtlFLamU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KMUhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joe@perches.com

Subject: [merged] ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:35 -0800


The patch titled
     Subject: ocfs2: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ocfs2: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/ocfs2/stackglue.c
@@ -643,7 +643,7 @@ error:
 
 #define FS_OCFS2_NM		1
 
-static ctl_table ocfs2_nm_table[] = {
+static struct ctl_table ocfs2_nm_table[] = {
 	{
 		.procname	= "hb_ctl_path",
 		.data		= ocfs2_hb_ctl_path,
@@ -654,7 +654,7 @@ static ctl_table ocfs2_nm_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_mod_table[] = {
+static struct ctl_table ocfs2_mod_table[] = {
 	{
 		.procname	= "nm",
 		.data		= NULL,
@@ -665,7 +665,7 @@ static ctl_table ocfs2_mod_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_kern_table[] = {
+static struct ctl_table ocfs2_kern_table[] = {
 	{
 		.procname	= "ocfs2",
 		.data		= NULL,
@@ -676,7 +676,7 @@ static ctl_table ocfs2_kern_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_root_table[] = {
+static struct ctl_table ocfs2_root_table[] = {
 	{
 		.procname	= "fs",
 		.data		= NULL,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
get_maintainerpl-incomplete-output.patch
linux-next.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

