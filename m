From: akpm@linux-foundation.org
Subject: + add-documentation-power-00-index.patch added to -mm tree
Date: Thu, 04 Oct 2007 13:30:31 -0700
Message-ID: <200710042030.l94KUVHr027288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755713AbXJDUao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 16:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net


The patch titled
     Add Documentation/power/00-INDEX
has been added to the -mm tree.  Its filename is
     add-documentation-power-00-index.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add Documentation/power/00-INDEX
From: Rob Landley <rob@landley.net>

Add Documentation/power/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN /dev/null Documentation/power/00-INDEX
--- /dev/null
+++ a/Documentation/power/00-INDEX
@@ -0,0 +1,34 @@
+00-INDEX
+	- This file
+basic-pm-debugging.txt
+	- Debugging suspend and resume
+devices.txt
+	- How drivers interact with system-wide power management
+drivers-testing.txt
+	- Testing suspend and resume support in device drivers
+freezing-of-tasks.txt
+	- How processes and controlled during suspend
+interface.txt
+	- Power management user interface in /sys/power
+notifiers.txt
+	- Registering suspend notifiers in device drivers
+pci.txt
+	- How the PCI Subsystem Does Power Management
+s2ram.txt
+	- How to get suspend to ram working (and debug it when it isn't)
+states.txt
+	- System power management states
+swsusp-and-swap-files.txt
+	- Using swap files with software suspend (to disk)
+swsusp-dmcrypt.txt
+	- How to use dm-crypt and software suspend (to disk) together
+swsusp.txt
+	- Goals, implementation, and usage of software suspend (ACPI S3)
+tricks.txt
+	- How to trick software suspend (to disk) into working when it isn't
+userland-swsusp.txt
+	- Experimental implementation of software suspend in userspace
+video_extension.txt
+	- ACPI video extensions
+video.txt
+	- Video issues during resume from suspend
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
add-documentation-w1w1-masters-00-index.patch
add-missing-entries-to-documentation-arm-00-index.patch
update-documentation-scsi-00-index.patch
add-entries-to-documentation-powerpc.patch
add-documentation-power-00-index.patch
