From: akpm@linux-foundation.org
Subject: + doc-kernel-parameterstxt-fix-stale-references.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:03:18 -0700
Message-ID: <200806302303.m5UN3IPR030139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762884AbYF3XDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, randy.dunlap@oracle.com


The patch titled
     Doc*/kernel-parameters.txt: fix stale references
has been added to the -mm tree.  Its filename is
     doc-kernel-parameterstxt-fix-stale-references.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Doc*/kernel-parameters.txt: fix stale references
From: Pavel Machek <pavel@suse.cz>

Fix stale references to source files in kernel-parameters.txt.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~doc-kernel-parameterstxt-fix-stale-references Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-kernel-parameterstxt-fix-stale-references
+++ a/Documentation/kernel-parameters.txt
@@ -295,7 +295,7 @@ and is between 256 and 4096 characters. 
 			when initialising the APIC and IO-APIC components.
 
 	apm=		[APM] Advanced Power Management
-			See header of arch/i386/kernel/apm.c.
+			See header of arch/x86/kernel/apm_32.c.
 
 	arcrimi=	[HW,NET] ARCnet - "RIM I" (entirely mem-mapped) cards
 			Format: <io>,<irq>,<nodeID>
@@ -638,7 +638,7 @@ and is between 256 and 4096 characters. 
 
 	elanfreq=	[X86-32]
 			See comment before function elanfreq_setup() in
-			arch/i386/kernel/cpu/cpufreq/elanfreq.c.
+			arch/x86/kernel/cpu/cpufreq/elanfreq.c.
 
 	elevator=	[IOSCHED]
 			Format: {"anticipatory" | "cfq" | "deadline" | "noop"}
_

Patches currently in -mm which might be from pavel@suse.cz are

rtc-fix-cmos-time-error-after-writing-proc-acpi-alarm.patch
doc-kernel-parameterstxt-fix-stale-references.patch
x86-acpi-normalize-segment-descriptor-register-on-resume.patch
pm-remove-references-to-struct-pm_dev-from-irda-headers.patch
sync_file_range_write-may-and-will-block-document-that.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
remove-include-linux-pm_legacyh.patch
pm-remove-definition-of-struct-pm_dev.patch
pm-remove-remaining-obsolete-definitions-from-pmh.patch
pm-drop-unnecessary-includes-from-pmh.patch

