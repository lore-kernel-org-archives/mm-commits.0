From: akpm@linux-foundation.org
Subject: - knfsd-change-mailing-list-for-nfsd-in-maintainers.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:32:40 -0800
Message-ID: <200712132332.lBDNWeh4023984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757208AbXLMXdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:33:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     knfsd: change mailing list for nfsd in MAINTAINERS
has been removed from the -mm tree.  Its filename was
     knfsd-change-mailing-list-for-nfsd-in-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: change mailing list for nfsd in MAINTAINERS
From: NeilBrown <neilb@suse.de>

nfs@lists.sourceforge.net is being decommissioned.

Acked-by: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~knfsd-change-mailing-list-for-nfsd-in-maintainers MAINTAINERS
--- a/MAINTAINERS~knfsd-change-mailing-list-for-nfsd-in-maintainers
+++ a/MAINTAINERS
@@ -2259,7 +2259,7 @@ P:	J. Bruce Fields
 M:	bfields@fieldses.org
 P:	Neil Brown
 M:	neilb@suse.de
-L:	nfs@lists.sourceforge.net
+L:	linux-nfs@vger.kernel.org
 W:	http://nfs.sourceforge.net/
 S:	Supported
 
_

Patches currently in -mm which might be from neilb@suse.de are

git-nfs.patch
git-nfsd.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
md-raid6-fix-mktablec.patch
md-raid6-clean-up-the-style-of-raid6test-testc.patch
md-update-md-bitmap-during-resync.patch
md-update-md-bitmap-during-resync-fix.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
