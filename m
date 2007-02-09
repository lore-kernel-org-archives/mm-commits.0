From: akpm@linux-foundation.org
Subject: - char-timers-cleanup-fix.patch removed from -mm tree
Date: Fri, 09 Feb 2007 02:54:51 -0800
Message-ID: <200702091054.l19AspF3011187@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43080 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946287AbXBIKy6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 05:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     char-timers-cleanup-fix
has been removed from the -mm tree.  Its filename was
     char-timers-cleanup-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: char-timers-cleanup-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/i2lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ip2/i2lib.c~char-timers-cleanup-fix drivers/char/ip2/i2lib.c
--- a/drivers/char/ip2/i2lib.c~char-timers-cleanup-fix
+++ a/drivers/char/ip2/i2lib.c
@@ -80,7 +80,7 @@ static int i2RetryFlushOutput(i2ChanStrP
 // Not a documented part of the library routines (careful...) but the Diagnostic
 // i2diag.c finds them useful to help the throughput in certain limited
 // single-threaded operations.
-static inline void iiSendPendingMail(i2eBordStrPtr);
+static void iiSendPendingMail(i2eBordStrPtr);
 static void serviceOutgoingFifo(i2eBordStrPtr);
 
 // Functions defined in ip2.c as part of interrupt handling
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-bay-driver-warning-fix.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-infiniband.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-backlight-acpi-fix.patch
git-backlight-asus-fix.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
char-timers-cleanup-fix.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
