From: akpm@linux-foundation.org
Subject: + checkpatch-add-suggested-by-as-a-standard-signature.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:59:13 -0700
Message-ID: <20130424225913.6E9FF31C19E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:63772 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab3DXW7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:59:14 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so256324ggm.5
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:59:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mugunthanvnm@ti.com, apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: add Suggested-by as a standard signature
has been added to the -mm tree.  Its filename is
     checkpatch-add-suggested-by-as-a-standard-signature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
checkpatch-add-suggested-by-as-a-standard-signature.patch

