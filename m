From: akpm@linux-foundation.org
Subject: + maintainers-new-maintainer-for-intel-ethernet-adapters.patch added to -mm tree
Date: Wed, 07 May 2008 13:48:38 -0700
Message-ID: <200805072048.m47Kmcfx015816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428AbYEGUsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:48:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: auke-jan.h.kok@intel.com


The patch titled
     MAINTAINERS: new maintainer for Intel ethernet adapters
has been added to the -mm tree.  Its filename is
     maintainers-new-maintainer-for-intel-ethernet-adapters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: new maintainer for Intel ethernet adapters
From: Auke Kok <auke-jan.h.kok@intel.com>

I'm handing over maintainership to Jeff Kirsher and moving on to other
Linux/Open Source work within Intel.  Good luck to Jeff ;)

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-new-maintainer-for-intel-ethernet-adapters MAINTAINERS
--- a/MAINTAINERS~maintainers-new-maintainer-for-intel-ethernet-adapters
+++ a/MAINTAINERS
@@ -2119,12 +2119,10 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 
 INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)
-P:	Auke Kok
-M:	auke-jan.h.kok@intel.com
-P:	Jesse Brandeburg
-M:	jesse.brandeburg@intel.com
 P:	Jeff Kirsher
 M:	jeffrey.t.kirsher@intel.com
+P:	Jesse Brandeburg
+M:	jesse.brandeburg@intel.com
 P:	Bruce Allan
 M:	bruce.w.allan@intel.com
 P:	John Ronciak
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

linux-next.patch
maintainers-new-maintainer-for-intel-ethernet-adapters.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch

