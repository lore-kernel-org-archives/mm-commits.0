From: akpm@linux-foundation.org
Subject: + char-mxser_new-ioaddresses-are-ulong.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:51:13 -0800
Message-ID: <200711122151.lACLpDuT010604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43544 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbXKLVvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:51:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: mxser_new, ioaddresses are ulong
has been added to the -mm tree.  Its filename is
     char-mxser_new-ioaddresses-are-ulong.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, ioaddresses are ulong
From: Jiri Slaby <jirislaby@gmail.com>

To not pass ulong address as int parameter, switch it to ulong.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-ioaddresses-are-ulong drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-ioaddresses-are-ulong
+++ a/drivers/char/mxser_new.c
@@ -320,7 +320,7 @@ static struct mxser_mon_ext mon_data_ext
 static int mxser_set_baud_method[MXSER_PORTS + 1];
 
 #ifdef CONFIG_PCI
-static int __devinit CheckIsMoxaMust(int io)
+static int __devinit CheckIsMoxaMust(unsigned long io)
 {
 	u8 oldmcr, hwid;
 	int i;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

fs-sysfs-remove-spin_lock_unlocked.patch
net-sunrpc-remove-spin_lock_unlocked.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
sbus-cpwatchdog-remove-spin_lock_unlocked.patch
watchdog-bfin_wdt-remove-spin_lock_unlocked.patch
git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
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
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
