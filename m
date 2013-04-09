From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-space-before-semicolon.patch added to -mm tree
Date: Tue, 09 Apr 2013 13:10:46 -0700
Message-ID: <20130409201046.79B045A429A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:44927 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935712Ab3DIUKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 16:10:47 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1856761iad.3
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 13:10:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: checkpatch: warn on space before semicolon
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-space-before-semicolon.patch

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
Subject: checkpatch: warn on space before semicolon

Make space before semicolon a warning instead of a --strict CHK test.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-space-before-semicolon scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-space-before-semicolon
+++ a/scripts/checkpatch.pl
@@ -2522,8 +2522,8 @@ sub process {
 
 # check for whitespace before a non-naked semicolon
 		if ($line =~ /^\+.*\S\s+;/) {
-			CHK("SPACING",
-			    "space prohibited before semicolon\n" . $herecurr);
+			WARN("SPACING",
+			     "space prohibited before semicolon\n" . $herecurr);
 		}
 
 # Check operator spacing.
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-fix-stringification-macro-defect.patch
get_maintainer-use-filename-only-regex-match-for-tegra.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
checkpatch-add-check-for-reuse-of-krealloc-arg.patch
checkpatch-prefer-seq_puts-to-seq_printf.patch
checkpatch-complain-about-executable-files.patch
checkpatch-warn-on-space-before-semicolon.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

