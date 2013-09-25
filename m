From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-mach-bcm-related-email-address.patch
 removed from -mm tree
Date: Wed, 25 Sep 2013 12:06:22 -0700
Message-ID: <5243342e.yD1CF11ObR2k0lUV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3IYTGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@wwwdotorg.org, olof@lixom.net, arnd@arndb.de, csd@broadcom.com

Subject: [merged] maintainers-update-mach-bcm-related-email-address.patch removed from -mm tree
To: csd@broadcom.com,arnd@arndb.de,olof@lixom.net,swarren@wwwdotorg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:06:22 -0700


The patch titled
     Subject: MAINTAINERS: update mach-bcm related email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-mach-bcm-related-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

