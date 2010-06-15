From: akpm@linux-foundation.org
Subject: + submittingpatches-add-more-about-patch-descriptions.patch added to -mm tree
Date: Tue, 15 Jun 2010 12:14:52 -0700
Message-ID: <201006151914.o5FJErTD025683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758061Ab0FOTPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jun 2010 15:15:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, cl@linux-foundation.org


The patch titled
     SubmittingPatches: add more about patch descriptions
has been added to the -mm tree.  Its filename is
     submittingpatches-add-more-about-patch-descriptions.patch

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
Subject: SubmittingPatches: add more about patch descriptions
From: Randy Dunlap <randy.dunlap@oracle.com>

Add more information about patch descriptions.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN Documentation/SubmittingPatches~submittingpatches-add-more-about-patch-descriptions Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~submittingpatches-add-more-about-patch-descriptions
+++ a/Documentation/SubmittingPatches
@@ -98,6 +98,17 @@ system, git, as a "commit log".  See #15
 If your description starts to get long, that's a sign that you probably
 need to split up your patch.  See #3, next.
 
+When you submit or resubmit a patch or patch series, include the
+complete patch description and justification for it.  Don't just
+say that this is version N of the patch (series).  Don't expect the
+patch merger to refer back to earlier patch versions or referenced
+URLs to find the patch description and put that into the patch.
+I.e., the patch (series) and its description should be self-contained.
+This benefits both the patch merger(s) and reviewers.  Some reviewers
+probably didn't even receive earlier versions of the patch.
+
+If the patch fixes a logged bug entry, refer to that bug entry by
+number and URL.
 
 
 3) Separate your changes.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
compal-laptop-uses-hwmon-interfaces-depends-on-hwmon.patch
dib3000mc-reduce-large-stack-usage-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
submittingpatches-add-more-about-patch-descriptions.patch
fusion-fix-kernel-doc-warnings.patch
timerc-fix-kernel-doc-warning.patch
mtd-nand_base-fix-kernel-doc-warnings-typos.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

