From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:47 -0700
Message-ID: <5591af2f.bVPJmI3tO3M3DgKd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbbF2Usr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid NOT_UNIFIED_DIFF errors on cover-letter.patch files
has been removed from the -mm tree.  Its filename was
     checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: avoid NOT_UNIFIED_DIFF errors on cover-letter.patch files

Make an exception for the "Does not appear to be a unified-diff" error
when scanning what appears to be git generated cover letters.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files
+++ a/scripts/checkpatch.pl
@@ -5614,7 +5614,7 @@ sub process {
 		exit(0);
 	}
 
-	if (!$is_patch) {
+	if (!$is_patch && $file !~ /cover-letter\.patch$/) {
 		ERROR("NOT_UNIFIED_DIFF",
 		      "Does not appear to be a unified-diff format patch\n");
 	}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

