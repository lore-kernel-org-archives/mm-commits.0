From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 27 Jan 2009 11:13:55 -0800
Message-ID: <200901271913.n0RJDt78011526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbZA0TN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 14:13:59 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0RJDtex010190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2009 11:13:56 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                         |    3 ---
 arch/arm/configs/magician_defconfig |    3 ---
 fs/Kconfig                          |   16 ----------------
 include/linux/debugfs.h             |    6 ------
 4 files changed, 28 deletions(-)

diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -2102,10 +2102,7 @@ M:	khali@linux-fr.org
 P:	Ben Dooks (embedded platforms)
 M:	ben-linux@fluff.org
 L:	linux-i2c@vger.kernel.org
-<<<<<<< HEAD:MAINTAINERS
 W:	http://i2c.wiki.kernel.org/
-=======
->>>>>>> FETCH_HEAD:MAINTAINERS
 T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
 S:	Maintained
 
diff -puN arch/arm/configs/magician_defconfig~linux-next-git-rejects arch/arm/configs/magician_defconfig
--- a/arch/arm/configs/magician_defconfig~linux-next-git-rejects
+++ a/arch/arm/configs/magician_defconfig
@@ -748,10 +748,7 @@ CONFIG_I2C_PXA=y
 # Miscellaneous I2C Chip support
 #
 # CONFIG_DS1682 is not set
-<<<<<<< HEAD:arch/arm/configs/magician_defconfig
-=======
 # CONFIG_AT24 is not set
->>>>>>> FETCH_HEAD:arch/arm/configs/magician_defconfig
 # CONFIG_EEPROM_LEGACY is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
diff -puN fs/Kconfig~linux-next-git-rejects fs/Kconfig
--- a/fs/Kconfig~linux-next-git-rejects
+++ a/fs/Kconfig
@@ -250,10 +250,6 @@ menuconfig NETWORK_FILESYSTEMS
 
 if NETWORK_FILESYSTEMS
 
-<<<<<<< HEAD:fs/Kconfig
-source "fs/nfs/Kconfig"
-source "fs/nfsd/Kconfig"
-=======
 config NFS_FS
 	tristate "NFS client support"
 	depends on INET
@@ -430,7 +426,6 @@ config NFSD_V4
 	  available from http://linux-nfs.org/.
 
 	  If unsure, say N.
->>>>>>> FETCH_HEAD:fs/Kconfig
 
 config LOCKD
 	tristate
@@ -452,10 +447,6 @@ config NFS_COMMON
 	depends on NFSD || NFS_FS
 	default y
 
-<<<<<<< HEAD:fs/Kconfig
-source "net/sunrpc/Kconfig"
-source "fs/smbfs/Kconfig"
-=======
 config SUNRPC
 	tristate
 
@@ -591,14 +582,8 @@ config SMB_NLS_REMOTE
 
 	  smbmount from samba 2.2.0 or later supports this.
 
->>>>>>> FETCH_HEAD:fs/Kconfig
 source "fs/cifs/Kconfig"
 source "fs/ncpfs/Kconfig"
-<<<<<<< HEAD:fs/Kconfig
-source "fs/coda/Kconfig"
-source "fs/afs/Kconfig"
-source "fs/9p/Kconfig"
-=======
 
 config CODA_FS
 	tristate "Coda file system support (advanced network fs)"
@@ -662,7 +647,6 @@ config 9P_FS
 	  See <http://v9fs.sf.net> for more information.
 
 	  If unsure, say N.
->>>>>>> FETCH_HEAD:fs/Kconfig
 
 endif # NETWORK_FILESYSTEMS
 
diff -puN include/linux/debugfs.h~linux-next-git-rejects include/linux/debugfs.h
--- a/include/linux/debugfs.h~linux-next-git-rejects
+++ a/include/linux/debugfs.h
@@ -162,16 +162,10 @@ static inline struct dentry *debugfs_cre
 	return ERR_PTR(-ENODEV);
 }
 
-<<<<<<< HEAD:include/linux/debugfs.h
-static inline struct dentry *debugfs_create_size_t(const char *name, mode_t mode,
-				     struct dentry *parent,
-				     size_t *value)
-=======
 static inline struct dentry *debugfs_create_size_t(const char *name,
 						   mode_t mode,
 						   struct dentry *parent,
 						   size_t *value)
->>>>>>> FETCH_HEAD:include/linux/debugfs.h
 {
 	return ERR_PTR(-ENODEV);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
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

