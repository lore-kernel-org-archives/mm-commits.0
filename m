From: akpm@linux-foundation.org
Subject: [merged] suncom-documentation-fixes.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:47 -0800
Message-ID: <20130222203947.9F4FC31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:57803 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab3BVUjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:48 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103534vbi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists@nerdbynature.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sun.com documentation fixes
has been removed from the -mm tree.  Its filename was
     suncom-documentation-fixes.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Christian Kujau <lists@nerdbynature.de>
Subject: sun.com documentation fixes

After I came across a help text for SUNGEM mentioning a broken sun.com
URL, I felt like fixing those up, as they are now pointing to oracle.co=
m
URLs.

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/booting-without-of.txt |    2 +-
 drivers/net/ethernet/sun/Kconfig                |    4 ++--
 include/uapi/linux/elf.h                        |   12 ++++++------
 net/ipv6/Kconfig                                |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN Documentation/devicetree/booting-without-of.txt~suncom-docume=
ntation-fixes Documentation/devicetree/booting-without-of.txt
--- a/Documentation/devicetree/booting-without-of.txt~suncom-documentat=
ion-fixes
+++ a/Documentation/devicetree/booting-without-of.txt
@@ -1228,7 +1228,7 @@ hierarchy and routing of interrupts in t
 The interrupt tree model is fully described in the
 document "Open Firmware Recommended Practice: Interrupt
 Mapping Version 0.9".  The document is available at:
-<http://playground.sun.com/1275/practice>.
+<http://www.openfirmware.org/ofwg/practice/>
=20
 1) interrupts property
 ----------------------
diff -puN drivers/net/ethernet/sun/Kconfig~suncom-documentation-fixes d=
rivers/net/ethernet/sun/Kconfig
--- a/drivers/net/ethernet/sun/Kconfig~suncom-documentation-fixes
+++ a/drivers/net/ethernet/sun/Kconfig
@@ -61,7 +61,7 @@ config SUNGEM
 	select SUNGEM_PHY
 	---help---
 	  Support for the Sun GEM chip, aka Sun GigabitEthernet/P 2.0.  See a=
lso
-	  <http://www.sun.com/products-n-solutions/hardware/docs/pdf/806-3985=
-10.pdf>.
+	  <http://docs.oracle.com/cd/E19455-01/806-3985-10/806-3985-10.pdf>.
=20
 config CASSINI
 	tristate "Sun Cassini support"
@@ -69,7 +69,7 @@ config CASSINI
 	select CRC32
 	---help---
 	  Support for the Sun Cassini chip, aka Sun GigaSwift Ethernet. See a=
lso
-	  <http://www.sun.com/products-n-solutions/hardware/docs/pdf/817-4341=
-10.pdf>
+	  <http://docs.oracle.com/cd/E19113-01/giga.ether.pci/817-4341-10/817=
-4341-10.pdf>.
=20
 config SUNVNET
 	tristate "Sun Virtual Network support"
diff -puN include/uapi/linux/elf.h~suncom-documentation-fixes include/u=
api/linux/elf.h
--- a/include/uapi/linux/elf.h~suncom-documentation-fixes
+++ a/include/uapi/linux/elf.h
@@ -49,14 +49,14 @@ typedef __s64	Elf64_Sxword;
  *
  * Specifications are available in:
  *
- * - Sun microsystems: Linker and Libraries.
- *   Part No: 817-1984-17, September 2008.
- *   URL: http://docs.sun.com/app/docs/doc/817-1984
+ * - Oracle: Linker and Libraries.
+ *   Part No: 817=E2=80=931984=E2=80=9319, August 2011.
+ *   http://docs.oracle.com/cd/E18752_01/pdf/817-1984.pdf
  *
  * - System V ABI AMD64 Architecture Processor Supplement
- *   Draft Version 0.99.,
- *   May 11, 2009.
- *   URL: http://www.x86-64.org/
+ *   Draft Version 0.99.4,
+ *   January 13, 2010.
+ *   http://www.cs.washington.edu/education/courses/cse351/12wi/supp-d=
ocs/abi.pdf
  */
 #define PN_XNUM 0xffff
=20
diff -puN net/ipv6/Kconfig~suncom-documentation-fixes net/ipv6/Kconfig
--- a/net/ipv6/Kconfig~suncom-documentation-fixes
+++ a/net/ipv6/Kconfig
@@ -11,7 +11,7 @@ menuconfig IPV6
 	  You will still be able to do traditional IPv4 networking as well.
=20
 	  For general information about IPv6, see
-	  <http://playground.sun.com/pub/ipng/html/ipng-main.html>.
+	  <https://en.wikipedia.org/wiki/IPv6>.
 	  For Linux IPv6 development information, see <http://www.linux-ipv6.=
org>.
 	  For specific information about IPv6 under Linux, read the HOWTO at
 	  <http://www.bieringer.de/linux/IPv6/>.
_

Patches currently in -mm which might be from lists@nerdbynature.de are

origin.patch
linux-next.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
