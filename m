From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-cs461x-sound-card-section.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:38:02 -0700
Message-ID: <200907302038.n6UKc2Qq012463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbZG3Uid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: Remove CS461x sound card section
has been removed from the -mm tree.  Its filename was
     maintainers-remove-cs461x-sound-card-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: Remove CS461x sound card section
From: Joe Perches <joe@perches.com>

Thomas Woller's email address bounces
Nils Faerber isn't active

Added Thomas Woller to CREDITS, Nils already has an entry

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    3 +++
 MAINTAINERS |    9 ---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff -puN CREDITS~maintainers-remove-cs461x-sound-card-section CREDITS
--- a/CREDITS~maintainers-remove-cs461x-sound-card-section
+++ a/CREDITS
@@ -3805,6 +3805,9 @@ S: van Bronckhorststraat 12
 S: 2612 XV Delft
 S: The Netherlands
 
+N: Thomas Woller
+D: CS461x Cirrus Logic sound driver
+
 N: David Woodhouse
 E: dwmw2@infradead.org
 D: JFFS2 file system, Memory Technology Device subsystem,
diff -puN MAINTAINERS~maintainers-remove-cs461x-sound-card-section MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-cs461x-sound-card-section
+++ a/MAINTAINERS
@@ -1508,15 +1508,6 @@ L:	alsa-devel@alsa-project.org (moderate
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 
-CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
-P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
-S:	Maintained
-F:	Documentation/input/cs461x.txt
-F:	sound/pci/cs46xx/
