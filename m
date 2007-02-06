From: akpm@linux-foundation.org
Subject: + scnprintf-fix-comment.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:09:51 -0800
Message-ID: <200702062309.l16N9pe1032148@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030533AbXBFXJ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:09:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com


The patch titled
     scnprintf(): fix a comment
has been added to the -mm tree.  Its filename is
     scnprintf-fix-comment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scnprintf(): fix a comment
From: Martin Peschke <mp3@de.ibm.com>

The return value of scnprintf() never exceeds @size.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/vsprintf.c~scnprintf-fix-comment lib/vsprintf.c
--- a/lib/vsprintf.c~scnprintf-fix-comment
+++ a/lib/vsprintf.c
@@ -554,8 +554,7 @@ EXPORT_SYMBOL(snprintf);
  * @...: Arguments for the format string
  *
  * The return value is the number of characters written into @buf not including
- * the trailing '\0'. If @size is <= 0 the function returns 0. If the return is
- * greater than or equal to @size, the resulting string is truncated.
+ * the trailing '\0'. If @size is <= 0 the function returns 0.
  */
 
 int scnprintf(char * buf, size_t size, const char *fmt, ...)
_

Patches currently in -mm which might be from mp3@de.ibm.com are

scnprintf-fix-comment.patch
statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution-ia64-fix.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
statistics-infrastructure-adapt-output-format-of-utilisation-indicator.patch
statistics-use-the-enhanced-percpu-interface.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
statistics-infrastructure-exploitation-zfcp.patch
zfcp-gather-hba-specific-latencies-in-statistics.patch
