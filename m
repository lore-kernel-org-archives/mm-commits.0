From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-geode-entry.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:32 -0800
Message-ID: <201012232240.oBNMeKOB015445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab0LWWk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, cjb@laptop.org, dsd@laptop.org, jordan@cosmicpenguin.net, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update geode entry
has been removed from the -mm tree.  Its filename was
     maintainers-update-geode-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update geode entry
From: Andres Salomon <dilinger@queued.net>

Remove Jordan as the geode maintainer (he's not been interested in geode for
some time), and add myself as the maintainer.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-geode-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-update-geode-entry
+++ a/MAINTAINERS
@@ -405,7 +405,7 @@ S:	Supported
 F:	drivers/usb/gadget/amd5536udc.*
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
-P:	Jordan Crouse
+P:	Andres Salomon <dilinger@queued.net>
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
linux-next.patch
drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality.patch
drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api.patch
cs5535-deprecate-older-cs5535_gpio-driver.patch

