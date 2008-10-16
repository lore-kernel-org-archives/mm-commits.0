From: akpm@linux-foundation.org
Subject: + kernel-configsc-remove-useless-comments.patch added to -mm tree
Date: Thu, 16 Oct 2008 16:20:50 -0700
Message-ID: <200810162320.m9GNKoKW005093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756043AbYJPXVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 19:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangcong@zeuux.org, rdunlap@xenotime.net


The patch titled
     kernel/configs.c: remove useless comments
has been added to the -mm tree.  Its filename is
     kernel-configsc-remove-useless-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
