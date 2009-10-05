From: akpm@linux-foundation.org
Subject: [merged] docs-update-patch-size-in-submittingpatches.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:38:26 -0700
Message-ID: <200910051838.n95IcQRu016965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbZJESjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docs: update patch size in SubmittingPatches
has been removed from the -mm tree.  Its filename was
     docs-update-patch-size-in-submittingpatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
input-serio_libps2-depends-on-serio_i8042.patch
scsi-fix-func-names-in-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch

