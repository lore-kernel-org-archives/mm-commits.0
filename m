From: akpm@linux-foundation.org
Subject: + rtc-cumulative-style-fixes-fix.patch added to -mm tree
Date: Mon, 12 Jan 2009 19:15:39 -0800
Message-ID: <200901130315.n0D3FdSW015473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757634AbZAMDRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 22:17:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, andrew@sanpeople.com, ben@simtec.co.uk, dbrownell@users.sourceforge.net, dsaxena@plexity.net, gl@dsa-ac.de, iwamatsu@nigauri.org, kyle@mcmartin.ca, lethal@linux-sh.org, pmironchik@optifacio.net, raph@raphnet.net, rongkai.zhan@windriver.com, rpurdie@rpsys.net, scottwood@freescale.com, yoichi_yuasa@tripeaks.co.jp


The patch titled
     rtc-cumulative-style-fixes-fix
has been added to the -mm tree.  Its filename is
     rtc-cumulative-style-fixes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cumulative-style-fixes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Victor <andrew@sanpeople.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Deepak Saxena <dsaxena@plexity.net>
Cc: G. Liakhovetski <gl@dsa-ac.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Mark Zhan <rongkai.zhan@windriver.com>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Pavel Mironchik <pmironchik@optifacio.net>
Cc: Raphael Assenat <raph@raphnet.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1302.c |    2 ++
 drivers/rtc/rtc-parisc.c |    2 ++
 drivers/rtc/rtc-sh.c     |    2 ++
 3 files changed, 6 insertions(+)

diff -puN drivers/rtc/rtc-ds1302.c~rtc-cumulative-style-fixes-fix drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-cumulative-style-fixes-fix
+++ a/drivers/rtc/rtc-ds1302.c
@@ -18,6 +18,8 @@
 #include <linux/io.h>
 #include <linux/bcd.h>
 
+#include <asm/rtc.h>
+
 #define DRV_NAME	"rtc-ds1302"
 #define DRV_VERSION	"0.1.0"
 
diff -puN drivers/rtc/rtc-parisc.c~rtc-cumulative-style-fixes-fix drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-cumulative-style-fixes-fix
+++ a/drivers/rtc/rtc-parisc.c
@@ -9,6 +9,8 @@
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 
+#include <asm/rtc.h>
+
 /* as simple as can be, and no simpler. */
 struct parisc_rtc {
 	struct rtc_device *rtc;
diff -puN drivers/rtc/rtc-sh.c~rtc-cumulative-style-fixes-fix drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-cumulative-style-fixes-fix
+++ a/drivers/rtc/rtc-sh.c
@@ -26,6 +26,8 @@
 #include <linux/io.h>
 #include <linux/log2.h>
 
+#include <asm/rtc.h>
+
 #define DRV_NAME	"sh-rtc"
 #define DRV_VERSION	"0.2.0"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
rtc-cumulative-style-fixes-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

