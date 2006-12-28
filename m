From: akpm@osdl.org
Subject: + update-credits-and-maintainers-entries-for-lennert-buytenhek.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:06:24 -0800
Message-ID: <200612282306.kBSN6O6L015638@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40289 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965055AbWL1XG3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:06:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org


The patch titled
     Update CREDITS and MAINTAINERS entries for Lennert Buytenhek
has been added to the -mm tree.  Its filename is
     update-credits-and-maintainers-entries-for-lennert-buytenhek.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update CREDITS and MAINTAINERS entries for Lennert Buytenhek
From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 CREDITS     |    7 +-
 MAINTAINERS |  126 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 130 insertions(+), 3 deletions(-)

diff -puN CREDITS~update-credits-and-maintainers-entries-for-lennert-buytenhek CREDITS
--- a/CREDITS~update-credits-and-maintainers-entries-for-lennert-buytenhek
+++ a/CREDITS
@@ -516,9 +516,10 @@ S: Orlando, Florida
 S: USA
 
 N: Lennert Buytenhek
-E: buytenh@gnu.org
-D: Rewrite of the ethernet bridging code
-S: Ravenhorst 58B
+E: kernel@wantstofly.org
+D: Original (2.4) rewrite of the ethernet bridging code
+D: Various ARM bits and pieces
+S: Ravenhorst 58
 S: 2317 AK Leiden
 S: The Netherlands
 
diff -puN MAINTAINERS~update-credits-and-maintainers-entries-for-lennert-buytenhek MAINTAINERS
--- a/MAINTAINERS~update-credits-and-maintainers-entries-for-lennert-buytenhek
+++ a/MAINTAINERS
@@ -355,6 +355,24 @@ P:	Ian Molton
 M:	spyro@f2s.com
 S:	Maintained
 
+ARM/ADI ROADRUNNER MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/ADS SPHERE MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/AJECO 1ARM MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
 P:      Andrew Victor
 M:      andrew@sanpeople.com
@@ -362,17 +380,89 @@ L:      linux-arm-kernel@lists.arm.linux
 W:      http://maxim.org.za/at91_26.html
 S:      Maintained
 
+ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
 ARM/CORGI MACHINE SUPPORT
 P:	Richard Purdie
 M:	rpurdie@rpsys.net
 S:	Maintained
 
+ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
 ARM/HP JORNADA 7XX MACHINE SUPPORT
 P:      Kristoffer Ericson
 M:      kristoffer_e1@hotmail.com
 W:      www.jlime.com
 S:      Maintained
 
+ARM/INTEL IOP32X ARM ARCHITECTURE
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/INTEL IOP13XX ARM ARCHITECTURE
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/INTEL IQ81342EX MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/INTEL IXP2000 ARM ARCHITECTURE
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/INTEL IXDP2850 MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/INTEL IXP23XX ARM ARCHITECTURE
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/INTEL XSC3 (MANZANO) ARM CORE
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/IP FABRICS DOUBLE ESPRESSO MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/LOGICPD PXA270 MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
 ARM/TOSA MACHINE SUPPORT
 P:	Dirk Opfer
 M:	dirk@opfer-online.de
@@ -391,6 +481,12 @@ L:	linux-arm-kernel@lists.arm.linux.org.
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
+ARM/RADISYS ENP2611 MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
 ARM/SHARK MACHINE SUPPORT
 P:	Alexander Schulz
 M:	alex@shark-linux.de
@@ -418,6 +514,18 @@ L:	linux-arm-kernel@lists.arm.linux.org.
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 
+ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
+ARM/THECUS N2100 MACHINE SUPPORT
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
 ARPD SUPPORT
 P:	Jonathan Layes
 L:	netdev@vger.kernel.org
@@ -706,12 +814,24 @@ M:	joel.becker@oracle.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
+CIRRUS LOGIC EP93XX ETHERNET DRIVER
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	netdev@vger.kernel.org
+S:	Maintained
+
 CIRRUS LOGIC GENERIC FBDEV DRIVER
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Odd Fixes
 
+CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	linux-usb-devel@lists.sourceforge.net
+S:	Maintained
+
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
 P:	Cirrus Logic Corporation (kernel 2.2 driver)
 M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
@@ -1593,6 +1713,12 @@ P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
 
+INTEL IXP2000 ETHERNET DRIVER
+P:	Lennert Buytenhek
+M:	kernel@wantstofly.org
+L:	netdev@vger.kernel.org
+S:	Maintained
+
 INTEL PRO/100 ETHERNET SUPPORT
 P:	John Ronciak
 M:	john.ronciak@intel.com
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

update-credits-and-maintainers-entries-for-lennert-buytenhek.patch
git-netdev-all.patch

