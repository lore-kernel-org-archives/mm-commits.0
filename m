From: akpm@linux-foundation.org
Subject: - drivers-edac-i3000-64bit-build.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:01 -0800
Message-ID: <200802080805.m1885gKi014369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760320AbYBHIT1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juhlenko@akamai.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: i3000: 64bit build
has been removed from the -mm tree.  Its filename was
     drivers-edac-i3000-64bit-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/edac: i3000: 64bit build
From: Jason Uhlenkott <juhlenko@akamai.com>

Modified to run on x86_64 as well as x86

i3000_edac builds (and runs) fine on x86_64.

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/Kconfig~drivers-edac-i3000-64bit-build drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~drivers-edac-i3000-64bit-build
+++ a/drivers/edac/Kconfig
@@ -97,7 +97,7 @@ config EDAC_I82975X
 
 config EDAC_I3000
 	tristate "Intel 3000/3010"
-	depends on EDAC_MM_EDAC && PCI && X86_32
+	depends on EDAC_MM_EDAC && PCI && X86
 	help
 	  Support for error detection and correction on the Intel
 	  3000 and 3010 server chipsets.
_

Patches currently in -mm which might be from juhlenko@akamai.com are

origin.patch
