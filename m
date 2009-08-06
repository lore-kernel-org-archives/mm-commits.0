From: akpm@linux-foundation.org
Subject: [folded] checkincludespl-add-option-to-remove-duplicates-in-place-update.patch removed from -mm tree
Date: Thu, 06 Aug 2009 15:33:22 -0700
Message-ID: <200908062233.n76MXMas015363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbZHFWdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 18:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lrodriguez@Atheros.comlrodriguez@Atheros.com, mm-commits@vger.kernel.org


The patch titled
     checkincludespl-add-option-to-remove-duplicates-in-place-update
has been removed from the -mm tree.  Its filename was
     checkincludespl-add-option-to-remove-duplicates-in-place-update.patch

This patch was dropped because it was folded into checkincludespl-add-option-to-remove-duplicates-in-place.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkincludespl-add-option-to-remove-duplicates-in-place-update
From: "Luis R. Rodriguez" <lrodriguez@Atheros.com>

some sort of documentation added.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkincludes.pl |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN scripts/checkincludes.pl~checkincludespl-add-option-to-remove-duplicates-in-place-update scripts/checkincludes.pl
--- a/scripts/checkincludes.pl~checkincludespl-add-option-to-remove-duplicates-in-place-update
+++ a/scripts/checkincludes.pl
@@ -1,8 +1,15 @@
 #!/usr/bin/perl
 #
-# checkincludes: Find files included more than once in (other) files.
+# checkincludes: find/remove files included more than once
+#
 # Copyright abandoned, 2000, Niels Kristian Bech Jensen <nkbj@image.dk>.
-# Copyright abandoned, 2009, Luis R. Rodriguez <mcgrof@gmail.com>
+# Copyright 2009 Luis R. Rodriguez <mcgrof@gmail.com>
+#
+# This script checks for duplicate includes. It also has support
+# to remove them in place. Note that this will not take into
+# consideration macros so you should run this only if you know
+# you do have real dups and do not have them under #ifdef's. You
+# could also just review the results.
 
 sub usage {
 	print "Usage: checkincludes.pl [-r]\n";
_

Patches currently in -mm which might be from lrodriguez@Atheros.com are

checkincludespl-close-file-as-soon-as-were-done-with-it.patch
checkincludespl-provide-usage-helper.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
checkincludespl-add-option-to-remove-duplicates-in-place-update.patch

