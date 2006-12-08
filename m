From: akpm@osdl.org
Subject: - tty-preparatory-structures-for-termios-revamp-strip-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:53:44 -0800
Message-ID: <200612080853.kB88riAv014043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37391 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425215AbWLHIxz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:53:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty-preparatory-structures-for-termios-revamp strip fix
has been removed from the -mm tree.  Its filename was
     tty-preparatory-structures-for-termios-revamp-strip-fix.patch

This patch was dropped because it was folded into tty-preparatory-structures-for-termios-revamp.patch

------------------------------------------------------
Subject: tty-preparatory-structures-for-termios-revamp strip fix
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Doh missed that one

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wireless/strip.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/strip.c~tty-preparatory-structures-for-termios-revamp-strip-fix drivers/net/wireless/strip.c
--- a/drivers/net/wireless/strip.c~tty-preparatory-structures-for-termios-revamp-strip-fix
+++ a/drivers/net/wireless/strip.c
@@ -798,7 +798,7 @@ static unsigned int get_baud(struct tty_
  */
 static void set_baud(struct tty_struct *tty, unsigned int baudcode)
 {
-	struct termios old_termios = *(tty->termios);
+	struct ktermios old_termios = *(tty->termios);
 	tty->termios->c_cflag &= ~CBAUD;	/* Clear the old baud setting */
 	tty->termios->c_cflag |= baudcode;	/* Set the new baud setting */
 	tty->driver->set_termios(tty, &old_termios);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
do_task_stat-dont-take-tty_mutex.patch
mxser-correct-tty-driver-name.patch
pci-mxser-pci-refcounts.patch
mxser-make-an-experimental-clone.patch
char-mxser_new-correct-include-file.patch
char-mxser_new-upgrade-to-191.patch
char-mxser_new-rework-to-allow-dynamic-structs.patch
char-mxser_new-eliminate-tty-ldisc-deref.patch
char-mxser_new-testbit-for-bit-testing.patch
char-mxser_new-correct-fail-paths.patch
char-mxser_new-dont-check-tty_unregister-retval.patch
char-mxser_new-compress-isa-finding.patch
char-mxser_new-register-tty-devices-on-the-fly.patch
char-mxser_new-compact-structures-round2.patch
char-mxser_new-reverse-if-else-paths-patch.patch
char-mxser_new-comments-cleanup.patch
char-mxser_new-correct-intr-handler-proto.patch
char-mxser_new-delete-ttys-and-termios.patch
char-mxser_new-pci-probing.patch
mxser_new-correct-tty-driver-name.patch
char-stallion-use-pr_debug-macro.patch
char-stallion-remove-unneeded-casts.patch
char-stallion-kill-typedefs.patch
char-stallion-move-init-deinit.patch
char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
char-stallion-remove-many-prototypes.patch
tty-preparatory-structures-for-termios-revamp.patch
tty-preparatory-structures-for-termios-revamp-strip-fix.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty-switch-to-ktermios-3270-fix.patch
tty-switch-to-ktermios-uml-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-update.patch
termios-enable-new-style-termios-ioctls-on-x86-64.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch
ide-more-conversion-to-pci_get-apis.patch
pdc202xx_new-fix-pio-mode-setup.patch
sl82c105-straighten-up-ide-control-status-register-caching.patch
igafb-switch-to-pci_get-api.patch

