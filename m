From: akpm@osdl.org
Subject: - knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:44 -0800
Message-ID: <200701270131.l0R1Vigl031855@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35471 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbXA0Bb4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: update email address and status for NFSD in MAINTAINERS
has been removed from the -mm tree.  Its filename was
     knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: update email address and status for NFSD in MAINTAINERS
From: NeilBrown <neilb@suse.de>

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~knfsd-update-email-address-and-status-for-nfsd-in-maintainers MAINTAINERS
--- a/MAINTAINERS~knfsd-update-email-address-and-status-for-nfsd-in-maintainers
+++ a/MAINTAINERS
@@ -1928,11 +1928,10 @@ S:	Maintained
 
 KERNEL NFSD
 P:	Neil Brown
-M:	neilb@cse.unsw.edu.au
+M:	neilb@suse.de
 L:	nfs@lists.sourceforge.net
 W:	http://nfs.sourceforge.net/
-W:	http://www.cse.unsw.edu.au/~neilb/patches/linux-devel/
-S:	Maintained
+S:	Supported
 
 KERNEL VIRTUAL MACHINE (KVM)
 P:	Avi Kivity
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
