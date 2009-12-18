From: akpm@linux-foundation.org
Subject: [merged] security-min_addrc-make-init_mmap_min_addr-static.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:27:12 -0800
Message-ID: <200912182027.nBIKRCKu016614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932808AbZLRU1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:27:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     security/min_addr.c: make init_mmap_min_addr() static
has been removed from the -mm tree.  Its filename was
     security-min_addrc-make-init_mmap_min_addr-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security/min_addr.c: make init_mmap_min_addr() static
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

init_mmap_min_addr() is a pure_initcall and should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/min_addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/min_addr.c~security-min_addrc-make-init_mmap_min_addr-static security/min_addr.c
--- a/security/min_addr.c~security-min_addrc-make-init_mmap_min_addr-static
+++ a/security/min_addr.c
@@ -43,7 +43,7 @@ int mmap_min_addr_handler(struct ctl_tab
 	return ret;
 }
 
-int __init init_mmap_min_addr(void)
+static int __init init_mmap_min_addr(void)
 {
 	update_mmap_min_addr();
 
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
drivers-block-mg_diskc-use-resource_size.patch
adx_wdtc-use-resource_size.patch

