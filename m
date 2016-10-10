From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:41:48 -0700
Message-ID: <57fc192c.qCpeilyvM7dz/2H0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37355 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbcJJWuu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


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

 Documentation/conf.py                            |    3 
 Documentation/gpu/index.rst                      |    3 
 Documentation/media/conf_nitpick.py              |   57 -------------
 Documentation/media/index.rst                    |    3 
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst |    5 -
 Documentation/sphinx-static/theme_overrides.css  |    4 
 drivers/char/tpm/tpm-interface.c                 |    6 -
 drivers/char/tpm/tpm_crb.c                       |    3 
 drivers/staging/octeon/ethernet-mdio.c           |    3 
 fs/afs/main.c                                    |    3 
 include/linux/raid/pq.h                          |    3 
 include/linux/sysctl.h                           |    5 -
 include/net/netfilter/nf_tables_ipv4.h           |    4 
 net/netfilter/core.c                             |   28 ------
 net/netfilter/xt_hashlimit.c                     |   14 ---
 15 files changed, 144 deletions(-)

diff -puN Documentation/conf.py~linux-next-git-rejects Documentation/conf.py
--- a/Documentation/conf.py~linux-next-git-rejects
+++ a/Documentation/conf.py
@@ -341,11 +341,8 @@ latex_documents = [
     ('development-process/index', 'development-process.tex', 'Linux Kernel Development Documentation',
      'The kernel development community', 'manual'),
     ('gpu/index', 'gpu.tex', 'Linux GPU Driver Developer\'s Guide',
-<<<<<<< HEAD
-=======
      'The kernel development community', 'manual'),
     ('media/index', 'media.tex', 'Linux Media Subsystem Documentation',
->>>>>>> linux-next/akpm-base
      'The kernel development community', 'manual'),
 ]
 
diff -puN Documentation/gpu/index.rst~linux-next-git-rejects Documentation/gpu/index.rst
--- a/Documentation/gpu/index.rst~linux-next-git-rejects
+++ a/Documentation/gpu/index.rst
@@ -12,10 +12,7 @@ Linux GPU Driver Developer's Guide
    drm-uapi
    i915
    vga-switcheroo
-<<<<<<< HEAD
-=======
    vgaarbiter
->>>>>>> linux-next/akpm-base
 
 .. only::  subproject
 
diff -puN Documentation/media/conf_nitpick.py~linux-next-git-rejects Documentation/media/conf_nitpick.py
--- a/Documentation/media/conf_nitpick.py~linux-next-git-rejects
+++ a/Documentation/media/conf_nitpick.py
@@ -21,12 +21,6 @@ nitpick_ignore = [
     ("c:func", "clock_gettime"),
     ("c:func", "close"),
     ("c:func", "container_of"),
-<<<<<<< HEAD
-    ("c:func", "determine_valid_ioctls"),
-    ("c:func", "ERR_PTR"),
-    ("c:func", "ioctl"),
-    ("c:func", "IS_ERR"),
-=======
     ("c:func", "copy_from_user"),
     ("c:func", "copy_to_user"),
     ("c:func", "determine_valid_ioctls"),
@@ -35,7 +29,6 @@ nitpick_ignore = [
     ("c:func", "ioctl"),
     ("c:func", "IS_ERR"),
     ("c:func", "KERNEL_VERSION"),
->>>>>>> linux-next/akpm-base
     ("c:func", "mmap"),
     ("c:func", "open"),
     ("c:func", "pci_name"),
@@ -47,11 +40,6 @@ nitpick_ignore = [
     ("c:func", "struct fd_set"),
     ("c:func", "struct pollfd"),
     ("c:func", "usb_make_path"),
-<<<<<<< HEAD
-    ("c:func", "write"),
-    ("c:type", "atomic_t"),
-    ("c:type", "bool"),
-=======
     ("c:func", "wait_finish"),
     ("c:func", "wait_prepare"),
     ("c:func", "write"),
@@ -59,35 +47,24 @@ nitpick_ignore = [
     ("c:type", "atomic_t"),
     ("c:type", "bool"),
     ("c:type", "boolean"),
->>>>>>> linux-next/akpm-base
     ("c:type", "buf_queue"),
     ("c:type", "device"),
     ("c:type", "device_driver"),
     ("c:type", "device_node"),
     ("c:type", "enum"),
-<<<<<<< HEAD
-=======
     ("c:type", "fd"),
     ("c:type", "fd_set"),
->>>>>>> linux-next/akpm-base
     ("c:type", "file"),
     ("c:type", "i2c_adapter"),
     ("c:type", "i2c_board_info"),
     ("c:type", "i2c_client"),
-<<<<<<< HEAD
-=======
     ("c:type", "int16_t"),
->>>>>>> linux-next/akpm-base
     ("c:type", "ktime_t"),
     ("c:type", "led_classdev_flash"),
     ("c:type", "list_head"),
     ("c:type", "lock_class_key"),
     ("c:type", "module"),
     ("c:type", "mutex"),
-<<<<<<< HEAD
-    ("c:type", "pci_dev"),
-    ("c:type", "pdvbdev"),
-=======
     ("c:type", "NULL"),
     ("c:type", "off_t"),
     ("c:type", "pci_dev"),
@@ -95,43 +72,10 @@ nitpick_ignore = [
     ("c:type", "poll_table"),
     ("c:type", "platform_device"),
     ("c:type", "pollfd"),
->>>>>>> linux-next/akpm-base
     ("c:type", "poll_table_struct"),
     ("c:type", "s32"),
     ("c:type", "s64"),
     ("c:type", "sd"),
-<<<<<<< HEAD
-    ("c:type", "spi_board_info"),
-    ("c:type", "spi_device"),
-    ("c:type", "spi_master"),
-    ("c:type", "struct fb_fix_screeninfo"),
-    ("c:type", "struct pollfd"),
-    ("c:type", "struct timeval"),
-    ("c:type", "struct video_capability"),
-    ("c:type", "u16"),
-    ("c:type", "u32"),
-    ("c:type", "u64"),
-    ("c:type", "u8"),
-    ("c:type", "union"),
-    ("c:type", "usb_device"),
-
-    ("cpp:type", "boolean"),
-    ("cpp:type", "fd"),
-    ("cpp:type", "fd_set"),
-    ("cpp:type", "int16_t"),
-    ("cpp:type", "NULL"),
-    ("cpp:type", "off_t"),
-    ("cpp:type", "pollfd"),
-    ("cpp:type", "size_t"),
-    ("cpp:type", "ssize_t"),
-    ("cpp:type", "timeval"),
-    ("cpp:type", "__u16"),
-    ("cpp:type", "__u32"),
-    ("cpp:type", "__u64"),
-    ("cpp:type", "uint16_t"),
-    ("cpp:type", "uint32_t"),
-    ("cpp:type", "video_system_t"),
-=======
     ("c:type", "size_t"),
     ("c:type", "spi_board_info"),
     ("c:type", "spi_device"),
@@ -162,5 +106,4 @@ nitpick_ignore = [
     # Opaque structures
 
     ("c:type", "v4l2_m2m_dev"),
->>>>>>> linux-next/akpm-base
 ]
diff -puN Documentation/media/index.rst~linux-next-git-rejects Documentation/media/index.rst
--- a/Documentation/media/index.rst~linux-next-git-rejects
+++ a/Documentation/media/index.rst
@@ -1,14 +1,11 @@
 Linux Media Subsystem Documentation
 ===================================
 
-<<<<<<< HEAD
-=======
 .. Sphinx 1.4.x has a definition for DUrole that doesn't work on alltt blocks
 .. raw:: latex
 
 	\renewcommand*{\DUrole}[2]{ #2 }
 
->>>>>>> linux-next/akpm-base
 Contents:
 
 .. toctree::
diff -puN Documentation/media/uapi/cec/cec-ioc-dqevent.rst~linux-next-git-rejects Documentation/media/uapi/cec/cec-ioc-dqevent.rst
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst~linux-next-git-rejects
+++ a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -15,13 +15,8 @@ CEC_DQEVENT - Dequeue a CEC event
 Synopsis
 ========
 
-<<<<<<< HEAD
-.. c:function:: int ioctl( int fd, int request, struct cec_event *argp )
-   :name: CEC_DQEVENT
-=======
 .. c:function:: int ioctl( int fd, CEC_DQEVENT, struct cec_event *argp )
     :name: CEC_DQEVENT
->>>>>>> linux-next/akpm-base
 
 Arguments
 =========
diff -puN Documentation/sphinx-static/theme_overrides.css~linux-next-git-rejects Documentation/sphinx-static/theme_overrides.css
--- a/Documentation/sphinx-static/theme_overrides.css~linux-next-git-rejects
+++ a/Documentation/sphinx-static/theme_overrides.css
@@ -56,11 +56,7 @@
 	font-family: "Courier New", Courier, monospace
     }
 
-<<<<<<< HEAD
-    /* inline literal: drop the borderbox, padding and red color */
-=======
     /* inline literal: drop the borderbox and red color */
->>>>>>> linux-next/akpm-base
 
     code, .rst-content tt, .rst-content code {
         color: inherit;
diff -puN drivers/char/tpm/tpm-interface.c~linux-next-git-rejects drivers/char/tpm/tpm-interface.c
--- a/drivers/char/tpm/tpm-interface.c~linux-next-git-rejects
+++ a/drivers/char/tpm/tpm-interface.c
@@ -356,11 +356,8 @@ ssize_t tpm_transmit(struct tpm_chip *ch
 
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_lock(&chip->tpm_mutex);
-<<<<<<< HEAD
-=======
 
 	pm_runtime_get_sync(chip->dev.parent);
->>>>>>> linux-next/akpm-base
 
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
@@ -403,11 +400,8 @@ out_recv:
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
-<<<<<<< HEAD
-=======
 	pm_runtime_put_sync(chip->dev.parent);
 
->>>>>>> linux-next/akpm-base
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_unlock(&chip->tpm_mutex);
 	return rc;
diff -puN drivers/char/tpm/tpm_crb.c~linux-next-git-rejects drivers/char/tpm/tpm_crb.c
--- a/drivers/char/tpm/tpm_crb.c~linux-next-git-rejects
+++ a/drivers/char/tpm/tpm_crb.c
@@ -19,10 +19,7 @@
 #include <linux/highmem.h>
 #include <linux/rculist.h>
 #include <linux/module.h>
-<<<<<<< HEAD
-=======
 #include <linux/pm_runtime.h>
->>>>>>> linux-next/akpm-base
 #include "tpm.h"
 
 #define ACPI_SIG_TPM2 "TPM2"
diff -puN drivers/staging/octeon/ethernet-mdio.c~linux-next-git-rejects drivers/staging/octeon/ethernet-mdio.c
--- a/drivers/staging/octeon/ethernet-mdio.c~linux-next-git-rejects
+++ a/drivers/staging/octeon/ethernet-mdio.c
@@ -168,10 +168,7 @@ int cvm_oct_phy_setup_device(struct net_
 
 	phydev = of_phy_connect(dev, phy_node, cvm_oct_adjust_link, 0,
 				PHY_INTERFACE_MODE_GMII);
-<<<<<<< HEAD
-=======
 	of_node_put(phy_node);
->>>>>>> linux-next/akpm-base
 
 	if (!phydev)
 		return -ENODEV;
diff -puN fs/afs/main.c~linux-next-git-rejects fs/afs/main.c
--- a/fs/afs/main.c~linux-next-git-rejects
+++ a/fs/afs/main.c
@@ -15,10 +15,7 @@
 #include <linux/completion.h>
 #include <linux/sched.h>
 #include <linux/random.h>
-<<<<<<< HEAD
-=======
 #include <linux/ktime.h>
->>>>>>> linux-next/akpm-base
 #include "internal.h"
 
 MODULE_DESCRIPTION("AFS Client File System");
diff -puN include/linux/raid/pq.h~linux-next-git-rejects include/linux/raid/pq.h
--- a/include/linux/raid/pq.h~linux-next-git-rejects
+++ a/include/linux/raid/pq.h
@@ -119,10 +119,7 @@ struct raid6_recov_calls {
 extern const struct raid6_recov_calls raid6_recov_intx1;
 extern const struct raid6_recov_calls raid6_recov_ssse3;
 extern const struct raid6_recov_calls raid6_recov_avx2;
-<<<<<<< HEAD
-=======
 extern const struct raid6_recov_calls raid6_recov_avx512;
->>>>>>> linux-next/akpm-base
 extern const struct raid6_recov_calls raid6_recov_s390xc;
 
 extern const struct raid6_calls raid6_neonx1;
diff -puN include/linux/sysctl.h~linux-next-git-rejects include/linux/sysctl.h
--- a/include/linux/sysctl.h~linux-next-git-rejects
+++ a/include/linux/sysctl.h
@@ -158,12 +158,7 @@ struct ctl_table_set {
 
 struct ctl_table_root {
 	struct ctl_table_set default_set;
-<<<<<<< HEAD
-	struct ctl_table_set *(*lookup)(struct ctl_table_root *root,
-					   struct nsproxy *namespaces);
-=======
 	struct ctl_table_set *(*lookup)(struct ctl_table_root *root);
->>>>>>> linux-next/akpm-base
 	void (*set_ownership)(struct ctl_table_header *head,
 			      struct ctl_table *table,
 			      kuid_t *uid, kgid_t *gid);
diff -puN include/net/netfilter/nf_tables_ipv4.h~linux-next-git-rejects include/net/netfilter/nf_tables_ipv4.h
--- a/include/net/netfilter/nf_tables_ipv4.h~linux-next-git-rejects
+++ a/include/net/netfilter/nf_tables_ipv4.h
@@ -33,10 +33,6 @@ __nft_set_pktinfo_ipv4_validate(struct n
 	if (!iph)
 		return -1;
 
-<<<<<<< HEAD
-	iph = ip_hdr(skb);
-=======
->>>>>>> linux-next/akpm-base
 	if (iph->ihl < 5 || iph->version != 4)
 		return -1;
 
diff -puN net/netfilter/core.c~linux-next-git-rejects net/netfilter/core.c
--- a/net/netfilter/core.c~linux-next-git-rejects
+++ a/net/netfilter/core.c
@@ -90,18 +90,12 @@ static void nf_set_hooks_head(struct net
 {
 	switch (reg->pf) {
 	case NFPROTO_NETDEV:
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_NETFILTER_INGRESS
->>>>>>> linux-next/akpm-base
 		/* We already checked in nf_register_net_hook() that this is
 		 * used from ingress.
 		 */
 		rcu_assign_pointer(reg->dev->nf_hooks_ingress, entry);
-<<<<<<< HEAD
-=======
 #endif
->>>>>>> linux-next/akpm-base
 		break;
 	default:
 		rcu_assign_pointer(net->nf.hooks[reg->pf][reg->hooknum],
@@ -115,12 +109,6 @@ int nf_register_net_hook(struct net *net
 	struct nf_hook_entry *hooks_entry;
 	struct nf_hook_entry *entry;
 
-<<<<<<< HEAD
-	if (reg->pf == NFPROTO_NETDEV &&
-	    (reg->hooknum != NF_NETDEV_INGRESS ||
-	     !reg->dev || dev_net(reg->dev) != net))
-		return -EINVAL;
-=======
 	if (reg->pf == NFPROTO_NETDEV) {
 #ifndef CONFIG_NETFILTER_INGRESS
 		if (reg->hooknum == NF_NETDEV_INGRESS)
@@ -130,7 +118,6 @@ int nf_register_net_hook(struct net *net
 		    !reg->dev || dev_net(reg->dev) != net)
 			return -EINVAL;
 	}
->>>>>>> linux-next/akpm-base
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
@@ -153,17 +140,6 @@ int nf_register_net_hook(struct net *net
 		reg->priority >= hooks_entry->orig_ops->priority &&
 		nf_entry_dereference(hooks_entry->next)) {
 		hooks_entry = nf_entry_dereference(hooks_entry->next);
-<<<<<<< HEAD
-	}
-
-	if (hooks_entry) {
-		entry->next = nf_entry_dereference(hooks_entry->next);
-		rcu_assign_pointer(hooks_entry->next, entry);
-	} else {
-		nf_set_hooks_head(net, reg, entry);
-	}
-
-=======
 	}
 
 	if (hooks_entry) {
@@ -173,7 +149,6 @@ int nf_register_net_hook(struct net *net
 		nf_set_hooks_head(net, reg, entry);
 	}
 
->>>>>>> linux-next/akpm-base
 	mutex_unlock(&nf_hook_mutex);
 #ifdef CONFIG_NETFILTER_INGRESS
 	if (reg->pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
@@ -192,11 +167,8 @@ void nf_unregister_net_hook(struct net *
 
 	mutex_lock(&nf_hook_mutex);
 	hooks_entry = nf_hook_entry_head(net, reg);
-<<<<<<< HEAD
-	if (hooks_entry->orig_ops == reg) {
 =======
 	if (hooks_entry && hooks_entry->orig_ops == reg) {
->>>>>>> linux-next/akpm-base
 		nf_set_hooks_head(net, reg,
 				  nf_entry_dereference(hooks_entry->next));
 		goto unlock;
diff -puN net/netfilter/xt_hashlimit.c~linux-next-git-rejects net/netfilter/xt_hashlimit.c
--- a/net/netfilter/xt_hashlimit.c~linux-next-git-rejects
+++ a/net/netfilter/xt_hashlimit.c
@@ -467,19 +467,6 @@ static u64 user2credits(u64 user, int re
 		/* If multiplying would overflow... */
 		if (user > 0xFFFFFFFF / (HZ*CREDITS_PER_JIFFY_v1))
 			/* Divide first. */
-<<<<<<< HEAD
-			return (user / XT_HASHLIMIT_SCALE) *\
-						HZ * CREDITS_PER_JIFFY_v1;
-
-		return (user * HZ * CREDITS_PER_JIFFY_v1) \
-						/ XT_HASHLIMIT_SCALE;
-	} else {
-		if (user > 0xFFFFFFFFFFFFFFFF / (HZ*CREDITS_PER_JIFFY))
-			return (user / XT_HASHLIMIT_SCALE_v2) *\
-						HZ * CREDITS_PER_JIFFY;
-
-		return (user * HZ * CREDITS_PER_JIFFY) / XT_HASHLIMIT_SCALE_v2;
-=======
 			return div64_u64(user, XT_HASHLIMIT_SCALE)
 				* HZ * CREDITS_PER_JIFFY_v1;
 
@@ -492,7 +479,6 @@ static u64 user2credits(u64 user, int re
 
 		return div64_u64(user * HZ * CREDITS_PER_JIFFY,
 				 XT_HASHLIMIT_SCALE_v2);
->>>>>>> linux-next/akpm-base
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
lib-bitmapc-enhance-bitmap-syntax-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

