From: akpm@osdl.org
Subject: - kernel-doc-add-fusion-and-i2o-to-kernel-api-book.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:42 -0800
Message-ID: <200612072306.kB7N6gO9030285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163806AbWLGXHH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: add fusion and i2o to kernel-api book
has been removed from the -mm tree.  Its filename was
     kernel-doc-add-fusion-and-i2o-to-kernel-api-book.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: add fusion and i2o to kernel-api book
From: Randy Dunlap <randy.dunlap@oracle.com>

Add Fusion and I2O message-based device interfaces to kernel-api book.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/DocBook/kernel-api.tmpl |   31 ++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff -puN Documentation/DocBook/kernel-api.tmpl~kernel-doc-add-fusion-and-i2o-to-kernel-api-book Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~kernel-doc-add-fusion-and-i2o-to-kernel-api-book
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -423,6 +423,37 @@ X!Edrivers/pnp/system.c
 !Edrivers/media/video/videodev.c
   </chapter>
 
+  <chapter id="message_devices">
+	<title>Message-based devices</title>
+     <sect1><title>Fusion message devices</title>
+!Edrivers/message/fusion/mptbase.c
+!Idrivers/message/fusion/mptbase.c
+!Edrivers/message/fusion/mptscsih.c
+!Idrivers/message/fusion/mptscsih.c
+!Idrivers/message/fusion/mptctl.c
+!Idrivers/message/fusion/mptspi.c
+!Idrivers/message/fusion/mptfc.c
+!Idrivers/message/fusion/mptlan.c
+     </sect1>
+     <sect1><title>I2O message devices</title>
+!Iinclude/linux/i2o.h
+!Idrivers/message/i2o/core.h
+!Edrivers/message/i2o/iop.c
+!Idrivers/message/i2o/iop.c
+!Idrivers/message/i2o/config-osm.c
+!Edrivers/message/i2o/exec-osm.c
+!Idrivers/message/i2o/exec-osm.c
+!Idrivers/message/i2o/bus-osm.c
+!Edrivers/message/i2o/device.c
+!Idrivers/message/i2o/device.c
+!Idrivers/message/i2o/driver.c
+!Idrivers/message/i2o/pci.c
+!Idrivers/message/i2o/i2o_block.c
+!Idrivers/message/i2o/i2o_scsi.c
+!Idrivers/message/i2o/i2o_proc.c
+     </sect1>
+  </chapter>
+
   <chapter id="snddev">
      <title>Sound Devices</title>
 !Iinclude/sound/core.h
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

