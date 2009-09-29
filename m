From: akpm@linux-foundation.org
Subject: + docs-update-patch-size-in-submittingpatches.patch added to -mm tree
Date: Tue, 29 Sep 2009 13:29:31 -0700
Message-ID: <200909292029.n8TKTVaR020921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501AbZI2U3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 16:29:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     docs: update patch size in SubmittingPatches
has been added to the -mm tree.  Its filename is
     docs-update-patch-size-in-submittingpatches.patch

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
Subject: docs: update patch size in SubmittingPatches
From: Randy Dunlap <randy.dunlap@oracle.com>

This patch size comment is like so last millenium.  Update it to modern
times.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~docs-update-patch-size-in-submittingpatches Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~docs-update-patch-size-in-submittingpatches
+++ a/Documentation/SubmittingPatches
@@ -232,7 +232,7 @@ your e-mail client so that it sends your
 When sending patches to Linus, always follow step #7.
 
 Large changes are not appropriate for mailing lists, and some
-maintainers.  If your patch, uncompressed, exceeds 40 kB in size,
+maintainers.  If your patch, uncompressed, exceeds 300 kB in size,
 it is preferred that you store your patch on an Internet-accessible
 server, and provide instead a URL (link) pointing to your patch.
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
docs-update-patch-size-in-submittingpatches.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch

