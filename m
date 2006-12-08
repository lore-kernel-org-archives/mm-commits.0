From: akpm@osdl.org
Subject: - linux-fbdev-devel-is-subscribers-only.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:59 -0800
Message-ID: <200612082014.kB8KExeK003234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59972 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947096AbWLHUPX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     linux-fbdev-devel is subscribers-only
has been removed from the -mm tree.  Its filename was
     linux-fbdev-devel-is-subscribers-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: linux-fbdev-devel is subscribers-only
From: Randy Dunlap <randy.dunlap@oracle.com>

Update linux-fbdev mailing list to subscribers-only.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN MAINTAINERS~linux-fbdev-devel-is-subscribers-only MAINTAINERS
--- a/MAINTAINERS~linux-fbdev-devel-is-subscribers-only
+++ a/MAINTAINERS
@@ -684,7 +684,7 @@ S:	Supported
 CIRRUS LOGIC GENERIC FBDEV DRIVER
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Odd Fixes
 
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
@@ -791,7 +791,7 @@ S:	Maintained
 CYBLAFB FRAMEBUFFER DRIVER
 P:	Knut Petersen
 M:	Knut_Petersen@t-online.de
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 CYCLADES 2X SYNC CARD DRIVER
@@ -1128,7 +1128,7 @@ S:	Supported
 FRAMEBUFFER LAYER
 P:	Antonino Daplas
 M:	adaplas@pol.net
-L:	linux-fbdev-devel@lists.sourceforge.net	
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 W:	http://linux-fbdev.sourceforge.net/
 S:	Maintained
 
@@ -1479,7 +1479,7 @@ S:	Maintained
 IMS TWINTURBO FRAMEBUFFER DRIVER
 P:	Paul Mundt
 M:	lethal@chaoticdreams.org
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 INFINIBAND SUBSYSTEM
@@ -1512,13 +1512,13 @@ S:	Maintained
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 P:	Sylvain Meyer
 M:	sylvain.meyer@worldonline.fr
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 INTEL 810/815 FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@pol.net
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 INTEL APIC/IOAPIC, LOWLEVEL X86 SMP SUPPORT
@@ -1964,7 +1964,7 @@ S:	Odd Fixes for 2.4; Maintained for 2.6
 MATROX FRAMEBUFFER DRIVER
 P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 MEGARAID SCSI DRIVERS
@@ -2222,7 +2222,7 @@ S:	Maintained
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@pol.net
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 OPENCORES I2C BUS DRIVER
@@ -2506,13 +2506,13 @@ S:	Maintained
 RADEON FRAMEBUFFER DISPLAY DRIVER
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 P:	Paul Mackerras
 M:	paulus@samba.org
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
@@ -2582,7 +2582,7 @@ S:	Orphan
 S3 SAVAGE FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@pol.net
-L:	linux-fbdev-devel@lists.sourceforge.net
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 S390
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-fbdev-devel-is-subscribers-only.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

