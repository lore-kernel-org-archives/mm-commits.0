From: akpm@linux-foundation.org
Subject: + char-mxser-schedule-for-removal.patch added to -mm tree
Date: Tue, 01 May 2007 15:36:35 -0700
Message-ID: <200705012236.l41MaZeB008292@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721AbXEAWgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 18:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser, schedule for removal
has been added to the -mm tree.  Its filename is
     char-mxser-schedule-for-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser, schedule for removal
From: Jiri Slaby <jirislaby@gmail.com>

mxser, schedule for removal

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~char-mxser-schedule-for-removal Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~char-mxser-schedule-for-removal
+++ a/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,14 @@ be removed from this file.
 
 ---------------------------
 
+What:	MXSER
+When:	December 2007
+Why:	Old mxser driver is obsoleted by the mxser_new. Give it some time yet
+	and remove it.
+Who:	Jiri Slaby <jirislaby@gmail.com>
+
+---------------------------
+
 What:	V4L2 VIDIOC_G_MPEGCOMP and VIDIOC_S_MPEGCOMP
 When:	October 2007
 Why:	Broken attempt to set MPEG compression parameters. These ioctls are
_

Patches currently in -mm which might be from jirislaby@gmail.com are

input-ff-add-ff_raw-effect.patch
input-phantom-add-a-new-driver.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
serial-serial_core-use-pr_debug.patch
shrink_slab-handle-bad-shrinkers.patch
