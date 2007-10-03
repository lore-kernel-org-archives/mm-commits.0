From: akpm@linux-foundation.org
Subject: + add-missing-entries-to-top-level-documentation-00-index.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:16:51 -0700
Message-ID: <200710032116.l93LGpsp009082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbXJCVRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net


The patch titled
     Add missing entries to top level Documentation/00-INDEX
has been added to the -mm tree.  Its filename is
     add-missing-entries-to-top-level-documentation-00-index.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add missing entries to top level Documentation/00-INDEX
From: Rob Landley <rob@landley.net>

Add missing entries to Documentation/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/00-INDEX~add-missing-entries-to-top-level-documentation-00-index Documentation/00-INDEX
--- a/Documentation/00-INDEX~add-missing-entries-to-top-level-documentation-00-index
+++ a/Documentation/00-INDEX
@@ -22,6 +22,8 @@ CodingStyle
 	- how the boss likes the C code in the kernel to look.
 DMA-API.txt
 	- DMA API, pci_ API & extensions for non-consistent memory machines.
+DMA-ISA-LPC.txt
+	- How to do DMA with ISA (and LPC) devices.
 DMA-mapping.txt
 	- info for PCI drivers using DMA portably across all platforms.
 DocBook/
@@ -50,6 +52,8 @@ README.cycladesZ
 	- info on Cyclades-Z firmware loading.
 SAK.txt
 	- info on Secure Attention Keys.
+SM501.txt
+	- Silicon Motion SM501 multimedia companion chip
 SecurityBugs
 	- procedure for reporting security bugs found in the kernel.
 SubmitChecklist
@@ -246,6 +250,8 @@ md.txt
 	- info on boot arguments for the multiple devices driver.
 memory-barriers.txt
 	- info on Linux kernel memory barriers.
+memory-hotplug.txt
+	- Hotpluggable memory support, how to use and current status.
 memory.txt
 	- info on typical Linux memory problems.
 mips/
@@ -296,6 +302,8 @@ pm.txt
 	- info on Linux power management support.
 pnp.txt
 	- Linux Plug and Play documentation.
+power_supply_class.txt
+	- Tells userspace about battery, UPS, AC or DC power supply properties
 power/
 	- directory with info on Linux PCI power management.
 powerpc/
@@ -332,8 +340,12 @@ sched-coding.txt
 	- reference for various scheduler-related methods in the O(1) scheduler.
 sched-design.txt
 	- goals, design and implementation of the Linux O(1) scheduler.
+sched-design-CFS.txt
+	- goals, design and implementation of the Complete Fair Scheduler.
 sched-domains.txt
 	- information on scheduling domains.
+sched-nice-design.txt
+	- How and why the scheduler's nice levels are implemented.
 sched-stats.txt
 	- information on schedstats (Linux Scheduler Statistics).
 scsi/
@@ -378,6 +390,8 @@ stallion.txt
 	- info on using the Stallion multiport serial driver.
 svga.txt
 	- short guide on selecting video modes at boot via VGA BIOS.
+sysfs-rules.txt
+	- How not to use sysfs.
 sx.txt
 	- info on the Specialix SX/SI multiport serial driver.
 sysctl/
@@ -408,6 +422,8 @@ video4linux/
 	- directory with info regarding video/TV/radio cards and linux.
 vm/
 	- directory with info on the Linux vm code.
+volatile-considered-harmful.txt
+	- Why the "volatile" type class should not be used
 voyager.txt
 	- guide to running Linux on the Voyager architecture.
 w1/
_

Patches currently in -mm which might be from rob@landley.net are

docs-ramdisk-initrd-initramfs-corrections.patch
documentation-make-headers_installtxt.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
tweak-documentation-sm501txt.patch
add-missing-entries-to-top-level-documentation-00-index.patch
