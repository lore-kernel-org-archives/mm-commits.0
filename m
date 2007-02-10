From: akpm@linux-foundation.org
Subject: + git-mips-fixup.patch added to -mm tree
Date: Fri, 09 Feb 2007 20:55:38 -0800
Message-ID: <200702100455.l1A4tcvh004038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbXBJEzm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 23:55:42 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1A4tcUI029348
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 9 Feb 2007 20:55:39 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-mips-fixup
has been added to the -mm tree.  Its filename is
     git-mips-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-mips-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff -puN arch/mips/Kconfig~git-mips-fixup arch/mips/Kconfig
--- a/arch/mips/Kconfig~git-mips-fixup
+++ a/arch/mips/Kconfig
@@ -2075,43 +2075,11 @@ config BINFMT_ELF32
 	bool
 	default y if MIPS32_O32 || MIPS32_N32
 
-<<<<<<< HEAD/arch/mips/Kconfig
 endmenu
 
 menu "Power management options"
 
 source "kernel/power/Kconfig"
-=======
-config PM
-	bool "Power Management support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SOC_AU1X00
-
-config APM
-        tristate "Advanced Power Management Emulation"
-	depends on PM
-        ---help---
-	  APM is a BIOS specification for saving power using several different
-	  techniques. This is mostly useful for battery powered systems with
-	  APM compliant BIOSes. If you say Y here, the system time will be
-	  reset after a RESUME operation, the /proc/apm device will provide
-	  battery status information, and user-space programs will receive
-	  notification of APM "events" (e.g. battery status change).
-
-	  In order to use APM, you will need supporting software. For location
-	  and more information, read <file:Documentation/pm.txt> and the
-	  Battery Powered Linux mini-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  This driver does not spin down disk drives (see the hdparm(8)
-	  manpage ("man 8 hdparm") for that), and it doesn't turn off
-	  VESA-compliant "green" monitors.
-
-	  Generally, if you don't have a battery in your machine, there isn't
-	  much point in using this driver and you should say N. If you get
-	  random kernel OOPSes or reboots that don't seem to be related to
-	  anything, try disabling/enabling this option (or disabling/enabling
-	  APM in your BIOS).
->>>>>>> /arch/mips/Kconfig
 
 endmenu
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-input.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
