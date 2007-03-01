From: akpm@linux-foundation.org
Subject: - git-wireless-fix.patch removed from -mm tree
Date: Wed, 28 Feb 2007 21:31:23 -0800
Message-ID: <200703010531.l215VN5a005612@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56411 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650AbXCAFb7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 00:31:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linville@tuxdriver.com, yi.zhu@intel.com, mm-commits@vger.kernel.org


The patch titled
     git-wireless-fix
has been removed from the -mm tree.  Its filename was
     git-wireless-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-wireless-fix
From: Andrew Morton <akpm@linux-foundation.org>

testing much?

Cc: Zhu Yi <yi.zhu@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/ipw2200.c~git-wireless-fix drivers/net/wireless/ipw2200.c
--- a/drivers/net/wireless/ipw2200.c~git-wireless-fix
+++ a/drivers/net/wireless/ipw2200.c
@@ -1852,7 +1852,7 @@ static ssize_t show_channels(struct devi
 			     char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
-	const struct ieee80211_geo *geo = ipw_get_geo(priv->ieee);
+	const struct ieee80211_geo *geo = ieee80211_get_geo(priv->ieee);
 	int len = 0, i;
 
 	len = sprintf(&buf[len],
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-hid-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-vs-md.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fix.patch
after-before-x86_64-mm-mmconfig-share.patch
log-reason-why-tsc-was-marked-unstable-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
