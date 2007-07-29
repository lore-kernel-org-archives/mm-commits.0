From: akpm@linux-foundation.org
Subject: - agp-document-boot-options.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:07 -0700
Message-ID: <200707290613.l6T6D7mk011175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41218 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757410AbXG2GXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cebbert@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AGP: document boot options
has been removed from the -mm tree.  Its filename was
     agp-document-boot-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AGP: document boot options
From: Chuck Ebbert <cebbert@redhat.com>

Add documentation for AGP boot options.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/kernel-parameters.txt~agp-document-boot-options Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~agp-document-boot-options
+++ a/Documentation/kernel-parameters.txt
@@ -30,6 +30,7 @@ the beginning of each description states
 parameter is applicable:
 
 	ACPI	ACPI support is enabled.
+	AGP	AGP (Accelerated Graphics Port) is enabled.
 	ALSA	ALSA sound support is enabled.
 	APIC	APIC support is enabled.
 	APM	Advanced Power Management support is enabled.
@@ -227,6 +228,12 @@ and is between 256 and 4096 characters. 
 			to assume that this machine's pmtimer latches its value
 			and always returns good values.
 
+	agp=		[AGP]
+			{ off | try_unsupported }
+			off: disable AGP support
+			try_unsupported: try to drive unsupported chipsets
+				(may crash computer or cause data corruption)
+
 	enable_timer_pin_1 [i386,x86-64]
 			Enable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs
_

Patches currently in -mm which might be from cebbert@redhat.com are

origin.patch
