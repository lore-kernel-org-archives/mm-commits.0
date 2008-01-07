From: akpm@linux-foundation.org
Subject: - a-few-corrections-to-include-linux-kbuild.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:40:08 -0800
Message-ID: <200801072139.m07LdmoL013598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbYAGVmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:42:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dwmw2@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     A few corrections to include/linux/Kbuild
has been removed from the -mm tree.  Its filename was
     a-few-corrections-to-include-linux-kbuild.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: A few corrections to include/linux/Kbuild
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

auxvec.h, i2c-dev.h and vt.h *should* be unifdef'ed i2o-dev.h does not need
unifdef'ing

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/Kbuild~a-few-corrections-to-include-linux-kbuild include/linux/Kbuild
--- a/include/linux/Kbuild~a-few-corrections-to-include-linux-kbuild
+++ a/include/linux/Kbuild
@@ -34,7 +34,6 @@ header-y += atmsap.h
 header-y += atmsvc.h
 header-y += atm_zatm.h
 header-y += auto_fs4.h
-header-y += auxvec.h
 header-y += ax25.h
 header-y += b1lli.h
 header-y += baycom.h
@@ -73,7 +72,7 @@ header-y += gen_stats.h
 header-y += gigaset_dev.h
 header-y += hdsmart.h
 header-y += hysdn_if.h
-header-y += i2c-dev.h
+header-y += i2o-dev.h
 header-y += i8k.h
 header-y += if_arcnet.h
 header-y += if_bonding.h
@@ -157,7 +156,6 @@ header-y += utime.h
 header-y += video_decoder.h
 header-y += video_encoder.h
 header-y += videotext.h
-header-y += vt.h
 header-y += x25.h
 
 unifdef-y += acct.h
@@ -172,6 +170,7 @@ unifdef-y += atm.h
 unifdef-y += atm_tcp.h
 unifdef-y += audit.h
 unifdef-y += auto_fs.h
+unifdef-y += auxvec.h
 unifdef-y += binfmts.h
 unifdef-y += capability.h
 unifdef-y += capi.h
@@ -213,7 +212,7 @@ unifdef-y += hdreg.h
 unifdef-y += hiddev.h
 unifdef-y += hpet.h
 unifdef-y += i2c.h
-unifdef-y += i2o-dev.h
+unifdef-y += i2c-dev.h
 unifdef-y += icmp.h
 unifdef-y += icmpv6.h
 unifdef-y += if_addr.h
@@ -349,6 +348,7 @@ unifdef-y += videodev.h
 unifdef-y += virtio_config.h
 unifdef-y += virtio_blk.h
 unifdef-y += virtio_net.h
+unifdef-y += vt.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h
 unifdef-y += watchdog.h
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

git-arm.patch
git-hwmon.patch
git-kbuild.patch
git-mips.patch
git-netdev-all.patch
git-nfsd.patch
git-xfs.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
ncpfs-update-diagnostic-strings-to-match-routine-names.patch
hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch
synclink-standardize-format-of-linux-header-file-includes-with.patch
remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
