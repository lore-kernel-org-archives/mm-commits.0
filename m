From: akpm@linux-foundation.org
Subject: + maintainers-update-mach-bcm-related-email-address.patch added
 to -mm tree
Date: Fri, 20 Sep 2013 15:44:35 -0700
Message-ID: <523ccfd3.OQbQ68Vh5XaDOw6B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3ITWog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 18:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@wwwdotorg.org, olof@lixom.net, arnd@arndb.de, csd@broadcom.com

Subject: + maintainers-update-mach-bcm-related-email-address.patch added to -mm tree
To: csd@broadcom.com,arnd@arndb.de,olof@lixom.net,swarren@wwwdotorg.org
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 15:44:35 -0700


The patch titled
     Subject: MAINTAINERS: update mach-bcm related email address
has been added to the -mm tree.  Its filename is
     maintainers-update-mach-bcm-related-email-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-mach-bcm-related-email-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-mach-bcm-related-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Christian Daudt" <csd@broadcom.com>
Subject: MAINTAINERS: update mach-bcm related email address

Update email address on mach-bcm + drivers for Broadcom mobile SoCs.

Signed-off-by: Christian Daudt <csd@broadcom.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-mach-bcm-related-email-address MAINTAINERS
--- a/MAINTAINERS~maintainers-update-mach-bcm-related-email-address
+++ a/MAINTAINERS
@@ -1812,7 +1812,8 @@ S:	Supported
 F:	drivers/net/ethernet/broadcom/bnx2x/
 
 BROADCOM BCM281XX/BCM11XXX ARM ARCHITECTURE
-M:	Christian Daudt <csd@broadcom.com>
+M:	Christian Daudt <bcm@fixthebug.org>
+L:	bcm-kernel-feedback-list@broadcom.com
 T:	git git://git.github.com/broadcom/bcm11351
 S:	Maintained
 F:	arch/arm/mach-bcm/
_

Patches currently in -mm which might be from csd@broadcom.com are

maintainers-update-mach-bcm-related-email-address.patch

