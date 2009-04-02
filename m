From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 02 Apr 2009 11:22:25 -0700
Message-ID: <200904021822.n32IMPBG022643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759498AbZDBSXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 14:23:05 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n32IMPmt020160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 2 Apr 2009 11:23:01 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    3 ---
 fs/nfs/file.c                              |    6 +-----
 net/sunrpc/svcsock.c                       |    3 ---
 3 files changed, 1 insertion(+), 11 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~linux-next-git-rejects Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~linux-next-git-rejects
+++ a/Documentation/feature-removal-schedule.txt
@@ -376,8 +376,6 @@ Why:	See commits 129f8ae9b1b5be94517da76
 	cause the thermal throttling not to happen at the right time.
 Who:	Dave Jones <davej@redhat.com>, Matthew Garrett <mjg@redhat.com>
 
-<<<<<<< HEAD:Documentation/feature-removal-schedule.txt
-=======
 ---------------------------
 
 What:	i2c-voodoo3 driver
@@ -387,7 +385,6 @@ Why:	Superseded by tdfxfb. I2C/DDC suppo
 Who:	Jean Delvare <khali@linux-fr.org>
 	Krzysztof Helt <krzysztof.h1@wp.pl>
 
->>>>>>> FETCH_HEAD:Documentation/feature-removal-schedule.txt
 -----------------------------
 
 What:	__do_IRQ all in one fits nothing interrupt handler
diff -puN fs/nfs/file.c~linux-next-git-rejects fs/nfs/file.c
--- a/fs/nfs/file.c~linux-next-git-rejects
+++ a/fs/nfs/file.c
@@ -478,16 +478,12 @@ const struct address_space_operations nf
 	.launder_page = nfs_launder_page,
 };
 
-<<<<<<< HEAD:fs/nfs/file.c
-static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
-=======
 /*
  * Notification that a PTE pointing to an NFS page is about to be made
  * writable, implying that someone is about to modify the page through a
  * shared-writable mapping
  */
-static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct page *page)
->>>>>>> FETCH_HEAD:fs/nfs/file.c
+static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
 	struct file *filp = vma->vm_file;
diff -puN net/sunrpc/svcsock.c~linux-next-git-rejects net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~linux-next-git-rejects
+++ a/net/sunrpc/svcsock.c
@@ -1200,10 +1200,7 @@ static struct svc_sock *svc_setup_socket
 		svc_sock_setbufsize(svsk->sk_sock, 4 * serv->sv_max_mesg,
 					4 * serv->sv_max_mesg);
 		svc_tcp_init(svsk, serv);
-<<<<<<< HEAD:net/sunrpc/svcsock.c
-=======
 	}
->>>>>>> FETCH_HEAD:net/sunrpc/svcsock.c
 
 	dprintk("svc: svc_setup_socket created %p (inet %p)\n",
 				svsk, svsk->sk_sk);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes.patch
simplify-copy_thread-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
kernel-auditscc-fix-warning.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

