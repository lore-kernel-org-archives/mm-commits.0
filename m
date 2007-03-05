From: akpm@linux-foundation.org
Subject: - parport-is-an-orphan.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:54:38 -0800
Message-ID: <200703052354.l25NscYJ005107@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbXCEXzD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:55:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     parport is an orphan
has been removed from the -mm tree.  Its filename was
     parport-is-an-orphan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: parport is an orphan
From: David Brownell <david-b@pacbell.net>

The writing on the wall seem to be that the parport stack is orphaned,
rather than maintained by four folk ...  and having a webpage that says the
latest patches are based on a 2.5 kernel.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN MAINTAINERS~parport-is-an-orphan MAINTAINERS
--- a/MAINTAINERS~parport-is-an-orphan
+++ a/MAINTAINERS
@@ -2553,16 +2553,8 @@ L:	i2c@lm-sensors.org
 S:	Maintained
 
 PARALLEL PORT SUPPORT
-P:	Phil Blundell
-M:	philb@gnu.org
-P:	Tim Waugh
-M:	tim@cyberelk.net
-P:	David Campbell
-P:	Andrea Arcangeli
-M:	andrea@suse.de
 L:	linux-parport@lists.infradead.org
-W:	http://people.redhat.com/twaugh/parport/
-S:	Maintained
+S:	Orphan
 
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
 P:	Tim Waugh
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-avr32.patch
git-input.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
