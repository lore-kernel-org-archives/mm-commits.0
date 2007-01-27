From: akpm@osdl.org
Subject: - md-update-email-address-and-status-for-md-in-maintainers.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:54 -0800
Message-ID: <200701270131.l0R1Vsvf031870@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35503 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbXA0BcC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: update email address and status for MD in MAINTAINERS
has been removed from the -mm tree.  Its filename was
     md-update-email-address-and-status-for-md-in-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: update email address and status for MD in MAINTAINERS
From: NeilBrown <neilb@suse.de>

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~md-update-email-address-and-status-for-md-in-maintainers MAINTAINERS
--- a/MAINTAINERS~md-update-email-address-and-status-for-md-in-maintainers
+++ a/MAINTAINERS
@@ -2992,9 +2992,9 @@ SOFTWARE RAID (Multiple Disks) SUPPORT
 P:	Ingo Molnar
 M:	mingo@redhat.com
 P:	Neil Brown
-M:	neilb@cse.unsw.edu.au
+M:	neilb@suse.de
 L:	linux-raid@vger.kernel.org
-S:	Maintained
+S:	Supported
 
 SOFTWARE SUSPEND:
 P:	Pavel Machek
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
