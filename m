From: akpm@linux-foundation.org
Subject: + git-leds-fixup.patch added to -mm tree
Date: Wed, 28 Feb 2007 15:26:43 -0800
Message-ID: <200702282326.l1SNQh4F030302@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbXB1X0p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:26:45 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1SNQhhB032615
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2007 15:26:44 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-leds-fixup
has been added to the -mm tree.  Its filename is
     git-leds-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-leds-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig  |   15 ---------------
 drivers/leds/Makefile |    5 -----
 2 files changed, 20 deletions(-)

diff -puN drivers/leds/Kconfig~git-leds-fixup drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~git-leds-fixup
+++ a/drivers/leds/Kconfig
@@ -82,20 +82,6 @@ config LEDS_WRAP
 	help
 	  This option enables support for the PCEngines WRAP programmable LEDs.
 
-<<<<<<< HEAD/drivers/leds/Kconfig
-config LEDS_H1940
-	tristate "LED Support for iPAQ H1940 device"
-	depends LEDS_CLASS && ARCH_H1940
-	help
-	  This option enables support for the LEDs on the h1940.
-
-config LEDS_COBALT
-	tristate "LED Support for Cobalt Server front LED"
-	depends on LEDS_CLASS && MIPS_COBALT
-	help
-	  This option enables support for the front LED on Cobalt Server
-
-=======
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
 	depends LEDS_CLASS && ARCH_H1940
@@ -116,7 +102,6 @@ config LEDS_GPIO
 	  outputs. To be useful the particular board must have LEDs 
 	  and they must be connected to the GPIO lines. 
 
->>>>>>> /drivers/leds/Kconfig
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff -puN drivers/leds/Makefile~git-leds-fixup drivers/leds/Makefile
--- a/drivers/leds/Makefile~git-leds-fixup
+++ a/drivers/leds/Makefile
@@ -14,14 +14,9 @@ obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c2
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
-<<<<<<< HEAD/drivers/leds/Makefile
-obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
-obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
-=======
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
->>>>>>> /drivers/leds/Makefile
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
acpi-driver-support-for-pata-fix.patch
git-md-accel-vs-md.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc-fixup.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
