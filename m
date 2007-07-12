From: akpm@linux-foundation.org
Subject: + suspend-maintainers-update.patch added to -mm tree
Date: Thu, 12 Jul 2007 14:14:57 -0700
Message-ID: <200707122114.l6CLEvY1003595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964855AbXGLVPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 17:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, pavel@suse.cz, rjw@sisk.pl


The patch titled
     Suspend MAINTAINERS update
has been added to the -mm tree.  Its filename is
     suspend-maintainers-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Suspend MAINTAINERS update
From: Pavel Machek <pavel@ucw.cz>

I guess it is time to clarify that suspend and hibernation are separate
things, and add Rafael as a maintainer.  Plus, people blame us for suspend
problems, anyway, I guess it is fair to mark us as suspend maintainers,
too.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~suspend-maintainers-update MAINTAINERS
--- a/MAINTAINERS~suspend-maintainers-update
+++ a/MAINTAINERS
@@ -3357,9 +3357,19 @@ M:	neilb@suse.de
 L:	linux-raid@vger.kernel.org
 S:	Supported
 
-SOFTWARE SUSPEND:
+HIBERNATION (aka Software Suspend, aka swsusp):
 P:	Pavel Machek
 M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
+
+SUSPEND TO RAM:
+P:	Pavel Machek
+M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Maintained
 
_

Patches currently in -mm which might be from pavel@ucw.cz are

working-3d-dri-intel-agpko-resume-for-i815-chip.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch
pm-remove-deprecated-sysfs-files.patch
pm-remove-deprecated-dpm_runtime_-routines.patch
suspend-maintainers-update.patch
