From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise.patch removed from -mm tree
Date: Mon, 23 Nov 2009 11:37:53 -0800
Message-ID: <200911231937.nANJbrED018875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333AbZKWThz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 14:37:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, gregkh@suse.de, hsweeten@visionengravers.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/core/hcd.c: quiet NULL pointer sparse noise
has been removed from the -mm tree.  Its filename was
     drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/core/hcd.c: quiet NULL pointer sparse noise
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

Quiet the following sparse noise:

  warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/core/hcd.c~drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise
+++ a/drivers/usb/core/hcd.c
@@ -1607,7 +1607,7 @@ int usb_hcd_check_bandwidth(struct usb_d
 {
 	int num_intfs, i, j;
 	struct usb_interface_cache *intf_cache;
-	struct usb_host_interface *alt = 0;
+	struct usb_host_interface *alt = NULL;
 	int ret = 0;
 	struct usb_hcd *hcd;
 	struct usb_host_endpoint *ep;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
clockeventsc-fix-symbol-was-not-declared-noise.patch
security-min_addrc-make-init_mmap_min_addr-static.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch
kernel-sysc-fix-warning-do-while-statement-is-not-a-compound-statement-noise.patch

