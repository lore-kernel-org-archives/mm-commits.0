From: akpm@linux-foundation.org
Subject: + checkpatch-fix-long-line-messages-about-patch-context.patch
 added to -mm tree
Date: Thu, 09 Jul 2015 14:12:16 -0700
Message-ID: <559ee3b0.Q8rXxZmW8qRei/MT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbGIVMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 17:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix long line messages about patch context
has been added to the -mm tree.  Its filename is
     checkpatch-fix-long-line-messages-about-patch-context.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-long-line-messages-about-patch-context.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-long-line-messages-about-patch-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: fix long line messages about patch context

Changes in ("checkpatch: categorize some long line length checks")
now erroneously reports long line defects in patch context.

Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-long-line-messages-about-patch-context scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-long-line-messages-about-patch-context
+++ a/scripts/checkpatch.pl
@@ -2608,7 +2608,7 @@ sub process {
 # if LONG_LINE is ignored, the other 2 types are also ignored
 #
 
-		if ($length > $max_line_length) {
+		if ($line =~ /^\+/ && $length > $max_line_length) {
 			my $msg_type = "LONG_LINE";
 
 			# Check the allowed long line types first
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-fix-long-line-messages-about-patch-context.patch
hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
seq_file-provide-an-analogue-of-print_hex_dump.patch
crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
parisc-use-seq_hex_dump-to-dump-buffers.patch
zcrypt-use-seq_hex_dump-to-dump-buffers.patch
kmemleak-use-seq_hex_dump-to-dump-buffers.patch
wil6210-use-seq_hex_dump-to-dump-buffers.patch
linux-next.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

