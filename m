From: akpm@linux-foundation.org
Subject: - suspend-maintainers-update.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:36 -0700
Message-ID: <200707192000.l6JK0a0X019466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759295AbXGSU0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Suspend MAINTAINERS update
has been removed from the -mm tree.  Its filename was
     suspend-maintainers-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~suspend-maintainers-update MAINTAINERS
--- a/MAINTAINERS~suspend-maintainers-update
+++ a/MAINTAINERS
@@ -3289,9 +3289,19 @@ M:	neilb@suse.de
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

origin.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
acpi-implement-the-set_target-callback-from-pm_ops.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
