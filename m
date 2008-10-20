From: akpm@linux-foundation.org
Subject: - kernel-configsc-remove-useless-comments.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:45 -0700
Message-ID: <200810202034.m9KKYjt2010923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754120AbYJTUqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangcong@zeuux.org, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     kernel/configs.c: remove useless comments
has been removed from the -mm tree.  Its filename was
     kernel-configsc-remove-useless-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/configs.c: remove useless comments
From: WANG Cong <wangcong@zeuux.org>

These comments are useless, remove them.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN kernel/configs.c~kernel-configsc-remove-useless-comments kernel/configs.c
--- a/kernel/configs.c~kernel-configsc-remove-useless-comments
+++ a/kernel/configs.c
@@ -54,9 +54,6 @@
 
 #ifdef CONFIG_IKCONFIG_PROC
 
-/**************************************************/
-/* globals and useful constants                   */
-
 static ssize_t
 ikconfig_read_current(struct file *file, char __user *buf,
 		      size_t len, loff_t * offset)
@@ -71,9 +68,6 @@ static const struct file_operations ikco
 	.read = ikconfig_read_current,
 };
 
-/***************************************************/
-/* ikconfig_init: start up everything we need to */
-
 static int __init ikconfig_init(void)
 {
 	struct proc_dir_entry *entry;
@@ -89,9 +83,6 @@ static int __init ikconfig_init(void)
 	return 0;
 }
 
-/***************************************************/
-/* ikconfig_cleanup: clean up our mess           */
