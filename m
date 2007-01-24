From: akpm@osdl.org
Subject: + knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:52:36 -0800
Message-ID: <200701240652.l0O6qaYW010838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54780 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004AbXAXGws (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 01:52:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     knfsd: update email address and status for NFSD in MAINTAINERS
has been added to the -mm tree.  Its filename is
     knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch
knfsd-fix-setting-of-acl-server-versions.patch
knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch
knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
