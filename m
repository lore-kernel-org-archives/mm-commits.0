From: akpm@linux-foundation.org
Subject: - make-bruce-fields-co-maintainer-of-knfsdd.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:38 -0700
Message-ID: <200707312354.l6VNscCn029162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757257AbXGaXy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, bfields@fieldses.org, mm-commits@vger.kernel.org


The patch titled
     Make Bruce Fields (co-)maintainer of kNFSDd
has been removed from the -mm tree.  Its filename was
     make-bruce-fields-co-maintainer-of-knfsdd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make Bruce Fields (co-)maintainer of kNFSDd
From: Neil Brown <neilb@suse.de>

Make Bruce Fields (co-)maintainer of kNFSDd

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~make-bruce-fields-co-maintainer-of-knfsdd MAINTAINERS
--- a/MAINTAINERS~make-bruce-fields-co-maintainer-of-knfsdd
+++ a/MAINTAINERS
@@ -2171,6 +2171,8 @@ W:	http://www.kerneljanitors.org/
 S:	Maintained
 
 KERNEL NFSD
+P:	J. Bruce Fields
+M:	bfields@fieldses.org
 P:	Neil Brown
 M:	neilb@suse.de
 L:	nfs@lists.sourceforge.net
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fs-nfsd-exportc-make-3-functions-static.patch
