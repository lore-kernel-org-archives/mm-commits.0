From: akpm@linux-foundation.org
Subject: +
 const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch
 added to -mm tree
Date: Wed, 31 Aug 2016 13:22:20 -0700
Message-ID: <57c73c7c./rxKsUjx1SeV5h2K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48791 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753126AbcHaUWi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2016 16:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, julia.lawall@lip6.fr, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add frequently used from Julia Lawall's list
has been added to the -mm tree.  Its filename is
     const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Kees Cook <keescook@chromium.org>
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

wd719x-remove-last-declaration-using-define_pci_device_table.patch
treewide-remove-references-to-the-now-unnecessary-define_pci_device_table.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
meminfo-break-apart-a-very-long-seq_printf-with-ifdefs.patch
spellingtxt-modeled-is-spelt-correctly.patch
checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead.patch
checkpatch-test-multiple-line-block-comment-alignment.patch
checkpatch-dont-test-for-prefer-ether_addr_foo.patch
checkpatch-externalize-the-structs-that-should-be-const.patch
const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch

