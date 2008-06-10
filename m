From: akpm@linux-foundation.org
Subject: - kbuild-move-non-__kernel__-checking-headers-to-header-y.patch removed from -mm tree
Date: Tue, 10 Jun 2008 14:28:00 -0700
Message-ID: <200806102128.m5ALS0Ca030272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007AbYFJV2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 17:28:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     kbuild: move non-__KERNEL__-checking headers to header-y
has been removed from the -mm tree.  Its filename was
     kbuild-move-non-__kernel__-checking-headers-to-header-y.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: move non-__KERNEL__-checking headers to header-y
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Move exported header files under include/linux that don't check the
__KERNEL__ preprocessor from unifdef-y to header-y.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/Kbuild~kbuild-move-non-__kernel__-checking-headers-to-header-y include/linux/Kbuild
--- a/include/linux/Kbuild~kbuild-move-non-__kernel__-checking-headers-to-header-y
+++ a/include/linux/Kbuild
@@ -103,6 +103,7 @@ header-y += iso_fs.h
 header-y += ixjuser.h
 header-y += jffs2.h
 header-y += keyctl.h
+header-y += kvm.h
 header-y += limits.h
 header-y += magic.h
 header-y += major.h
@@ -155,11 +156,18 @@ header-y += toshiba.h
 header-y += udf_fs_i.h
 header-y += ultrasound.h
 header-y += un.h
+header-y += unistd.h
 header-y += utime.h
 header-y += veth.h
 header-y += video_decoder.h
 header-y += video_encoder.h
 header-y += videotext.h
+header-y += virtio_blk.h
+header-y += virtio_net.h
+header-y += virtio_9p.h
+header-y += virtio_balloon.h
+header-y += virtio_pci.h
+header-y += wireless.h
 header-y += x25.h
 
 unifdef-y += acct.h
@@ -253,7 +261,6 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
-unifdef-y += kvm.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
@@ -338,24 +345,17 @@ unifdef-y += types.h
 unifdef-y += udp.h
 unifdef-y += uinput.h
 unifdef-y += uio.h
-unifdef-y += unistd.h
 unifdef-y += usbdevice_fs.h
 unifdef-y += utsname.h
 unifdef-y += videodev2.h
 unifdef-y += videodev.h
 unifdef-y += virtio_config.h
-unifdef-y += virtio_blk.h
-unifdef-y += virtio_net.h
-unifdef-y += virtio_9p.h
-unifdef-y += virtio_balloon.h
 unifdef-y += virtio_console.h
-unifdef-y += virtio_pci.h
 unifdef-y += virtio_ring.h
 unifdef-y += vt.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h
 unifdef-y += watchdog.h
-unifdef-y += wireless.h
 unifdef-y += xattr.h
 unifdef-y += xfrm.h
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch
kbuild-move-non-__kernel__-checking-headers-to-header-y.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-include-linux-pm_legacyh.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
spi-kconfig-simplifications.patch

