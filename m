From: akpm@linux-foundation.org
Subject: [merged]
 const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:13 -0700
Message-ID: <57fe8da1.xnCfxyAOtRPVg9pZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755987AbcJLTYb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, julia.lawall@lip6.fr, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add frequently used from Julia Lawall's list
has been removed from the -mm tree.  Its filename was
     const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: const_structs.checkpatch: add frequently used from Julia Lawall's list

Using const is generally a good idea.

Julia Lawall has created a list of always const and almost always const
structs in the kernel sources.

Link: https://lkml.org/lkml/2016/8/28/95

Add the most frequently used (> 50 cases) that are almost always or
always const.

Link: http://lkml.kernel.org/r/1e16020f8027654db0095bbfbcc11da51025365c.1472664220.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN scripts/const_structs.checkpatch~const_structscheckpatch-add-frequently-used-from-julia-lawalls-list scripts/const_structs.checkpatch
--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-frequently-used-from-julia-lawalls-list
+++ a/scripts/const_structs.checkpatch
@@ -2,38 +2,63 @@ acpi_dock_ops
 address_space_operations
 backlight_ops
 block_device_operations
+clk_ops
+comedi_lrange
+component_ops
 dentry_operations
 dev_pm_ops
 dma_map_ops
+driver_info
+drm_connector_funcs
+drm_encoder_funcs
+drm_encoder_helper_funcs
+ethtool_ops
 extent_io_ops
 file_lock_operations
 file_operations
 hv_ops
 ide_dma_ops
+ide_port_ops
+inode_operations
 intel_dvo_dev_ops
+irq_domain_ops
 item_operations
+iwl_cfg
 iwl_ops
 kgdb_arch
 kgdb_io
 kset_uevent_ops
 lock_manager_operations
+machine_desc
 microcode_ops
+mlxsw_reg_info
 mtrr_ops
 neigh_ops
+net_device_ops
 nlmsvc_binding
+nvkm_device_chip
 of_device_id
 pci_raw_ops
 pipe_buf_operations
 platform_hibernation_ops
 platform_suspend_ops
 proto_ops
+regmap_access_table
 rpc_pipe_ops
+rtc_class_ops
+sd_desc
 seq_operations
+sirfsoc_padmux
 snd_ac97_build_ops
+snd_soc_component_driver
 soc_pcmcia_socket_ops
 stacktrace_ops
 sysfs_ops
 tty_operations
 uart_ops
 usb_mon_operations
+v4l2_ctrl_ops
+v4l2_ioctl_ops
+vm_operations_struct
+wacom_features
 wd_ops
_

Patches currently in -mm which might be from joe@perches.com are


