From: akpm@osdl.org
Subject: + md-update-email-address-and-status-for-md-in-maintainers.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:59:43 -0800
Message-ID: <200701240659.l0O6xhaQ010969@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54890 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173AbXAXG7s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 01:59:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: update email address and status for MD in MAINTAINERS
has been added to the -mm tree.  Its filename is
     md-update-email-address-and-status-for-md-in-maintainers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch
knfsd-fix-setting-of-acl-server-versions.patch
knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch
knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
md-update-email-address-and-status-for-md-in-maintainers.patch
md-make-repair-actually-work-for-raid1.patch
md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero.patch
md-avoid-reading-past-the-end-of-a-bitmap-file.patch
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
