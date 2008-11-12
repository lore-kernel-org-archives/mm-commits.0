From: akpm@linux-foundation.org
Subject: - ssb-hide-empty-sub-menu.patch removed from -mm tree
Date: Wed, 12 Nov 2008 12:47:15 -0800
Message-ID: <200811122047.mACKlFw3006923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863AbYKLUsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 15:48:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, johannes@sipsolutions.net, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     ssb: hide empty sub menu
has been removed from the -mm tree.  Its filename was
     ssb-hide-empty-sub-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ssb: hide empty sub menu
From: Mike Frysinger <vapier@gentoo.org>

If the target system cannot support SSB, then don't show the menu option as
it'll simply be an empty submenu.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ssb/Kconfig~ssb-hide-empty-sub-menu drivers/ssb/Kconfig
--- a/drivers/ssb/Kconfig~ssb-hide-empty-sub-menu
+++ a/drivers/ssb/Kconfig
@@ -1,10 +1,11 @@
-menu "Sonics Silicon Backplane"
