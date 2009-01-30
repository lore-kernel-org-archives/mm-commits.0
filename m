From: akpm@linux-foundation.org
Subject: + checkpatch-add-__ref-as-a-sparse-modifier.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:53:56 -0800
Message-ID: <200901302153.n0ULru5R031330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755126AbZA3Vx7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:53:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: add __ref as a sparse modifier
has been added to the -mm tree.  Its filename is
     checkpatch-add-__ref-as-a-sparse-modifier.patch

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
Subject: checkpatch: add __ref as a sparse modifier
From: Andy Whitcroft <apw@canonical.com>

Add __ref as a sparse modifier.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-__ref-as-a-sparse-modifier scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-__ref-as-a-sparse-modifier
+++ a/scripts/checkpatch.pl
@@ -110,7 +110,8 @@ our $Sparse	= qr{
 			__iomem|
 			__must_check|
 			__init_refok|
-			__kprobes
+			__kprobes|
+			__ref
 		}x;
 our $Attribute	= qr{
 			const|
_

Patches currently in -mm which might be from apw@canonical.com are

mmc-add-modalias-linkage-for-mmc-sd-devices.patch
checkpatch-make-in_atomic-ok-in-the-core.patch
checkpatch-do-not-warn-about-p0-patches-when-checking-files.patch
checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers.patch
checkpatch-pointer-type-star-may-have-modifiers-following.patch
checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch
checkpatch-extend-attribute-testing-to-all-modifiers.patch
checkpatch-add-__ref-as-a-sparse-modifier.patch
checkpatch-version-028.patch

