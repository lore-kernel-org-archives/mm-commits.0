From: akpm@linux-foundation.org
Subject: - kbuild-move-files-that-dont-check-__kernel__.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:50 -0700
Message-ID: <200804300540.m3U5eoKM029002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759427AbYD3GM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dwmw2@infradead.org, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: move files that don't check __KERNEL__
has been removed from the -mm tree.  Its filename was
     kbuild-move-files-that-dont-check-__kernel__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: move files that don't check __KERNEL__
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Move files that don't check __KERNEL__ from unifdef-y to header-y.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/Kbuild~kbuild-move-files-that-dont-check-__kernel__ include/linux/Kbuild
--- a/include/linux/Kbuild~kbuild-move-files-that-dont-check-__kernel__
+++ a/include/linux/Kbuild
@@ -20,6 +20,7 @@ header-y += affs_hardblocks.h
 header-y += aio_abi.h
 header-y += arcfb.h
 header-y += atmapi.h
+header-y += atmarp.h
 header-y += atmbr2684.h
 header-y += atmclip.h
 header-y += atm_eni.h
@@ -48,6 +49,7 @@ header-y += coff.h
 header-y += comstats.h
 header-y += const.h
 header-y += cgroupstats.h
+header-y += cramfs_fs.h
 header-y += cycx_cfm.h
 header-y += dlmconstants.h
 header-y += dlm_device.h
@@ -70,10 +72,12 @@ header-y += firewire-constants.h
 header-y += fuse.h
 header-y += genetlink.h
 header-y += gen_stats.h
+header-y += gfs2_ondisk.h
 header-y += gigaset_dev.h
 header-y += hysdn_if.h
 header-y += i2o-dev.h
 header-y += i8k.h
+header-y += if_addrlabel.h
 header-y += if_arcnet.h
 header-y += if_bonding.h
 header-y += if_cablemodem.h
@@ -91,6 +95,7 @@ header-y += if_tunnel.h
 header-y += in6.h
 header-y += in_route.h
 header-y += ioctl.h
+header-y += ip6_tunnel.h
 header-y += ipmi_msgdefs.h
 header-y += ipsec.h
 header-y += ipx.h
@@ -165,7 +170,6 @@ unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
 unifdef-y += apm_bios.h
 unifdef-y += atalk.h
-unifdef-y += atmarp.h
 unifdef-y += atmdev.h
 unifdef-y += atm.h
 unifdef-y += atm_tcp.h
@@ -181,7 +185,6 @@ unifdef-y += cm4000_cs.h
 unifdef-y += cn_proc.h
 unifdef-y += coda.h
 unifdef-y += connector.h
-unifdef-y += cramfs_fs.h
 unifdef-y += cuda.h
 unifdef-y += cyclades.h
 unifdef-y += dccp.h
@@ -204,7 +207,6 @@ unifdef-y += futex.h
 unifdef-y += fs.h
 unifdef-y += gameport.h
 unifdef-y += generic_serial.h
-unifdef-y += gfs2_ondisk.h
 unifdef-y += hayesesp.h
 unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
@@ -218,7 +220,6 @@ unifdef-y += i2c-dev.h
 unifdef-y += icmp.h
 unifdef-y += icmpv6.h
 unifdef-y += if_addr.h
-unifdef-y += if_addrlabel.h
 unifdef-y += if_arp.h
 unifdef-y += if_bridge.h
 unifdef-y += if_ec.h
@@ -242,7 +243,6 @@ unifdef-y += ipc.h
 unifdef-y += ipmi.h
 unifdef-y += ipv6.h
 unifdef-y += ipv6_route.h
-unifdef-y += ip6_tunnel.h
 unifdef-y += isdn.h
 unifdef-y += isdnif.h
 unifdef-y += isdn_divertif.h
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

