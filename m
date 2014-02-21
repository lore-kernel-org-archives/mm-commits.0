From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 21 Feb 2014 11:24:29 -0800
Message-ID: <5307a7ed.cwPQSGJuqTR7wxVq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaBUTYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 14:24:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 11:24:29 -0800


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-core.c          |    3 ---
 drivers/hid/hid-ids.h           |    3 ---
 drivers/hid/i2c-hid/i2c-hid.c   |    6 ------
 drivers/net/bonding/bond_3ad.h  |    5 -----
 drivers/net/bonding/bond_main.c |    6 ------
 5 files changed, 23 deletions(-)

diff -puN drivers/hid/hid-core.c~linux-next-git-rejects drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~linux-next-git-rejects
+++ a/drivers/hid/hid-core.c
@@ -1824,12 +1824,9 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_USB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
-<<<<<<< HEAD
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2) },
-=======
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_OFFICE_KB) },
->>>>>>> linux-next/akpm-base
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1) },
diff -puN drivers/hid/hid-ids.h~linux-next-git-rejects drivers/hid/hid-ids.h
--- a/drivers/hid/hid-ids.h~linux-next-git-rejects
+++ a/drivers/hid/hid-ids.h
@@ -241,11 +241,8 @@
 
 #define USB_VENDOR_ID_CYGNAL		0x10c4
 #define USB_DEVICE_ID_CYGNAL_RADIO_SI470X	0x818a
-<<<<<<< HEAD
 #define USB_DEVICE_ID_FOCALTECH_FTXXXX_MULTITOUCH	0x81b9
-=======
 #define USB_DEVICE_ID_CYGNAL_CP2112	0xea90
->>>>>>> linux-next/akpm-base
 
 #define USB_DEVICE_ID_CYGNAL_RADIO_SI4713       0x8244
 
diff -puN drivers/hid/i2c-hid/i2c-hid.c~linux-next-git-rejects drivers/hid/i2c-hid/i2c-hid.c
--- a/drivers/hid/i2c-hid/i2c-hid.c~linux-next-git-rejects
+++ a/drivers/hid/i2c-hid/i2c-hid.c
@@ -603,11 +603,6 @@ static int __i2c_hid_output_raw_report(s
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
 	bool data = true; /* SET_REPORT */
 
-<<<<<<< HEAD
-	buf = hid_alloc_report_buf(rep, GFP_KERNEL);
-	if (!buf)
-		return;
-=======
 	if (report_type == HID_OUTPUT_REPORT)
 		data = le16_to_cpu(ihid->hdesc.wMaxOutputLength) == 0;
 
@@ -620,7 +615,6 @@ static int i2c_hid_output_report(struct
 	return i2c_hid_output_raw_report(hid, buf, count, HID_OUTPUT_REPORT,
 			false);
 }
->>>>>>> linux-next/akpm-base
 
 static int i2c_hid_raw_request(struct hid_device *hid, unsigned char reportnum,
 			       __u8 *buf, size_t len, unsigned char rtype,
diff -puN drivers/net/bonding/bond_3ad.h~linux-next-git-rejects drivers/net/bonding/bond_3ad.h
--- a/drivers/net/bonding/bond_3ad.h~linux-next-git-rejects
+++ a/drivers/net/bonding/bond_3ad.h
@@ -251,13 +251,8 @@ struct ad_system {
 #define SLAVE_AD_INFO(slave) ((slave)->ad_info)
 
 struct ad_bond_info {
-<<<<<<< HEAD
-	struct ad_system system;	    /* 802.3ad system structure */
-	u32 agg_select_timer;	    // Timer to select aggregator after all adapter's hand shakes
-=======
 	struct ad_system system;	/* 802.3ad system structure */
 	u32 agg_select_timer;		/* Timer to select aggregator after all adapter's hand shakes */
->>>>>>> linux-next/akpm-base
 	u16 aggregator_identifier;
 };
 
diff -puN drivers/net/bonding/bond_main.c~linux-next-git-rejects drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~linux-next-git-rejects
+++ a/drivers/net/bonding/bond_main.c
@@ -2859,15 +2859,9 @@ static int bond_slave_netdev_event(unsig
 			break;
 		}
 
-<<<<<<< HEAD
-		pr_info("%s: Primary slave changed to %s, reselecting active slave.\n",
-			bond->dev->name, bond->primary_slave ? slave_dev->name :
-							       "none");
-=======
 		pr_info("%s: Primary slave changed to %s, reselecting active slave\n",
 			bond->dev->name,
 			bond->primary_slave ? slave_dev->name : "none");
->>>>>>> linux-next/akpm-base
 
 		block_netpoll_tx();
 		write_lock_bh(&bond->curr_slave_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

