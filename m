From: akpm@linux-foundation.org
Subject: + checkincludespl-add-option-to-remove-duplicates-in-place-update.patch added to -mm tree
Date: Wed, 05 Aug 2009 19:22:23 -0700
Message-ID: <200908060222.n762MNgn020449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099AbZHFCW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 22:22:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lrodriguez@Atheros.comlrodriguez@Atheros.com


The patch titled
     checkincludespl-add-option-to-remove-duplicates-in-place-update
has been added to the -mm tree.  Its filename is
     checkincludespl-add-option-to-remove-duplicates-in-place-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
checkincludespl-add-option-to-remove-duplicates-in-place-fix.patch
checkincludespl-add-option-to-remove-duplicates-in-place-update.patch

