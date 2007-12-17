From: akpm@linux-foundation.org
Subject: - net-ibm_newemac-remove-spin_lock_unlocked.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:39:34 -0800
Message-ID: <200712172339.lBHNdYOt008133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932657AbXLQXwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:52:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, jgarzik@pobox.com, mm-commits@vger.kernel.org


The patch titled
     Net: ibm_newemac, remove SPIN_LOCK_UNLOCKED
has been removed from the -mm tree.  Its filename was
     net-ibm_newemac-remove-spin_lock_unlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Net: ibm_newemac, remove SPIN_LOCK_UNLOCKED
From: Jiri Slaby <jirislaby@gmail.com>

SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ibm_newemac/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/ibm_newemac/debug.c~net-ibm_newemac-remove-spin_lock_unlocked drivers/net/ibm_newemac/debug.c
--- a/drivers/net/ibm_newemac/debug.c~net-ibm_newemac-remove-spin_lock_unlocked
+++ a/drivers/net/ibm_newemac/debug.c
@@ -21,7 +21,7 @@
 
 #include "core.h"
 
-static spinlock_t emac_dbg_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(emac_dbg_lock);
 
 static void emac_desc_dump(struct emac_instance *p)
 {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
git-netdev-all.patch
git-watchdog.patch
git-wireless.patch
drm-i915-fix-oops-after-killing-x.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
maintainers-order-auerswald-alphabetically.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
moxa-first-pass-at-termios-reporting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
