From: akpm@linux-foundation.org
Subject: - add-documentation-power-00-index.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:46 -0700
Message-ID: <200710180704.l9I74k7D031588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762225AbXJRHPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Add Documentation/power/00-INDEX
has been removed from the -mm tree.  Its filename was
     add-documentation-power-00-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add Documentation/power/00-INDEX
From: Rob Landley <rob@landley.net>

Add Documentation/power/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/00-INDEX |   34 +++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

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

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
