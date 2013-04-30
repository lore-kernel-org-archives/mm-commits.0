From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-on-space-before-semicolon.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:32 -0700
Message-ID: <20130430185332.6FA2931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:39075 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab3D3Sxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:33 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86566vbe.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on space before semicolon
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-space-before-semicolon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-usb-storage-realtek_crc-fix-build.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

