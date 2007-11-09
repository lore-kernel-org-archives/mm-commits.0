From: akpm@linux-foundation.org
Subject: - dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:12:52 -0800
Message-ID: <200711091912.lA9JCqBx027956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55427 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbXKITNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     dvb-usb/gp8psk.c: #if 0 gp8psk_bcm4500_reload()
has been removed from the -mm tree.  Its filename was
     dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dvb-usb/gp8psk.c: #if 0 gp8psk_bcm4500_reload()
From: Adrian Bunk <bunk@kernel.org>

This patch #if 0's the unused gp8psk_bcm4500_reload()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/gp8psk.c |    2 ++
 drivers/media/dvb/dvb-usb/gp8psk.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/media/dvb/dvb-usb/gp8psk.c~dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload drivers/media/dvb/dvb-usb/gp8psk.c
--- a/drivers/media/dvb/dvb-usb/gp8psk.c~dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload
+++ a/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -171,6 +171,7 @@ static int gp8psk_power_ctrl(struct dvb_
 	return 0;
 }
 
+#if 0
 int gp8psk_bcm4500_reload(struct dvb_usb_device *d)
 {
 	u8 buf;
@@ -187,6 +188,7 @@ int gp8psk_bcm4500_reload(struct dvb_usb
 			return EINVAL;
 	return 0;
 }
+#endif  /*  0  */
 
 static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
diff -puN drivers/media/dvb/dvb-usb/gp8psk.h~dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload drivers/media/dvb/dvb-usb/gp8psk.h
--- a/drivers/media/dvb/dvb-usb/gp8psk.h~dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload
+++ a/drivers/media/dvb/dvb-usb/gp8psk.h
@@ -92,6 +92,5 @@ extern struct dvb_frontend * gp8psk_fe_a
 extern int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
 extern int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 			     u16 index, u8 *b, int blen);
-extern int gp8psk_bcm4500_reload(struct dvb_usb_device *d);
 
 #endif
_

Patches currently in -mm which might be from bunk@kernel.org are

lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
git-avr32.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
git-ocfs2.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
