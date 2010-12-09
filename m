From: akpm@linux-foundation.org
Subject: + maintainers-update-geode-entry.patch added to -mm tree
Date: Thu, 09 Dec 2010 12:58:47 -0800
Message-ID: <201012092058.oB9Kwlrd006674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199Ab0LIU6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 15:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, cjb@laptop.org, dsd@laptop.org, jordan@cosmicpenguin.net


The patch titled
     MAINTAINERS: update geode entry
has been added to the -mm tree.  Its filename is
     maintainers-update-geode-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
maintainers-update-geode-entry.patch
drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality.patch
drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api.patch

