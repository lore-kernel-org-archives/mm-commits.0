From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-bluetooth-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:54:53 -0800
Message-ID: <200612080854.kB88srVO014080@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37492 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425231AbWLHIy4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:54:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty-switch-to-ktermios-bluetooth-fix
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-bluetooth-fix.patch

This patch was dropped because it was folded into tty-switch-to-ktermios.patch

------------------------------------------------------
Subject: tty-switch-to-ktermios-bluetooth-fix
From: Andrew Morton <akpm@osdl.org>

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/bluetooth/rfcomm/tty.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/bluetooth/rfcomm/tty.c~tty-switch-to-ktermios-bluetooth-fix net/bluetooth/rfcomm/tty.c
--- a/net/bluetooth/rfcomm/tty.c~tty-switch-to-ktermios-bluetooth-fix
+++ a/net/bluetooth/rfcomm/tty.c
@@ -752,9 +752,9 @@ static int rfcomm_tty_ioctl(struct tty_s
 	return -ENOIOCTLCMD;
 }
 
-static void rfcomm_tty_set_termios(struct tty_struct *tty, struct termios *old)
+static void rfcomm_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
-	struct termios *new = (struct termios *) tty->termios;
+	struct ktermios *new = tty->termios;
 	int old_baud_rate = tty_termios_baud_rate(old);
 	int new_baud_rate = tty_termios_baud_rate(new);
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

