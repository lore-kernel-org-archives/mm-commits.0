From: akpm@linux-foundation.org
Subject: + make-bruce-fields-co-maintainer-of-knfsdd.patch added to -mm tree
Date: Thu, 26 Jul 2007 17:36:04 -0700
Message-ID: <200707270036.l6R0a4Nt029950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57672 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759449AbXG0Agv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 20:36:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, bfields@fieldses.org


The patch titled
     Make Bruce Fields (co-)maintainer of kNFSDd
has been added to the -mm tree.  Its filename is
     make-bruce-fields-co-maintainer-of-knfsdd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
make-bruce-fields-co-maintainer-of-knfsdd.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
