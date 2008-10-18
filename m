From: akpm@linux-foundation.org
Subject: - fix-typo-in-the-firmware_in_kernel-help.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:07 -0700
Message-ID: <200810182312.m9INC7kC027933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbYJRXMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albertito@blitiri.com.ar, mm-commits@vger.kernel.org


The patch titled
     Fix typo in the FIRMWARE_IN_KERNEL help
has been removed from the -mm tree.  Its filename was
     fix-typo-in-the-firmware_in_kernel-help.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix typo in the FIRMWARE_IN_KERNEL help
From: Alberto Bertogli <albertito@blitiri.com.ar>

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/Kconfig~fix-typo-in-the-firmware_in_kernel-help drivers/base/Kconfig
--- a/drivers/base/Kconfig~fix-typo-in-the-firmware_in_kernel-help
+++ a/drivers/base/Kconfig
@@ -54,7 +54,7 @@ config FIRMWARE_IN_KERNEL
 	  such firmware, and do not wish to use an initrd.
 
 	  This single option controls the inclusion of firmware for
-	  every driver which usees request_firmare() and ships its
+	  every driver which uses request_firmare() and ships its
 	  firmware in the kernel source tree, to avoid a proliferation
 	  of 'Include firmware for xxx device' options.
 
_

Patches currently in -mm which might be from albertito@blitiri.com.ar are

origin.patch

