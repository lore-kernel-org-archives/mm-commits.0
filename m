From: akpm@linux-foundation.org
Subject: - synclink_gt-add-compat_ioctl-fix.patch removed from -mm tree
Date: Thu, 10 May 2007 21:48:13 -0700
Message-ID: <200705110448.l4B4mDKR006345@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXEKEsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 00:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     synclink_gt-add-compat_ioctl-fix
has been removed from the -mm tree.  Its filename was
     synclink_gt-add-compat_ioctl-fix.patch

This patch was dropped because it was folded into synclink_gt-add-compat_ioctl.patch

------------------------------------------------------
Subject: synclink_gt-add-compat_ioctl-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/synclink.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/synclink.h~synclink_gt-add-compat_ioctl-fix include/linux/synclink.h
--- a/include/linux/synclink.h~synclink_gt-add-compat_ioctl-fix
+++ a/include/linux/synclink.h
@@ -295,8 +295,7 @@ struct gpio_desc {
 /* provide 32 bit ioctl compatibility on 64 bit systems */
 #ifdef CONFIG_COMPAT
 #include <linux/compat.h>
-struct MGSL_PARAMS32
-{
+struct MGSL_PARAMS32 {
 	compat_ulong_t	mode;
 	unsigned char	loopback;
 	unsigned short	flags;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-hexdump.patch
synclink_gt-add-compat_ioctl.patch
synclink_gt-add-compat_ioctl-fix.patch
stop_machine-now-uses-hard_irq_disable-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
submitchecklist-add-W-help.patch
ntfs-use-zero_user_page.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
use-defines-in-sys_getpriority-sys_setpriority-fix.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
pm3fb-preliminary-24-to-26-port-fix.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
