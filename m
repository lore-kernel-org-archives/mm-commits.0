From: akpm@linux-foundation.org
Subject: + drivers-edac-i3000-64bit-build.patch added to -mm tree
Date: Wed, 09 Jan 2008 21:28:21 -0800
Message-ID: <200801100528.m0A5S1hV006782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbYAJF2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 00:28:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: juhlenko@akamai.com, dougthompson@xmission.com


The patch titled
     drivers/edac: i3000: 64bit build
has been added to the -mm tree.  Its filename is
     drivers-edac-i3000-64bit-build.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-i3000-64bit-build.patch
drivers-edac-i3000-missing-init-code.patch
