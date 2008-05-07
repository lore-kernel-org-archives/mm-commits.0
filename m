From: akpm@linux-foundation.org
Subject: + update-geode-mailing-list-in-maintainers.patch added to -mm tree
Date: Wed, 07 May 2008 09:59:19 -0700
Message-ID: <200805071659.m47GxJRr006885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758897AbYEGQ7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 12:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jordan.crouse@amd.com


The patch titled
     Update Geode mailing list in MAINTAINERS
has been added to the -mm tree.  Its filename is
     update-geode-mailing-list-in-maintainers.patch

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
Subject: Update Geode mailing list in MAINTAINERS
From: Jordan Crouse <jordan.crouse@amd.com>

Update the Geode list location in the MAINTAINERS file.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~update-geode-mailing-list-in-maintainers MAINTAINERS
--- a/MAINTAINERS~update-geode-mailing-list-in-maintainers
+++ a/MAINTAINERS
@@ -367,12 +367,12 @@ S:	Maintained for 2.4; PCI support for 2
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
 M:	thomas.dahlmann@amd.com
-L:	info-linux@geode.amd.com	(subscribers-only)
+L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
-L:	info-linux@geode.amd.com	(subscribers-only)
+L:	linux-geode@lists.infradead.org (moderated for non-subscribers)	
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
 
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-define-geode_has_vsa2-even-if-config_mgeode_lx-is-not-set.patch
git-watchdog.patch
update-geode-mailing-list-in-maintainers.patch

