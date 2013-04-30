From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-suggested-by-as-a-standard-signature.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:38 -0700
Message-ID: <20130430185338.7AB3831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:63951 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab3D3Sxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:39 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so86639vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mugunthanvnm@ti.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add Suggested-by as a standard signature
has been removed from the -mm tree.  Its filename was
     checkpatch-add-suggested-by-as-a-standard-signature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mugunthan V N <mugunthanvnm@ti.com>
Subject: checkpatch: add Suggested-by as a standard signature

As people started using Suggested-by as standard signature, adding
"Suggested-by" to the standard signature so that checkpatch won't generate
warning when Suggested-by is used in patch signature

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    9 ++++++++-
 scripts/checkpatch.pl           |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~checkpatch-add-suggested-by-as-a-standard-signature Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~checkpatch-add-suggested-by-as-a-standard-signature
+++ a/Documentation/SubmittingPatches
@@ -420,7 +420,7 @@ person it names.  This tag documents tha
 have been included in the discussion
 
 
-14) Using Reported-by:, Tested-by: and Reviewed-by:
+14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
 
 If this patch fixes a problem reported by somebody else, consider adding a
 Reported-by: tag to credit the reporter for their contribution.  Please
@@ -468,6 +468,13 @@ done on the patch.  Reviewed-by: tags, w
 understand the subject area and to perform thorough reviews, will normally
 increase the likelihood of your patch getting into the kernel.
 
+A Suggested-by: tag indicates that the patch idea is suggested by the person
+named and ensures credit to the person for the idea. Please note that this
+tag should not be added without the reporter's permission, especially if the
+idea was not posted in a public forum. That said, if we diligently credit our
+idea reporters, they will, hopefully, be inspired to help us again in the
+future.
+
 
 15) The canonical patch format
 
diff -puN scripts/checkpatch.pl~checkpatch-add-suggested-by-as-a-standard-signature scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-suggested-by-as-a-standard-signature
+++ a/scripts/checkpatch.pl
@@ -281,6 +281,7 @@ our $signature_tags = qr{(?xi:
 	Tested-by:|
 	Reviewed-by:|
 	Reported-by:|
+	Suggested-by:|
 	To:|
 	Cc:
 )};
_

Patches currently in -mm which might be from mugunthanvnm@ti.com are

origin.patch
linux-next.patch

